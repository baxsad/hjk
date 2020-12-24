//
//  HJKViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/8/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKViewController.h"
#import "HJKCategories.h"

@interface HJKContentView : UIView

@end

@implementation HJKContentView

@end

@interface HJKViewController ()
@property (nonatomic, strong, readwrite) HJKContentView *contentView;
@end

@implementation HJKViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.hidesBottomBarWhenPushed = YES;
    self.supportedOrientationMask = SupportedOrientationMask;
    
    self.hjk_preferredStatusBarStyleBlock = ^UIStatusBarStyle{
        return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    };
    
    if (@available(iOS 11.0, *)) {
        self.hjk_prefersHomeIndicatorAutoHiddenBlock = ^BOOL{
            return NO;
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = UIViewControllerBackgroundColor;
    }
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationItems];
    [self setupToolbarItems];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed {
    [super setHidesBottomBarWhenPushed:hidesBottomBarWhenPushed];
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.supportedOrientationMask;
}
@end

@implementation HJKViewController (UISubclassingHooks)

- (void)initSubviews {
    
}

- (void)setupNavigationItems {
    
}

- (void)setupToolbarItems {
    
}
@end
