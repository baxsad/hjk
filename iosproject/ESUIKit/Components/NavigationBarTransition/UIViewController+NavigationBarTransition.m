//
//  UIViewController+NavigationBarTransition.m
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+NavigationBarTransition.h"
#import "UINavigationBar+NavigationBarTransition.h"
#import "UILabel+NavigationBarTransition.h"
#import "ESUINavigationBarTransitionDelegate.h"
#import "ESUINavigationBarAppearanceDelegate.h"
#import "ESUITransitionNavigationBar.h"
#import "ESUICategories.h"
#import "ESUICore.h"

typedef UIViewController<ESUINavigationBarTransitionDelegate> ESUITransitionViewController;
typedef UIViewController<ESUINavigationBarAppearanceDelegate> ESUIBarAppearanceController;

@implementation UIViewController (NavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UINavigationController class], @selector(esui_didInitialize), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject) {
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                [selfObject esui_addNavigationActionDidChangeBlock:^(ESUINavigationAction action, BOOL animated, __kindof UINavigationController * _Nullable weakNavigationController, __kindof UIViewController * _Nullable appearingViewController, NSArray<__kindof UIViewController *> * _Nullable disappearingViewControllers) {
                    /**
                     * 左右两个界面都必须存在
                     */
                    UIViewController *disappearingViewController = disappearingViewControllers.lastObject;
                    if (!appearingViewController || !disappearingViewController) {
                        return;
                    }
                    
                    switch (action) {
                        case ESUINavigationActionWillPush: {
                            if ([weakNavigationController shouldCustomTransitionAutomaticallyForOperation:UINavigationControllerOperationPush
                                                                                      firstViewController:disappearingViewController
                                                                                     secondViewController:appearingViewController]) {
                                [disappearingViewController addTransitionNavigationBarIfNeeded];
                                disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
                            }
                        }
                            break;
                        case ESUINavigationActionWillPop:
                        case ESUINavigationActionWillSet: {
                            if ([weakNavigationController shouldCustomTransitionAutomaticallyForOperation:UINavigationControllerOperationPop
                                                                                      firstViewController:disappearingViewController
                                                                                     secondViewController:appearingViewController]) {
                                [disappearingViewController addTransitionNavigationBarIfNeeded];
                                if (appearingViewController.transitionNavigationBar) {
                                    [UIViewController replaceStyleForNavigationBar:appearingViewController.transitionNavigationBar
                                                                 withNavigationBar:weakNavigationController.navigationBar];
                                }
                                disappearingViewController.prefersNavigationBarBackgroundViewHidden = YES;
                            }
                        }
                            break;
                        case ESUINavigationActionDidPop: {
                            if (@available(iOS 13.0, *)) { } else {
                                [appearingViewController renderNavigationTitleStyleAnimated:animated];
                                [weakNavigationController esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                                    [appearingViewController renderNavigationTitleStyleAnimated:animated];
                                }];
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv) {
                [selfObject renderNavigationBarStyleAnimated:firstArgv];
                
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv) {
                [selfObject clearTransitionNavigationBarAndReplaceStyle:YES];
                
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidDisappear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv) {
                [selfObject clearTransitionNavigationBarAndReplaceStyle:NO];
                
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillLayoutSubviews), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject) {
                id<UIViewControllerTransitionCoordinator> coordinator = selfObject.transitionCoordinator;
                UIViewController *from = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
                UIViewController *to   = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
                
                BOOL isCurrentToViewController = NO;
                if (selfObject == selfObject.navigationController.viewControllers.lastObject &&
                    selfObject == to) {
                    isCurrentToViewController = YES;
                }
                
                BOOL isControllerTransiting = NO;
                if (selfObject.esui_visibleState <  ESUIViewControllerDidAppear ||
                    selfObject.esui_visibleState >= ESUIViewControllerDidDisappear) {
                    isControllerTransiting = YES;
                }
                
                if (isCurrentToViewController && isControllerTransiting) {
                    BOOL shouldCustomNavigationBarTransition = NO;
                    
                    UINavigationControllerOperation operation;
                    if (to.navigationController.esui_isPushing) {
                        operation = UINavigationControllerOperationPush;
                    } else {
                        operation = UINavigationControllerOperationPop;
                    }
                    
                    if ([selfObject shouldCustomTransitionAutomaticallyForOperation:operation
                                                                firstViewController:from
                                                               secondViewController:to]) {
                        shouldCustomNavigationBarTransition = YES;
                    }
                    
                    if (shouldCustomNavigationBarTransition) {
                        if (!selfObject.transitionNavigationBar) {
                            if (selfObject.navigationController.navigationBar.translucent) {
                                /**
                                 * 如果原生bar是半透明的，需要给containerView加个背景色，否则有可能会看到下面的默认黑色背景色
                                 */
                                to.originContainerViewBackgroundColor = coordinator.containerView.backgroundColor;
                                coordinator.containerView.backgroundColor = [selfObject containerViewBackgroundColor];
                            }
                            
                            [selfObject addTransitionNavigationBarIfNeeded];
                            [selfObject resizeTransitionNavigationBarFrame];
                            selfObject.navigationController.navigationBar.transitionNavigationBar = selfObject.transitionNavigationBar;
                            selfObject.prefersNavigationBarBackgroundViewHidden = YES;
                        }
                    } else {
                        [from clearTransitionNavigationBarAndReplaceStyle:NO];
                        [to clearTransitionNavigationBarAndReplaceStyle:NO];
                    }
                }
                
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
            };
        });
    });
}

- (void)addTransitionNavigationBarIfNeeded {
    if (!self.view.esui_visible || !self.navigationController.navigationBar) {
        return;
    }
    
    UINavigationBar *originBar = self.navigationController.navigationBar;
    ESUITransitionNavigationBar *customBar = [[ESUITransitionNavigationBar alloc] init];
    customBar.originalNavigationBar = originBar;
    self.transitionNavigationBar = customBar;
    
    [self resizeTransitionNavigationBarFrame];
    if (!self.navigationController.navigationBarHidden) {
        [self.view addSubview:self.transitionNavigationBar];
    }
}

- (void)removeTransitionNavigationBar {
    if (!self.transitionNavigationBar) {
        return;
    }
    [self.transitionNavigationBar removeFromSuperview];
    self.transitionNavigationBar = nil;
}

- (void)clearTransitionNavigationBarAndReplaceStyle:(BOOL)replaceStyle {
    if (self.transitionNavigationBar) {
        if (replaceStyle) {
            [UIViewController replaceStyleForNavigationBar:self.transitionNavigationBar
                                         withNavigationBar:self.navigationController.navigationBar];
        }
        
        [self removeTransitionNavigationBar];
        
        id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
        if (self.navigationController.navigationBar.translucent && self.originContainerViewBackgroundColor) {
            [transitionCoordinator containerView].backgroundColor = self.originContainerViewBackgroundColor;
        }
    }
    
    if ([self.navigationController.viewControllers containsObject:self]) {
        self.prefersNavigationBarBackgroundViewHidden = NO;
    }
}

- (void)resizeTransitionNavigationBarFrame {
    if (!self.view.esui_visible) {
        return;
    }
    
    UIView *backgroundView = self.navigationController.navigationBar.esui_backgroundView;
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    self.transitionNavigationBar.frame = rect;
}

#pragma mark - 工具方法

- (void)renderNavigationBarStyleAnimated:(BOOL)animated {
    if (![self.navigationController.viewControllers containsObject:self]) {
        return;
    }
    
    if (![self conformsToProtocol:@protocol(ESUINavigationBarTransitionDelegate)] ||
        ![self conformsToProtocol:@protocol(ESUINavigationBarAppearanceDelegate)]) {
        return;
    }
    
    UINavigationController *navigationController = self.navigationController;
    ESUITransitionViewController *transitionViewController = (ESUITransitionViewController *)self;

    if ([transitionViewController respondsToSelector:@selector(preferredNavigationBarHidden)] &&
        [transitionViewController preferredNavigationBarHidden]) {
        if (!navigationController.isNavigationBarHidden) {
            [navigationController setNavigationBarHidden:YES animated:animated];
        }
    } else {
        if (navigationController.isNavigationBarHidden) {
            [navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
    
    ESUIBarAppearanceController *barAppearanceController = (ESUIBarAppearanceController *)self;
    
    /**
     * 导航栏的背景色
     */
    if ([barAppearanceController respondsToSelector:@selector(navigationBarBarTintColor)]) {
        UIColor *barTintColor = [barAppearanceController navigationBarBarTintColor];
        navigationController.navigationBar.barTintColor = barTintColor;
    } else {
        navigationController.navigationBar.barTintColor = UINavigationBar.appearance.barTintColor;
    }
    
    /**
     * 导航栏的背景
     */
    if ([barAppearanceController respondsToSelector:@selector(navigationBarBackgroundImage)]) {
        UIImage *backgroundImage = [barAppearanceController navigationBarBackgroundImage];
        [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImage *backgroundImage = [UINavigationBar.appearance backgroundImageForBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    /**
     * 导航栏的 style
     */
    if ([barAppearanceController respondsToSelector:@selector(navigationBarStyle)]) {
        UIBarStyle barStyle = [barAppearanceController navigationBarStyle];
        navigationController.navigationBar.barStyle = barStyle;
    } else {
        navigationController.navigationBar.barStyle = UINavigationBar.appearance.barStyle;
    }
    
    /**
     * 导航栏底部的分隔线
     */
    if ([barAppearanceController respondsToSelector:@selector(navigationBarShadowImage)]) {
        navigationController.navigationBar.shadowImage = [barAppearanceController navigationBarShadowImage];
    } else {
        navigationController.navigationBar.shadowImage = NavBarShadowImage;
    }
    
    /**
     * 导航栏上控件的主题色
     */
    UIColor *tintColor;
    if ([barAppearanceController respondsToSelector:@selector(navigationBarTintColor)]) {
        tintColor = [barAppearanceController navigationBarTintColor];
    } else {
        tintColor = NavBarTintColor;
    }
    
    if (tintColor) {
        if (@available(iOS 11, *)) {
            if (navigationController.esui_isPopping) {
                UILabel *backButtonLabel = navigationController.navigationBar.esui_backButtonLabel;
                if (backButtonLabel) {
                    backButtonLabel.esui_specifiedTextColor = backButtonLabel.textColor;
                    [self esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                        backButtonLabel.esui_specifiedTextColor = nil;
                    }];
                }
            }
        }
        
        [self esui_animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            navigationController.navigationBar.tintColor = tintColor;
        } completion:nil];
    }
    
    BOOL shouldRenderTitle = YES;
    if (@available(iOS 13.0, *)) { } else {
        if (navigationController.esui_navigationAction >= ESUINavigationActionWillPush &&
            navigationController.esui_navigationAction <= ESUINavigationActionPushCompleted) {
            shouldRenderTitle = YES;
        } else {
            shouldRenderTitle = NO;
        }
    }
    
    if (shouldRenderTitle) {
        [self renderNavigationTitleStyleAnimated:animated];
    }
}

- (void)renderNavigationTitleStyleAnimated:(BOOL)animated {
    if (![self.navigationController.viewControllers containsObject:self]) {
        return;
    }
    
    if (![self conformsToProtocol:@protocol(ESUINavigationBarTransitionDelegate)] ||
        ![self conformsToProtocol:@protocol(ESUINavigationBarAppearanceDelegate)]) {
        return;
    }
    
    UINavigationController *navigationController = self.navigationController;
    ESUIBarAppearanceController *barAppearanceController = (ESUIBarAppearanceController *)self;
    
    UIColor *titleColor;
    if ([barAppearanceController respondsToSelector:@selector(titleViewTintColor)]) {
        titleColor = [barAppearanceController titleViewTintColor];
    } else {
        titleColor = NavBarTitleColor;
    }
    
    if (!barAppearanceController.navigationItem.titleView && titleColor) {
        NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes;
        NSDictionary *originAttributes = navigationController.navigationBar.titleTextAttributes;
        if (originAttributes) {
            titleTextAttributes = [originAttributes mutableCopy];
        } else {
            titleTextAttributes = [NSMutableDictionary dictionary];
        }
        
        [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
        [navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
    }
}

+ (void)replaceStyleForNavigationBar:(UINavigationBar *)navbarA withNavigationBar:(UINavigationBar *)navbarB {
    [navbarB setBarStyle:navbarA.barStyle];
    [navbarB setBarTintColor:navbarA.barTintColor];
    [navbarB setShadowImage:navbarA.shadowImage];
    [navbarB setBackgroundImage:[navbarA backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)shouldCustomTransitionAutomaticallyForOperation:(UINavigationControllerOperation)operation firstViewController:(UIViewController *)viewController1 secondViewController:(UIViewController *)viewController2 {
    if (![viewController1 conformsToProtocol:@protocol(ESUINavigationBarTransitionDelegate)] ||
        ![viewController2 conformsToProtocol:@protocol(ESUINavigationBarTransitionDelegate)] ||
        ![viewController1 conformsToProtocol:@protocol(ESUINavigationBarAppearanceDelegate)] ||
        ![viewController2 conformsToProtocol:@protocol(ESUINavigationBarAppearanceDelegate)]) {
        return NO;
    }
    
    if ([viewController1.navigationController.delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        BOOL a = [(ESUITransitionViewController *)viewController1 respondsToSelector:@selector(shouldCustomizeNavigationBarTransitionIfUsingCustomTransitionForOperation:fromViewController:toViewController:)] ? [(ESUITransitionViewController *)viewController1 shouldCustomizeNavigationBarTransitionIfUsingCustomTransitionForOperation:operation fromViewController:viewController1 toViewController:viewController2] : NO;
        BOOL b = [(ESUITransitionViewController *)viewController2 respondsToSelector:@selector(shouldCustomizeNavigationBarTransitionIfUsingCustomTransitionForOperation:fromViewController:toViewController:)] ? [(ESUITransitionViewController *)viewController2 shouldCustomizeNavigationBarTransitionIfUsingCustomTransitionForOperation:operation fromViewController:viewController1 toViewController:viewController2] : NO;
        
        if (!a && !b) {
            return NO;
        }
    }
    
    NSString *transitionKey1 = nil,*transitionKey2 = nil;
    
    if ([viewController1 respondsToSelector:@selector(customNavigationBarTransitionKey)]) {
        transitionKey1 = [(ESUITransitionViewController *)viewController1 customNavigationBarTransitionKey];
    }
    
    if ([viewController2 respondsToSelector:@selector(customNavigationBarTransitionKey)]) {
        transitionKey2 = [(ESUITransitionViewController *)viewController2 customNavigationBarTransitionKey];
    }
    
    if (transitionKey1 || transitionKey2) {
        return ![transitionKey1 isEqualToString:transitionKey2];
    }
    
    UIImage *backgroundImage1 = nil,*backgroundImage2 = nil;
    
    if ([viewController1 respondsToSelector:@selector(navigationBarBackgroundImage)]) {
        backgroundImage1 = [(ESUIBarAppearanceController *)viewController1 navigationBarBackgroundImage];
    } else {
        backgroundImage1 = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    
    if ([viewController2 respondsToSelector:@selector(navigationBarBackgroundImage)]) {
        backgroundImage2 = [(ESUIBarAppearanceController *)viewController2 navigationBarBackgroundImage];
    } else {
        backgroundImage2 = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    
    if (backgroundImage1 || backgroundImage2) {
        if (!backgroundImage1 || !backgroundImage2) {
            /**
             * 一个有一个没有，则需要自定义
             */
            return YES;
        }
        
        if (![backgroundImage1.esui_averageColor isEqual:backgroundImage2.esui_averageColor]) {
            /**
             * 目前只能判断图片颜色是否相等了
             */
            return YES;
        }
    }
    
    /**
     * 如果存在 backgroundImage，则 barTintColor、barStyle 就算存在也不会被显示出来
     * 所以这里只判断两个 backgroundImage 都不存在的时候
     */
    if (!backgroundImage1 && !backgroundImage2) {
        UIColor *barTintColor1 = nil,*barTintColor2 = nil;
        
        if ([viewController1 respondsToSelector:@selector(navigationBarBarTintColor)]) {
            barTintColor1 = [(ESUIBarAppearanceController *)viewController1 navigationBarBarTintColor];
        } else {
            barTintColor1 = [UINavigationBar appearance].barTintColor;
        }
        
        if ([viewController2 respondsToSelector:@selector(navigationBarBarTintColor)]) {
            barTintColor2 = [(ESUIBarAppearanceController *)viewController2 navigationBarBarTintColor];
        } else {
            barTintColor2 = [UINavigationBar appearance].barTintColor;
        }
        
        if (barTintColor1 || barTintColor2) {
            if (!barTintColor1 || !barTintColor2) {
                return YES;
            }
            
            if (![barTintColor1 isEqual:barTintColor2]) {
                return YES;
            }
        }
        
        UIBarStyle barStyle1,barStyle2;
        
        if ([viewController1 respondsToSelector:@selector(navigationBarStyle)]) {
            barStyle1 = [(ESUIBarAppearanceController *)viewController1 navigationBarStyle];
        } else {
            barStyle1 = [UINavigationBar appearance].barStyle;
        }
        
        if ([viewController2 respondsToSelector:@selector(navigationBarStyle)]) {
            barStyle2 = [(ESUIBarAppearanceController *)viewController2 navigationBarStyle];
        } else {
            barStyle2 = [UINavigationBar appearance].barStyle;
        }
        
        if (barStyle1 != barStyle2) {
            return YES;
        }
    }
    
    UIImage *shadowImage1 = nil, *shadowImage2 = nil;
    
    if ([viewController1 respondsToSelector:@selector(navigationBarShadowImage)]) {
        shadowImage1 = [(ESUIBarAppearanceController *)viewController1 navigationBarShadowImage];
    } else {
        shadowImage1 = [UINavigationBar appearance].shadowImage ?: NavBarShadowImage;
    }
    
    if ([viewController2 respondsToSelector:@selector(navigationBarShadowImage)]) {
        shadowImage2 = [(ESUIBarAppearanceController *)viewController2 navigationBarShadowImage];
    } else {
        shadowImage2 = [UINavigationBar appearance].shadowImage ?: NavBarShadowImage;
    }
    
    if (shadowImage1 || shadowImage2) {
        if (!shadowImage1 || !shadowImage2) {
            return YES;
        }
        
        if (![shadowImage1.esui_averageColor isEqual:shadowImage2.esui_averageColor]) {
            return YES;
        }
    }
    
    return NO;
}

- (UIColor *)containerViewBackgroundColor {
    UIColor *backgroundColor;
    if (self.isViewLoaded && self.view.backgroundColor) {
        backgroundColor = self.view.backgroundColor;
    } else {
        backgroundColor = [UIColor whiteColor];
    }
    
    if ([self conformsToProtocol:@protocol(ESUINavigationBarAppearanceDelegate)]) {
        ESUITransitionViewController *transitionViewController = (ESUITransitionViewController *)self;
        SEL delegateSelector = @selector(containerViewBackgroundColorWhenTransitioning);
        if ([transitionViewController respondsToSelector:delegateSelector]) {
            backgroundColor = [transitionViewController containerViewBackgroundColorWhenTransitioning];
        }
    }
    
    return backgroundColor;
}

#pragma mark - getter/setter

- (void)setTransitionNavigationBar:(ESUITransitionNavigationBar *)value {
    objc_setAssociatedObject(self, @selector(transitionNavigationBar), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ESUITransitionNavigationBar *)transitionNavigationBar {
    return (ESUITransitionNavigationBar *)objc_getAssociatedObject(self, _cmd);
}

- (void)setPrefersNavigationBarBackgroundViewHidden:(BOOL)value {
    if (value) {
        self.navigationController.navigationBar.esui_backgroundView.layer.mask = [CALayer layer];
    } else {
        self.navigationController.navigationBar.esui_backgroundView.layer.mask = nil;
    }
    
    objc_setAssociatedObject(self, @selector(prefersNavigationBarBackgroundViewHidden), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersNavigationBarBackgroundViewHidden {
    id value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value boolValue];
    }
    
    return NO;
}

- (void)setOriginContainerViewBackgroundColor:(UIColor *)value {
    objc_setAssociatedObject(self, @selector(originContainerViewBackgroundColor), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)originContainerViewBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, _cmd);
}
@end
