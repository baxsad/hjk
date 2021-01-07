//
//  UIView+ESUIController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIView+ESUIController.h"
#import "ESUIComponents.h"
#import "ESUICore.h"

@implementation UIView (ESUIController)

- (void)setEsui_viewController:(__kindof UIViewController * _Nullable)value {
    ESUIWeakObjectContainer *weakContainer = objc_getAssociatedObject(self, @selector(esui_viewController));
    if (!weakContainer) {
        weakContainer = [[ESUIWeakObjectContainer alloc] init];
    }
    weakContainer.object = value;
    objc_setAssociatedObject(self, @selector(esui_viewController), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.esui_isControllerRootView = !!value;
}

- (__kindof UIViewController *)esui_viewController {
    if (self.esui_isControllerRootView) {
        return (__kindof UIViewController *)((ESUIWeakObjectContainer *)objc_getAssociatedObject(self, _cmd)).object;
    }
    return self.superview.esui_viewController;
}

- (void)setEsui_isControllerRootView:(BOOL)value {
    objc_setAssociatedObject(self, @selector(esui_isControllerRootView), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)esui_isControllerRootView {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) boolValue];
}
@end

@interface UIViewController (ESUIView)

@end

@implementation UIViewController (ESUIView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidLoad), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject) = ^(__unsafe_unretained __kindof UIViewController *selfObject) {
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                if (@available(iOS 11.0, *)) {
                    selfObject.view.esui_viewController = selfObject;
                } else {
                    /// 临时修复 iOS 10.0.2 上在输入框内切换输入法可能引发死循环的 bug，待查
                    ((UIView *)[selfObject valueForKey:@"_view"]).esui_viewController = selfObject;
                }
            };
            
            return block;
        });
    });
}
@end
