//
//  HJKNavigationController.m
//  iosproject
//
//  Created by hlcisy on 2020/9/11.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKNavigationController.h"
#import "HJKCategories.h"
#import "HJKCore.h"

@interface HJKNavigationController ()
@property (nonatomic, weak) UIViewController *viewControllerPopping;
@end

@implementation HJKNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        if (@available(iOS 13.0, *)) {
            [self didInitialize];
        }
    }
    return self;
}

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
    self.navigationBar.tintColor = NavBarTintColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [super popViewControllerAnimated:animated];
    }
    
    UIViewController *viewController = [self topViewController];
    self.viewControllerPopping = viewController;
    
    viewController = [super popViewControllerAnimated:animated];
    return viewController;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController || self.topViewController == viewController) {
        return [super popToViewController:viewController animated:animated];
    }
    
    self.viewControllerPopping = self.topViewController;
    
    NSArray<UIViewController *> *poppedViewControllers = [super popToViewController:viewController animated:animated];
    return poppedViewControllers;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.topViewController == self.hjk_rootViewController) {
        return nil;
    }
    
    self.viewControllerPopping = self.topViewController;
    
    NSArray<UIViewController *> * poppedViewControllers = [super popToRootViewControllerAnimated:animated];
    return poppedViewControllers;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull viewController, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *nextViewController = nil;
        if (idx + 1 < viewControllers.count) {
            nextViewController = viewControllers[idx + 1];
        }
        [self updateBackItemTitleWithCurrentViewController:viewController nextViewController:nextViewController];
    }];
    
    [super setViewControllers:viewControllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    
    if (self.presentedViewController) {
        /// push 的时候 navigationController 存在一个盖在上面的 presentedViewController
        /// 可能导致一些 UINavigationControllerDelegate 不会被调用
    }
    
    [self updateBackItemTitleWithCurrentViewController:self.topViewController nextViewController:viewController];
    [super pushViewController:viewController animated:animated];
}

- (void)updateBackItemTitleWithCurrentViewController:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController {
    if (@available(iOS 14.0, *)) {
        currentViewController.navigationItem.backButtonDisplayMode = UINavigationItemBackButtonDisplayModeMinimal;
        return;
    }
    
    currentViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                              style:UIBarButtonItemStylePlain
                                                                                             target:nil
                                                                                             action:NULL];
}

#pragma mark - StatusBar

- (UIViewController *)childViewControllerForStatusBarWithCustomBlock:(BOOL (^)(UIViewController *vc))hasCustomizedStatusBarBlock {
    UIViewController *childViewController = self.visibleViewController;
    if (childViewController.navigationController && (self.presentedViewController == childViewController.navigationController)) {
        childViewController = childViewController.navigationController;
    }
    
    if (childViewController.presentedViewController && childViewController.presentedViewController != self.presentedViewController && hasCustomizedStatusBarBlock(childViewController.presentedViewController)) {
        childViewController = childViewController.presentedViewController;
    }
    
    if (childViewController.beingDismissed) {
        childViewController = self.topViewController;
    }
    
    if (hasCustomizedStatusBarBlock(childViewController)) {
        return childViewController;
    }
    return nil;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self childViewControllerForStatusBarWithCustomBlock:^BOOL(UIViewController *vc) {
        return vc.hjk_prefersStatusBarHiddenBlock || [vc hjk_hasOverrideUIKitMethod:@selector(prefersStatusBarHidden)];
    }];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self childViewControllerForStatusBarWithCustomBlock:^BOOL(UIViewController *vc) {
        return vc.hjk_preferredStatusBarStyleBlock || [vc hjk_hasOverrideUIKitMethod:@selector(preferredStatusBarStyle)];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *childViewController = [self childViewControllerForStatusBarStyle];
    if (childViewController) {
        return [childViewController preferredStatusBarStyle];
    }
    
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    if ([self.visibleViewController hjk_hasOverrideUIKitMethod:_cmd]) {
        return [self.visibleViewController shouldAutorotate];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *visibleViewController = self.visibleViewController;
    if (!visibleViewController || visibleViewController.isBeingDismissed || [visibleViewController isKindOfClass:UIAlertController.class]) {
        visibleViewController = self.topViewController;
    }
    
    if ([visibleViewController hjk_hasOverrideUIKitMethod:_cmd]) {
        return [visibleViewController supportedInterfaceOrientations];
    }
    
    return SupportedOrientationMask;
}

#pragma mark - HomeIndicator

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    return self.topViewController;
}
@end
