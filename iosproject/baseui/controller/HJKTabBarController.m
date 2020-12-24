//
//  HJKTabBarController.m
//  iosproject
//
//  Created by hlcisy on 2020/9/11.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKTabBarController.h"
#import "HJKCategories.h"
#import "HJKCore.h"

@interface HJKTabBarController ()

@end

@implementation HJKTabBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    // subclass hooking
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - StatusBar

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *childViewController = [super childViewControllerForStatusBarStyle];
    
    BOOL implementationBlock  = childViewController.hjk_preferredStatusBarStyleBlock != nil;
    BOOL implementationMethod = [childViewController hjk_hasOverrideUIKitMethod:@selector(preferredStatusBarStyle)];
    
    BOOL hasOverride = implementationBlock || implementationMethod;
    if (hasOverride) {
        return childViewController;
    }
    
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    if (self.presentedViewController) {
        return [self.presentedViewController shouldAutorotate];
    } else if ([self.selectedViewController hjk_hasOverrideUIKitMethod:_cmd]) {
        return [self.selectedViewController shouldAutorotate];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *visibleViewController = self.presentedViewController;
    if (!visibleViewController || visibleViewController.isBeingDismissed || [visibleViewController isKindOfClass:UIAlertController.class]) {
        visibleViewController = self.selectedViewController;
    }
    
    if ([visibleViewController isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
        return visibleViewController.supportedInterfaceOrientations;
    }
    
    if ([visibleViewController hjk_hasOverrideUIKitMethod:_cmd]) {
        return [visibleViewController supportedInterfaceOrientations];
    } else {
        return SupportedOrientationMask;
    }
}

#pragma mark - HomeIndicator

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.selectedViewController;
}
@end
