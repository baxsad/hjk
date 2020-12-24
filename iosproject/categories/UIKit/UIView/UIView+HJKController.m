//
//  UIView+HJKController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIView+HJKController.h"
#import "HJKWeakObjectContainer.h"
#import "HJKCore.h"

@implementation UIView (HJKController)

- (void)setHjk_viewController:(__kindof UIViewController * _Nullable)hjk_viewController {
    HJKWeakObjectContainer *weakContainer = objc_getAssociatedObject(self, @selector(hjk_viewController));
    if (!weakContainer) {
        weakContainer = [[HJKWeakObjectContainer alloc] init];
    }
    weakContainer.object = hjk_viewController;
    objc_setAssociatedObject(self, @selector(hjk_viewController), weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.hjk_isControllerRootView = !!hjk_viewController;
}

- (__kindof UIViewController *)hjk_viewController {
    if (self.hjk_isControllerRootView) {
        return (__kindof UIViewController *)((HJKWeakObjectContainer *)objc_getAssociatedObject(self, _cmd)).object;
    }
    return self.superview.hjk_viewController;
}

- (void)setHjk_isControllerRootView:(BOOL)hjk_isControllerRootView {
    objc_setAssociatedObject(self, @selector(hjk_isControllerRootView), @(hjk_isControllerRootView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hjk_isControllerRootView {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) boolValue];
}
@end

@interface UIViewController (HJKView)

@end

@implementation UIViewController (HJKView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidLoad), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject) = ^(__unsafe_unretained __kindof UIViewController *selfObject) {
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                if (@available(iOS 11.0, *)) {
                    selfObject.view.hjk_viewController = selfObject;
                } else {
                    /// 临时修复 iOS 10.0.2 上在输入框内切换输入法可能引发死循环的 bug，待查
                    ((UIView *)[selfObject valueForKey:@"_view"]).hjk_viewController = selfObject;
                }
            };
            
            return block;
        });
    });
}
@end
