//
//  UIView+ESUIStatus.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIView+ESUIStatus.h"
#import "UIView+ESUIController.h"
#import "UIViewController+ESUIStatus.h"

@implementation UIView (ESUIStatus)

- (BOOL)esui_visible {
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
    UIViewController *viewController = self.esui_viewController;
    return viewController.esui_visibleState >= ESUIViewControllerWillAppear &&
    viewController.esui_visibleState < ESUIViewControllerWillDisappear;
}
@end
