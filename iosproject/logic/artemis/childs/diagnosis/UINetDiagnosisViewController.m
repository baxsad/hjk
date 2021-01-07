//
//  UINetDiagnosisViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINetDiagnosisViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <CoreLocation/CoreLocation.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>

@interface UINetDiagnosisViewController () <ESCPPingDelegate, ESCPTracerouteDelegate>
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) ESCPPing *ping;
@property (nonatomic, strong) ESCPTraceroute *traceroute;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation UINetDiagnosisViewController

- (void)didInitialize {
    [super didInitialize];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    self.ping = [[ESCPPing alloc] init];
    self.ping.delegate = self;
    
    self.traceroute = [[ESCPTraceroute alloc] initWithMaxTTL:TRACEROUTE_MAX_TTL
                                                     timeout:TRACEROUTE_TIMEOUT
                                                 maxAttempts:TRACEROUTE_ATTEMPTS
                                                        port:TRACEROUTE_PORT];
    self.traceroute.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Network Diagnosis";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.textView.text = @"";
    NSMutableString *info = [[NSMutableString alloc] initWithString:self.textView.text];
    [info appendFormat:@"Application Name：%@\n",[ESCPDevice getApplicationName]];
    [info appendFormat:@"Application Version：%@\n",[ESCPDevice getApplicationVersion]];
    [info appendFormat:@"Machine Type：%@\n",[ESCPDevice getDeviceName]];
    [info appendFormat:@"System Version：%@\n",[ESCPDevice getDeviceVersion]];
    [info appendFormat:@"Operator：%@\n",[ESCPDevice getOperatorName]];
    [info appendFormat:@"NetWork Type：%@\n",[ESCPDevice getNetWorkType]];
    [info appendFormat:@"Local Native IP：%@\n",[ESCPHostTools localNativeIPAddress]];
    [info appendFormat:@"Local Gateway IP：%@\n",[ESCPHostTools localGatewayIPAddress]];
    [info appendFormat:@"Local DNS：%@\n",[ESCPHostTools localDNSServers].description];
    [info appendFormat:@"Domain name resolution results：%@\n",[ESCPHostTools remoteDNSServersWithHost:@"www.biyao.com"].description];
    [info appendString:@"Start Ping：www.biyao.com\n"];
    self.textView.text = info;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.ping runWithHostName:@"www.biyao.com" normalPing:YES];
    });
}

- (void)initSubviews {
    [super initSubviews];
    
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = self.view.backgroundColor;
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - <ESCPPingDelegate>

- (void)appendPingLog:(NSString *)pingLog {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *info = [[NSMutableString alloc] initWithString:self.textView.text];
        [info appendFormat:@"%@\n",pingLog];
        self.textView.text = info;
    });
}

- (void)netPingDidEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *info = [[NSMutableString alloc] initWithString:self.textView.text];
        [info appendFormat:@"End Ping\n"];
        [info appendFormat:@"Start TraceRoute：www.biyao.com\n"];
        self.textView.text = info;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.traceroute doTraceRoute:@"www.biyao.com"];
        });
    });
}

#pragma mark - <ESCPTracerouteDelegate>

- (void)appendRouteLog:(NSString *)routeLog {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *info = [[NSMutableString alloc] initWithString:self.textView.text];
        [info appendFormat:@"%@\n",routeLog];
        self.textView.text = info;
    });
}

- (void)traceRouteDidEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *info = [[NSMutableString alloc] initWithString:self.textView.text];
        [info appendFormat:@"End TraceRoute\n"];
        self.textView.text = info;
    });
}
@end
