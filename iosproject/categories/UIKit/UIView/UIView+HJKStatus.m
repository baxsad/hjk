//
//  UIView+HJKStatus.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIView+HJKStatus.h"
#import "UIView+HJKController.h"
#import "UIViewController+HJKStatus.h"

@implementation UIView (HJKStatus)

- (BOOL)hjk_visible {
    if (self.hidden || self.alpha <= 0.01) {
        return NO;
    }
    if (self.window) {
        return YES;
    }
    if ([self isKindOfClass:UIWindow.class]) {
        if (@available(iOS 13.0, *)) {
            return !!((UIWindow *)self).windowScene;
        } else {
            return YES;
        }
    }
    UIViewController *viewController = self.hjk_viewController;
    return viewController.hjk_visibleState >= HJKUIViewControllerWillAppear &&
    viewController.hjk_visibleState < HJKUIViewControllerWillDisappear;
}
@end
