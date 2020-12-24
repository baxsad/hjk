//
//  UISocketRocketViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/8/25.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UISocketRocketViewController.h"
#import "SIMManager.h"
#import <Masonry/Masonry.h>

@interface UISocketRocketViewController () <SIMMessageListener,SIMConnListener>
@property (nonatomic, strong) UIButton *protocolButton;
@property (nonatomic, strong) UITextField *hostField;
@property (nonatomic, strong) UITextField *portField;
@property (nonatomic, strong) UIButton *connectButton;
@end

@implementation UISocketRocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[SIMManager sharedInstance] setConnListener:self];
    [[SIMManager sharedInstance] addMessageListener:self];
    
    NSURL *url = [SIMManager sharedInstance].url;
    [self.protocolButton setTitle:url.scheme forState:UIControlStateNormal];
    [self.hostField setText:url.host];
    [self.portField setText:url.port.stringValue];
    [self connectStateDidChange:[SIMManager sharedInstance].connectState error:nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    [self setTitle:@"WebSocket"];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.protocolButton.backgroundColor = [UIColor blueColor];
    [self.protocolButton setTitle:@"" forState:UIControlStateNormal];
    [self.protocolButton.titleLabel setFont:[UIFont systemFontOfSize:19 weight:UIFontWeightMedium]];
    [self.protocolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.protocolButton];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.left.equalTo(self.view).offset(5);
    }];
    
    self.portField = [[UITextField alloc] init];
    self.portField.enabled = NO;
    self.portField.backgroundColor = [UIColor lightGrayColor];
    self.portField.textAlignment = NSTextAlignmentCenter;
    self.portField.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    self.portField.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.portField];
    [self.portField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5);
        make.height.equalTo(self.protocolButton.mas_height);
        make.centerY.equalTo(self.protocolButton);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *colonLabel = [[UILabel alloc] init];
    colonLabel.text = @":";
    colonLabel.textAlignment = NSTextAlignmentCenter;
    colonLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    colonLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:colonLabel];
    [colonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.portField.mas_left);
        make.height.equalTo(self.protocolButton.mas_height);
        make.centerY.equalTo(self.protocolButton);
        make.width.mas_equalTo(10);
    }];
    
    self.hostField = [[UITextField alloc] init];
    self.hostField.enabled = NO;
    self.hostField.backgroundColor = [UIColor lightGrayColor];
    self.hostField.textAlignment = NSTextAlignmentCenter;
    self.hostField.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    self.hostField.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.hostField];
    [self.hostField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonLabel.mas_left);
        make.left.equalTo(self.protocolButton.mas_right).offset(5);
        make.height.equalTo(self.protocolButton.mas_height);
        make.centerY.equalTo(self.protocolButton);
    }];
    
    self.connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.connectButton setBackgroundColor:[UIColor orangeColor]];
    [self.connectButton setTitle:@"Connect:idel" forState:UIControlStateNormal];
    [self.connectButton.titleLabel setFont:[UIFont systemFontOfSize:19 weight:UIFontWeightMedium]];
    [self.connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.connectButton addTarget:self
                           action:@selector(connect)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.connectButton];
    [self.connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.protocolButton.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.height.mas_equalTo(30);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Actions

- (void)connect {
    if ([SIMManager sharedInstance].connectState != SIM_CONNECTED) {
        [[SIMManager sharedInstance] connect];
    }
}

#pragma mark - <SIMMessageListener>

- (void)receiveMessage:(NSString *)message {
    NSLog(@"ReceiveMessage : %@",message);
}

#pragma mark - <SIMConnListener>

- (void)connectStateDidChange:(SIMConnState)state error:(nullable NSError *)error {
    NSLog(@"SIMConnState : %@%@%@",@(state),error?@" - ":@"",error.localizedDescription?:@"");
    if (state == SIM_IDLE) {
        [self.connectButton setBackgroundColor:[UIColor orangeColor]];
        [self.connectButton setTitle:@"connect" forState:UIControlStateNormal];
    } else if (state == SIM_CONNECTING) {
        [self.connectButton setBackgroundColor:[UIColor purpleColor]];
        [self.connectButton setTitle:@"connecting" forState:UIControlStateNormal];
    } else if (state == SIM_CONNECTED) {
        [self.connectButton setBackgroundColor:[UIColor greenColor]];
        [self.connectButton setTitle:@"connected" forState:UIControlStateNormal];
    } else if (state == SIM_DISCONNECTED) {
        [self.connectButton setBackgroundColor:[UIColor redColor]];
        [self.connectButton setTitle:@"disconnected" forState:UIControlStateNormal];
    } else if (state == SIM_OFFLINE) {
        [self.connectButton setBackgroundColor:[UIColor blackColor]];
        [self.connectButton setTitle:@"offline" forState:UIControlStateNormal];
    }
}

- (void)reconnectWithNumberOfTimes:(NSInteger)times {
    NSLog(@"第 %@ 次重连！",@(times));
}
@end
