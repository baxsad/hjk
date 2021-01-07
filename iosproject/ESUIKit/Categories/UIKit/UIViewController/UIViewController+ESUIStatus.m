//
//  UIViewController+ESUIStatus.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+ESUIStatus.h"
#import "UIViewController+ESUIRuntime.h"
#import "ESUICore.h"

@implementation UIViewController (ESUIStatus)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidLoad), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject) = ^(__unsafe_unretained __kindof UIViewController *selfObject) {
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                selfObject.esui_visibleState = ESUIViewControllerViewDidLoad;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.esui_visibleState = ESUIViewControllerWillAppear;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.esui_visibleState = ESUIViewControllerDidAppear;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillDisappear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.esui_visibleState = ESUIViewControllerWillDisappear;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidDisappear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.esui_visibleState = ESUIViewControllerDidDisappear;
            };
            
            return block;
        });
        
        if (@available(iOS 11.0, *)) {
            OverrideInstanceImplementation([UIViewController class], NSSelectorFromString(@"_preferredStatusBarVisibility"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^NSInteger(UIViewController *selfObject) {
                    if (![selfObject esui_hasOverrideUIKitMethod:@selector(prefersStatusBarHidden)] && selfObject.esui_prefersStatusBarHiddenBlock) {
                        /// 系统返回的 1 表示隐藏，2 表示显示，0 不清楚含义
                        return selfObject.esui_prefersStatusBarHiddenBlock() ? 1 : 2;
                    }

                    NSInteger (*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (NSInteger (*)(id, SEL))originalIMPProvider();
                    NSInteger result = originSelectorIMP(selfObject, originCMD);
                    return result;
                };
            });
        } else {
            OverrideInstanceImplementation([UIViewController class], @selector(prefersStatusBarHidden), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^BOOL(UIViewController *selfObject) {
                    if (selfObject.esui_prefersStatusBarHiddenBlock) {
                        return selfObject.esui_prefersStatusBarHiddenBlock();
                    }

                    BOOL (*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (BOOL (*)(id, SEL))originalIMPProvider();
                    BOOL result = originSelectorIMP(selfObject, originCMD);
                    return result;
                };
            });
        }
    });
    
    OverrideInstanceImplementation([UIViewController class], @selector(preferredStatusBarStyle), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^UIStatusBarStyle(UIViewController *selfObject) {
            if (selfObject.esui_preferredStatusBarStyleBlock) {
                return selfObject.esui_preferredStatusBarStyleBlock();
            }
            
            UIStatusBarStyle (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (UIStatusBarStyle (*)(id, SEL))originalIMPProvider();
            UIStatusBarStyle result = originSelectorIMP(selfObject, originCMD);
            return result;
        };
    });
    
    OverrideInstanceImplementation([UIViewController class], @selector(preferredStatusBarUpdateAnimation), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^UIStatusBarAnimation(UIViewController *selfObject) {
            if (selfObject.esui_preferredStatusBarUpdateAnimationBlock) {
                return selfObject.esui_preferredStatusBarUpdateAnimationBlock();
            }
            
            UIStatusBarAnimation (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (UIStatusBarAnimation (*)(id, SEL))originalIMPProvider();
            UIStatusBarAnimation result = originSelectorIMP(selfObject, originCMD);
            return result;
        };
    });
    
    if (@available(iOS 11.0, *)) {
        OverrideInstanceImplementation([UIViewController class], @selector(prefersHomeIndicatorAutoHidden), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^BOOL(UIViewController *selfObject) {
                if (selfObject.esui_prefersHomeIndicatorAutoHiddenBlock) {
                    return selfObject.esui_prefersHomeIndicatorAutoHiddenBlock();
                }
                
                BOOL (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (BOOL (*)(id, SEL))originalIMPProvider();
                BOOL result = originSelectorIMP(selfObject, originCMD);
                return result;
            };
        });
    }
}

#pragma mark - getter/setter

- (void)setEsui_visibleState:(ESUIViewControllerVisibleState)value {
    BOOL valueChanged = self.esui_visibleState != value;
    objc_setAssociatedObject(self, @selector(esui_visibleState), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (valueChanged && self.esui_visibleStateDidChangeBlock) {
        self.esui_visibleStateDidChangeBlock(self, value);
    }
}

- (ESUIViewControllerVisibleState)esui_visibleState {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) unsignedIntegerValue];
}

- (void)setEsui_visibleStateDidChangeBlock:(void (^)(__kindof UIViewController * _Nonnull, ESUIViewControllerVisibleState))value {
    objc_setAssociatedObject(self, @selector(esui_visibleStateDidChangeBlock), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(__kindof UIViewController * _Nonnull, ESUIViewControllerVisibleState))esui_visibleStateDidChangeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEsui_prefersStatusBarHiddenBlock:(BOOL (^)(void))value {
    objc_setAssociatedObject(self, @selector(esui_prefersStatusBarHiddenBlock), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(void))esui_prefersStatusBarHiddenBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEsui_preferredStatusBarStyleBlock:(UIStatusBarStyle (^)(void))value {
    objc_setAssociatedObject(self, @selector(esui_preferredStatusBarStyleBlock), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIStatusBarStyle (^)(void))esui_preferredStatusBarStyleBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEsui_preferredStatusBarUpdateAnimationBlock:(UIStatusBarAnimation (^)(void))value {
    objc_setAssociatedObject(self, @selector(esui_preferredStatusBarUpdateAnimationBlock), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIStatusBarAnimation (^)(void))esui_preferredStatusBarUpdateAnimationBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEsui_prefersHomeIndicatorAutoHiddenBlock:(BOOL (^)(void))value {
    objc_setAssociatedObject(self, @selector(esui_prefersHomeIndicatorAutoHiddenBlock), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(void))esui_prefersHomeIndicatorAutoHiddenBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)esui_animateAlongsideTransition:(void (^ __nullable)(id <UIViewControllerTransitionCoordinatorContext>context))animation completion:(void (^ __nullable)(id <UIViewControllerTransitionCoordinatorContext>context))completion {
    if (self.transitionCoordinator) {
        BOOL animationQueuedToRun = [self.transitionCoordinator animateAlongsideTransition:animation completion:completion];
        if (!animationQueuedToRun && animation) {
            animation(nil);
        }
    } else {
        if (animation) animation(nil);
        if (completion) completion(nil);
    }
}
@end
