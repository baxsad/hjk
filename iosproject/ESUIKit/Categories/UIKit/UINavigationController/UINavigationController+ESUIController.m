//
//  UINavigationController+ESUIController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINavigationController+ESUIController.h"
#import "ESUICore.h"

@interface UINavigationController (ESUIPrivate)
@property(nullable, nonatomic, readwrite) UIViewController *esui_endedTransitionTopViewController;
@end

@implementation UINavigationController (ESUIController)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UINavigationController class], NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^void(UINavigationController *selfObject, UIView *transitionView, NSInteger transition, UIView *fromView, UIView *toView) {
               BOOL (*originSelectorIMP)(id, SEL, UIView *, NSInteger , UIView *, UIView *);
               originSelectorIMP = (BOOL (*)(id, SEL, UIView *, NSInteger , UIView *, UIView *))originalIMPProvider();
               originSelectorIMP(selfObject, originCMD, transitionView, transition, fromView, toView);
               selfObject.esui_endedTransitionTopViewController = selfObject.topViewController;
            };
        });
    });
}

- (void)setEsui_endedTransitionTopViewController:(UIViewController *)value {
    objc_setAssociatedObject(self, @selector(esui_endedTransitionTopViewController), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)esui_endedTransitionTopViewController {
    return (UIViewController *)objc_getAssociatedObject(self, _cmd);
}

- (BOOL)esui_isPushing {
    if (self.viewControllers.count >= 2) {
        UIViewController *previousViewController = self.viewControllers[self.viewControllers.count - 2];
        if (previousViewController == self.esui_endedTransitionTopViewController) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)esui_isPopping {
    return self.esui_topViewController != self.topViewController;
}

- (UIViewController *)esui_topViewController {
    if (self.esui_isPushing) {
        return self.topViewController;
    }
    
    return self.esui_endedTransitionTopViewController ?: self.topViewController;
}

- (nullable UIViewController *)esui_rootViewController {
    return self.viewControllers.firstObject;
}
@end
