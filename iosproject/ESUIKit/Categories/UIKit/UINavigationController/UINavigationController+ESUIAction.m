//
//  UINavigationController+ESUIAction.m
//  iosproject
//
//  Created by hlcisy on 2021/1/7.
//  Copyright © 2021 hlcisy. All rights reserved.
//

#import "UINavigationController+ESUIAction.h"
#import "UIViewController+ESUIStatus.h"
#import "ESUICore.h"

@interface UINavigationController ()
@property (nonatomic, strong) NSMutableArray<ESUINavigationActionDidChangeBlock> *esui_navigationActionDidChangeBlocks;
@end

@implementation UINavigationController (ESUIAction)
@dynamic esui_navigationAction;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UINavigationController class], @selector(initWithNibName:bundle:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UINavigationController *(UINavigationController *selfObject, NSString *firstArgv, NSBundle *secondArgv) {
                UINavigationController *(*originSelectorIMP)(id, SEL, NSString *, NSBundle *);
                originSelectorIMP = (UINavigationController *(*)(id, SEL, NSString *, NSBundle *))originalIMPProvider();
                UINavigationController *result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                
                [selfObject esui_didInitialize];
                
                return result;
            };
        });
        
        OverrideInstanceImplementation([UINavigationController class], @selector(initWithCoder:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UINavigationController *(UINavigationController *selfObject, NSCoder *firstArgv) {
                UINavigationController *(*originSelectorIMP)(id, SEL, NSCoder *);
                originSelectorIMP = (UINavigationController *(*)(id, SEL, NSCoder *))originalIMPProvider();
                UINavigationController *result = originSelectorIMP(selfObject, originCMD, firstArgv);
                
                [selfObject esui_didInitialize];
                
                return result;
            };
        });
        
        if (@available(iOS 13.0, *)) {
            OverrideInstanceImplementation([UINavigationController class], @selector(initWithNavigationBarClass:toolbarClass:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UINavigationController *(UINavigationController *selfObject, Class firstArgv, Class secondArgv) {
                    UINavigationController *(*originSelectorIMP)(id, SEL, Class, Class);
                    originSelectorIMP = (UINavigationController *(*)(id, SEL, Class, Class))originalIMPProvider();
                    UINavigationController *result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                    
                    [selfObject esui_didInitialize];
                    
                    return result;
                };
            });
            
            OverrideInstanceImplementation([UINavigationController class], @selector(initWithRootViewController:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UINavigationController *(UINavigationController *selfObject, UIViewController *firstArgv) {
                    UINavigationController *(*originSelectorIMP)(id, SEL, UIViewController *);
                    originSelectorIMP = (UINavigationController *(*)(id, SEL, UIViewController *))originalIMPProvider();
                    UINavigationController *result = originSelectorIMP(selfObject, originCMD, firstArgv);
                    
                    [selfObject esui_didInitialize];
                    
                    return result;
                };
            });
        }
        
        OverrideInstanceImplementation([UINavigationController class], @selector(viewDidLoad), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^void(UINavigationController *selfObject) {
                void(*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void(*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                BOOL shouldSetTintColor = YES;
                if (shouldSetTintColor) {
                    selfObject.navigationBar.tintColor = NavBarTintColor;
                }
            };
        });
        
        /// pushViewController:animated:
        OverrideInstanceImplementation([UINavigationController class], @selector(pushViewController:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                if (selfObject.presentedViewController) {
                    NSLog(@"%@ bad push!",NSStringFromClass(originClass));
                }
                
                void (^callSuperBlock)(void) = ^void(void) {
                    void (*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                    originSelectorIMP = (void (*)(id, SEL, UIViewController *, BOOL))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, viewController, animated);
                };
                
                BOOL willPushActually = NO;
                if (viewController) {
                    if (![viewController isKindOfClass:UITabBarController.class] &&
                        ![selfObject.viewControllers containsObject:viewController]) {
                        willPushActually = YES;
                    }
                }
                
                if (!willPushActually) {
                    callSuperBlock();
                    return;
                }
                
                UIViewController *appearingViewController = viewController;
                NSArray<UIViewController *> *disappearingViewControllers = nil;
                if (selfObject.topViewController) {
                    disappearingViewControllers = @[selfObject.topViewController];
                }
                
                [selfObject setEsui_navigationAction:ESUINavigationActionWillPush
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                callSuperBlock();
                
                [selfObject setEsui_navigationAction:ESUINavigationActionDidPush
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                [selfObject esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [selfObject setEsui_navigationAction:ESUINavigationActionPushCompleted
                                                animated:animated
                                 appearingViewController:appearingViewController
                             disappearingViewControllers:disappearingViewControllers];
                    [selfObject setEsui_navigationAction:ESUINavigationActionUnknow
                                                animated:animated
                                 appearingViewController:nil
                             disappearingViewControllers:nil];
                }];
            };
        });
        
        /// popViewControllerAnimated:
        OverrideInstanceImplementation([UINavigationController class], @selector(popViewControllerAnimated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIViewController *(UINavigationController *selfObject, BOOL animated) {
                UIViewController *(^callSuperBlock)(void) = ^UIViewController *(void) {
                    UIViewController *(*originSelectorIMP)(id, SEL, BOOL);
                    originSelectorIMP = (UIViewController *(*)(id, SEL, BOOL))originalIMPProvider();
                    UIViewController *result = originSelectorIMP(selfObject, originCMD, animated);
                    return result;
                };
                
                BOOL willPopActually = selfObject.viewControllers.count > 1;
                
                if (!willPopActually) {
                    return callSuperBlock();
                }
                
                UIViewController *appearingViewController = selfObject.viewControllers[selfObject.viewControllers.count - 2];
                NSArray<UIViewController *> *disappearingViewControllers = nil;
                if (selfObject.viewControllers.lastObject) {
                    disappearingViewControllers = @[selfObject.viewControllers.lastObject];
                }
                
                [selfObject setEsui_navigationAction:ESUINavigationActionWillPop
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                UIViewController *result = callSuperBlock();
                if (result &&
                    disappearingViewControllers &&
                    disappearingViewControllers.firstObject == result) { } else {
                    NSAssert(NO, @"ESUI 认为 popViewController 会成功，但实际上失败了");
                }
                
                if (result) {
                    disappearingViewControllers = @[result];
                }
                
                [selfObject setEsui_navigationAction:ESUINavigationActionDidPop
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                [selfObject esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [selfObject setEsui_navigationAction:ESUINavigationActionPopCompleted
                                                animated:animated
                                 appearingViewController:appearingViewController
                             disappearingViewControllers:disappearingViewControllers];
                    [selfObject setEsui_navigationAction:ESUINavigationActionUnknow
                                                animated:animated
                                 appearingViewController:nil
                             disappearingViewControllers:nil];
                }];
                
                return result;
            };
        });
        
        /// popToViewController:animated:
        OverrideInstanceImplementation([UINavigationController class], @selector(popToViewController:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^NSArray<UIViewController *> *(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                NSArray<UIViewController *> *(^callSuperBlock)(void) = ^NSArray<UIViewController *> *(void) {
                    NSArray<UIViewController *> *(*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                    originSelectorIMP = (NSArray<UIViewController *> * (*)(id, SEL, UIViewController *, BOOL))originalIMPProvider();
                    NSArray<UIViewController *> *poppedViewControllers = originSelectorIMP(selfObject, originCMD, viewController, animated);
                    return poppedViewControllers;
                };
                
                BOOL willPopActually = NO;
                if ([selfObject viewControllers].count > 1 &&
                    [selfObject.viewControllers containsObject:viewController] &&
                    [selfObject topViewController] != viewController) {
                    willPopActually = YES;
                }
                
                if (!willPopActually) {
                    return callSuperBlock();
                }
                
                UIViewController *appearingViewController = viewController;
                NSArray<UIViewController *> *disappearingViewControllers = nil;
                NSUInteger index = [selfObject.viewControllers indexOfObject:appearingViewController];
                if (index != NSNotFound) {
                    NSRange range = NSMakeRange(index + 1, selfObject.viewControllers.count - index - 1);
                    disappearingViewControllers = [selfObject.viewControllers subarrayWithRange:range];
                }

                [selfObject setEsui_navigationAction:ESUINavigationActionWillPop
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                NSArray<UIViewController *> *result = callSuperBlock();
                NSAssert([result isEqualToArray:disappearingViewControllers], @"ESUI 计算得到的 popToViewController 结果和系统的不一致");
                disappearingViewControllers = result ?: disappearingViewControllers;
                
                [selfObject setEsui_navigationAction:ESUINavigationActionDidPop
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                [selfObject esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [selfObject setEsui_navigationAction:ESUINavigationActionPopCompleted
                                                animated:animated
                                 appearingViewController:appearingViewController
                             disappearingViewControllers:disappearingViewControllers];
                    [selfObject setEsui_navigationAction:ESUINavigationActionUnknow
                                                animated:animated
                                 appearingViewController:nil
                             disappearingViewControllers:nil];
                }];
                
                return result;
            };
        });
        
        /// popToRootViewControllerAnimated:
        OverrideInstanceImplementation([UINavigationController class], @selector(popToRootViewControllerAnimated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^NSArray<UIViewController *> *(UINavigationController *selfObject, BOOL animated) {
                NSArray<UIViewController *> *(^callSuperBlock)(void) = ^NSArray<UIViewController *> *(void) {
                    NSArray<UIViewController *> *(*originSelectorIMP)(id, SEL, BOOL);
                    originSelectorIMP = (NSArray<UIViewController *> * (*)(id, SEL, BOOL))originalIMPProvider();
                    NSArray<UIViewController *> *result = originSelectorIMP(selfObject, originCMD, animated);
                    return result;
                };
                
                BOOL willPopActually = selfObject.viewControllers.count > 1;
                
                if (!willPopActually) {
                    return callSuperBlock();
                }
                
                UIViewController *appearingViewController = selfObject.esui_rootViewController;
                NSArray<UIViewController *> *disappearingViewControllers = [selfObject.viewControllers subarrayWithRange:NSMakeRange(1, selfObject.viewControllers.count - 1)];
                
                [selfObject setEsui_navigationAction:ESUINavigationActionWillPop
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                NSArray<UIViewController *> *result = callSuperBlock();
                NSAssert([result isEqualToArray:disappearingViewControllers], @"ESUI 计算得到的 popToRootViewController 结果和系统的不一致");
                disappearingViewControllers = result ?: disappearingViewControllers;
                
                [selfObject setEsui_navigationAction:ESUINavigationActionDidPop
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];
                
                [selfObject esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [selfObject setEsui_navigationAction:ESUINavigationActionPopCompleted
                                                animated:animated
                                 appearingViewController:appearingViewController
                             disappearingViewControllers:disappearingViewControllers];
                    [selfObject setEsui_navigationAction:ESUINavigationActionUnknow
                                                animated:animated
                                 appearingViewController:nil
                             disappearingViewControllers:nil];
                }];
                
                return result;
            };
        });
        
        /// setViewControllers:animated:
        OverrideInstanceImplementation([UINavigationController class], @selector(setViewControllers:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, NSArray<UIViewController *> *viewControllers, BOOL animated) {
                UIViewController *appearingViewController = nil;
                if (selfObject.topViewController != viewControllers.lastObject) {
                    appearingViewController = viewControllers.lastObject;
                }
                
                NSMutableArray<UIViewController *> *disappearingViewControllers = selfObject.viewControllers.mutableCopy;
                [disappearingViewControllers removeObjectsInArray:viewControllers];
                disappearingViewControllers = disappearingViewControllers.count ? disappearingViewControllers : nil;

                [selfObject setEsui_navigationAction:ESUINavigationActionWillSet
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];

                void (*originSelectorIMP)(id, SEL, NSArray<UIViewController *> *, BOOL);
                originSelectorIMP = (void (*)(id, SEL, NSArray<UIViewController *> *, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, viewControllers, animated);

                [selfObject setEsui_navigationAction:ESUINavigationActionDidSet
                                            animated:animated
                             appearingViewController:appearingViewController
                         disappearingViewControllers:disappearingViewControllers];

                [selfObject esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [selfObject setEsui_navigationAction:ESUINavigationActionSetCompleted
                                                animated:animated
                                 appearingViewController:appearingViewController
                             disappearingViewControllers:disappearingViewControllers];
                    [selfObject setEsui_navigationAction:ESUINavigationActionUnknow
                                                animated:animated
                                 appearingViewController:nil
                             disappearingViewControllers:nil];
                }];
            };
        });
    });
}

- (void)esui_didInitialize {
    
}

- (void)esui_addNavigationActionDidChangeBlock:(ESUINavigationActionDidChangeBlock)block {
    if (!self.esui_navigationActionDidChangeBlocks) {
        self.esui_navigationActionDidChangeBlocks = NSMutableArray.new;
    }
    [self.esui_navigationActionDidChangeBlocks addObject:block];
}

- (BOOL)esui_isPushing {
    if (self.esui_navigationAction > ESUINavigationActionWillPush &&
        self.esui_navigationAction <= ESUINavigationActionPushCompleted) {
        return YES;
    }
    return NO;
}

- (BOOL)esui_isPopping {
    if (self.esui_navigationAction > ESUINavigationActionWillPop &&
        self.esui_navigationAction <= ESUINavigationActionPopCompleted) {
        return YES;
    }
    return NO;
}

static char kAssociatedObjectKey_navigationActionDidChangeBlocks;
- (void)setEsui_navigationActionDidChangeBlocks:(NSMutableArray<ESUINavigationActionDidChangeBlock> *)navigationActionDidChangeBlocks {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_navigationActionDidChangeBlocks, navigationActionDidChangeBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<ESUINavigationActionDidChangeBlock> *)esui_navigationActionDidChangeBlocks {
    return (NSMutableArray<ESUINavigationActionDidChangeBlock> *)objc_getAssociatedObject(self, &kAssociatedObjectKey_navigationActionDidChangeBlocks);
}

static char kAssociatedObjectKey_navigationAction;
- (void)setEsui_navigationAction:(ESUINavigationAction)navigationAction
                        animated:(BOOL)animated
         appearingViewController:(UIViewController *)appearingViewController
     disappearingViewControllers:(NSArray<UIViewController *> *)disappearingViewControllers {
    BOOL valueChanged = self.esui_navigationAction != navigationAction;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_navigationAction, @(navigationAction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (valueChanged && self.esui_navigationActionDidChangeBlocks.count) {
        [self.esui_navigationActionDidChangeBlocks enumerateObjectsUsingBlock:^(ESUINavigationActionDidChangeBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj(navigationAction, animated, self, appearingViewController, disappearingViewControllers);
        }];
    }
}

- (ESUINavigationAction)esui_navigationAction {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_navigationAction)) unsignedIntegerValue];
}
@end
