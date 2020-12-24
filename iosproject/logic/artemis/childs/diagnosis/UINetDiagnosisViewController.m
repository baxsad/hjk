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
#import "HJKPing.h"
#import "HJKTraceroute.h"
#import "HJKDevice.h"
#import "HJKHostTools.h"

@interface UINetDiagnosisViewController () <HJKPingDelegate, HJKTracerouteDelegate>
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) HJKPing *ping;
@property (nonatomic, strong) HJKTraceroute *traceroute;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation UINetDiagnosisViewController

- (void)didInitialize {
    [super didInitialize];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    self.ping = [[HJKPing alloc] init];
    self.ping.delegate = self;
    
    self.traceroute = [[HJKTraceroute alloc] initWithMaxTTL:TRACEROUTE_MAX_TTL
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
    [info appendFormat:@"Application Name：%@\n",[HJKDevice getApplicationName]];
    [info appendFormat:@"Application Version：%@\n",[HJKDevice getApplicationVersion]];
    [info appendFormat:@"Machine Type：%@\n",[HJKDevice getDeviceName]];
    [info appendFormat:@"System Version：%@\n",[HJKDevice getDeviceVersion]];
    [info appendFormat:@"Operator：%@\n",[HJKDevice getOperatorName]];
    [info appendFormat:@"NetWork Type：%@\n",[HJKDevice getNetWorkType]];
    [info appendFormat:@"Local Native IP：%@\n",[HJKHostTools localNativeIPAddress]];
    [info appendFormat:@"Local Gateway IP：%@\n",[HJKHostTools localGatewayIPAddress]];
    [info appendFormat:@"Local DNS：%@\n",[HJKHostTools localDNSServers].description];
    [info appendFormat:@"Domain name resolution results：%@\n",[HJKHostTools remoteDNSServersWithHost:@"www.biyao.com"].description];
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

#pragma mark - <HJKPingDelegate>

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

#pragma mark - <HJKTracerouteDelegate>

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
