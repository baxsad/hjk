//
//  UIViewController+HJKStatus.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+HJKStatus.h"
#import "UIViewController+HJKRuntime.h"
#import "HJKCore.h"

@implementation UIViewController (HJKStatus)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidLoad), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject) = ^(__unsafe_unretained __kindof UIViewController *selfObject) {
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                selfObject.hjk_visibleState = HJKUIViewControllerViewDidLoad;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.hjk_visibleState = HJKUIViewControllerWillAppear;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.hjk_visibleState = HJKUIViewControllerDidAppear;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillDisappear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.hjk_visibleState = HJKUIViewControllerWillDisappear;
            };
            
            return block;
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidDisappear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            void (^block)(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) = ^(__unsafe_unretained __kindof UIViewController *selfObject, BOOL animated) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, animated);
                
                selfObject.hjk_visibleState = HJKUIViewControllerDidDisappear;
            };
            
            return block;
        });
        
        if (@available(iOS 11.0, *)) {
            OverrideInstanceImplementation([UIViewController class], NSSelectorFromString(@"_preferredStatusBarVisibility"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^NSInteger(UIViewController *selfObject) {
                    if (![selfObject hjk_hasOverrideUIKitMethod:@selector(prefersStatusBarHidden)] && selfObject.hjk_prefersStatusBarHiddenBlock) {
                        /// 系统返回的 1 表示隐藏，2 表示显示，0 不清楚含义
                        return selfObject.hjk_prefersStatusBarHiddenBlock() ? 1 : 2;
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
                    if (selfObject.hjk_prefersStatusBarHiddenBlock) {
                        return selfObject.hjk_prefersStatusBarHiddenBlock();
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
            if (selfObject.hjk_preferredStatusBarStyleBlock) {
                return selfObject.hjk_preferredStatusBarStyleBlock();
            }
            
            UIStatusBarStyle (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (UIStatusBarStyle (*)(id, SEL))originalIMPProvider();
            UIStatusBarStyle result = originSelectorIMP(selfObject, originCMD);
            return result;
        };
    });
    
    OverrideInstanceImplementation([UIViewController class], @selector(preferredStatusBarUpdateAnimation), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^UIStatusBarAnimation(UIViewController *selfObject) {
            if (selfObject.hjk_preferredStatusBarUpdateAnimationBlock) {
                return selfObject.hjk_preferredStatusBarUpdateAnimationBlock();
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
                if (selfObject.hjk_prefersHomeIndicatorAutoHiddenBlock) {
                    return selfObject.hjk_prefersHomeIndicatorAutoHiddenBlock();
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

- (void)setHjk_visibleState:(HJKUIViewControllerVisibleState)hjk_visibleState {
    BOOL valueChanged = self.hjk_visibleState != hjk_visibleState;
    objc_setAssociatedObject(self, @selector(hjk_visibleState), @(hjk_visibleState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (valueChanged && self.hjk_visibleStateDidChangeBlock) {
        self.hjk_visibleStateDidChangeBlock(self, hjk_visibleState);
    }
}

- (HJKUIViewControllerVisibleState)hjk_visibleState {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) unsignedIntegerValue];
}

- (void)setHjk_visibleStateDidChangeBlock:(void (^)(__kindof UIViewController * _Nonnull, HJKUIViewControllerVisibleState))hjk_visibleStateDidChangeBlock {
    objc_setAssociatedObject(self, @selector(hjk_visibleStateDidChangeBlock), hjk_visibleStateDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(__kindof UIViewController * _Nonnull, HJKUIViewControllerVisibleState))hjk_visibleStateDidChangeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHjk_prefersStatusBarHiddenBlock:(BOOL (^)(void))hjk_prefersStatusBarHiddenBlock {
    objc_setAssociatedObject(self, @selector(hjk_prefersStatusBarHiddenBlock), hjk_prefersStatusBarHiddenBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(void))hjk_prefersStatusBarHiddenBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHjk_preferredStatusBarStyleBlock:(UIStatusBarStyle (^)(void))hjk_preferredStatusBarStyleBlock {
    objc_setAssociatedObject(self, @selector(hjk_preferredStatusBarStyleBlock), hjk_preferredStatusBarStyleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIStatusBarStyle (^)(void))hjk_preferredStatusBarStyleBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHjk_preferredStatusBarUpdateAnimationBlock:(UIStatusBarAnimation (^)(void))hjk_preferredStatusBarUpdateAnimationBlock {
    objc_setAssociatedObject(self, @selector(hjk_preferredStatusBarUpdateAnimationBlock), hjk_preferredStatusBarUpdateAnimationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIStatusBarAnimation (^)(void))hjk_preferredStatusBarUpdateAnimationBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHjk_prefersHomeIndicatorAutoHiddenBlock:(BOOL (^)(void))hjk_prefersHomeIndicatorAutoHiddenBlock {
    objc_setAssociatedObject(self, @selector(hjk_prefersHomeIndicatorAutoHiddenBlock), hjk_prefersHomeIndicatorAutoHiddenBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(void))hjk_prefersHomeIndicatorAutoHiddenBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)hjk_animateAlongsideTransition:(void (^ __nullable)(id <UIViewControllerTransitionCoordinatorContext>context))animation completion:(void (^ __nullable)(id <UIViewControllerTransitionCoordinatorContext>context))completion {
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
