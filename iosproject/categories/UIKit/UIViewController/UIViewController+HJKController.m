//
//  UIViewController+HJKController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+HJKController.h"
#import "UIViewController+HJKStatus.h"
#import "UINavigationController+HJK.h"
#import "UIView+HJK.h"

@implementation UIViewController (HJKController)

- (UIViewController *)hjk_previousViewController {
    if (self.navigationController.viewControllers && self.navigationController.viewControllers.count > 1 && self.navigationController.topViewController == self) {
        NSUInteger count = self.navigationController.viewControllers.count;
        return (UIViewController *)[self.navigationController.viewControllers objectAtIndex:count - 2];
    }
    return nil;
}

- (UIViewController *)hjk_visibleViewControllerIfExist {
    if (self.presentedViewController) {
        return [self.presentedViewController hjk_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController hjk_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController hjk_visibleViewControllerIfExist];
    }
    
    if ([self hjk_isViewLoadedAndVisible]) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)hjk_isPresented {
    UIViewController *viewController = self;
    if (self.navigationController) {
        if (self.navigationController.hjk_rootViewController != self) {
            return NO;
        }
        viewController = self.navigationController;
    }
    BOOL result = viewController.presentingViewController.presentedViewController == viewController;
    return result;
}

- (BOOL)hjk_isViewLoadedAndVisible {
    return self.isViewLoaded && self.view.hjk_visible;
}
@end
