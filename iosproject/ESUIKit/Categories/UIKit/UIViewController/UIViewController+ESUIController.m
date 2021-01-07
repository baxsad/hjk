//
//  UIViewController+ESUIController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+ESUIController.h"
#import "UIViewController+ESUIStatus.h"
#import "UINavigationController+ESUI.h"
#import "UIView+ESUI.h"

@implementation UIViewController (ESUIController)

- (UIViewController *)esui_previousViewController {
    if (self.navigationController.viewControllers && self.navigationController.viewControllers.count > 1 && self.navigationController.topViewController == self) {
        NSUInteger count = self.navigationController.viewControllers.count;
        return (UIViewController *)[self.navigationController.viewControllers objectAtIndex:count - 2];
    }
    return nil;
}

- (UIViewController *)esui_visibleViewControllerIfExist {
    if (self.presentedViewController) {
        return [self.presentedViewController esui_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController esui_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController esui_visibleViewControllerIfExist];
    }
    
    if ([self esui_isViewLoadedAndVisible]) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)esui_isPresented {
    UIViewController *viewController = self;
    if (self.navigationController) {
        if (self.navigationController.esui_rootViewController != self) {
            return NO;
        }
        viewController = self.navigationController;
    }
    BOOL result = viewController.presentingViewController.presentedViewController == viewController;
    return result;
}

- (BOOL)esui_isViewLoadedAndVisible {
    return self.isViewLoaded && self.view.esui_visible;
}
@end
