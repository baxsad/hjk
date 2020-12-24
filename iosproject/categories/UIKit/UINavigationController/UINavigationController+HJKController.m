//
//  UINavigationController+HJKController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINavigationController+HJKController.h"
#import "HJKCore.h"

@interface UINavigationController (HJKPrivate)
@property(nullable, nonatomic, readwrite) UIViewController *hjk_endedTransitionTopViewController;
@end

@implementation UINavigationController (HJKController)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UINavigationController class], NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^void(UINavigationController *selfObject, UIView *transitionView, NSInteger transition, UIView *fromView, UIView *toView) {
               BOOL (*originSelectorIMP)(id, SEL, UIView *, NSInteger , UIView *, UIView *);
               originSelectorIMP = (BOOL (*)(id, SEL, UIView *, NSInteger , UIView *, UIView *))originalIMPProvider();
               originSelectorIMP(selfObject, originCMD, transitionView, transition, fromView, toView);
               selfObject.hjk_endedTransitionTopViewController = selfObject.topViewController;
            };
        });
    });
}

- (void)setHjk_endedTransitionTopViewController:(UIViewController *)value {
    objc_setAssociatedObject(self, @selector(hjk_endedTransitionTopViewController), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)hjk_endedTransitionTopViewController {
    return (UIViewController *)objc_getAssociatedObject(self, _cmd);
}

- (BOOL)hjk_isPushing {
    if (self.viewControllers.count >= 2) {
        UIViewController *previousViewController = self.viewControllers[self.viewControllers.count - 2];
        if (previousViewController == self.hjk_endedTransitionTopViewController) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hjk_isPopping {
    return self.hjk_topViewController != self.topViewController;
}

- (UIViewController *)hjk_topViewController {
    if (self.hjk_isPushing) {
        return self.topViewController;
    }
    
    return self.hjk_endedTransitionTopViewController ?: self.topViewController;
}

- (nullable UIViewController *)hjk_rootViewController {
    return self.viewControllers.firstObject;
}
@end
