//
//  UIViewController+NavigationBarTransition.m
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+NavigationBarTransition.h"
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
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv) {
                /**
                 * 放在最前面，留一个时机给业务可以覆盖
                 */
                [selfObject renderNavigationStyleInViewController:selfObject animated:firstArgv];
                
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidAppear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv) {
                selfObject.lockTransitionNavigationBar = YES;
                
                if (selfObject.transitionNavigationBar) {
                    /**
                     * 页面展示完毕的时候把假navBar的样式应用到真navBar上
                     */
                    [UIViewController replaceStyleForNavigationBar:selfObject.transitionNavigationBar
                                                 withNavigationBar:selfObject.navigationController.navigationBar];
                    
                    /**
                     * 移除假的navBar
                     */
                    [selfObject removeTransitionNavigationBar];
                    
                    id <UIViewControllerTransitionCoordinator> transitionCoordinator = selfObject.transitionCoordinator;
                    [transitionCoordinator containerView].backgroundColor = selfObject.originContainerViewBackgroundColor;
                }
                
                if ([selfObject.navigationController.viewControllers containsObject:selfObject]) {
                    /**
                     * 防止一些 childViewController 走到这里
                     */
                    selfObject.prefersNavigationBarBackgroundViewHidden = NO;
                }
                
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewDidDisappear:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv) {
                selfObject.lockTransitionNavigationBar = NO;
                
                if (selfObject.transitionNavigationBar) {
                    /**
                     * 页面消失完毕的时候移除当前页面的假的navBar
                     */
                    [selfObject removeTransitionNavigationBar];
                }
                
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        OverrideInstanceImplementation([UIViewController class], @selector(viewWillLayoutSubviews), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject) {
                id<UIViewControllerTransitionCoordinator> coordinator = selfObject.transitionCoordinator;
                UIViewController *from = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
                UIViewController *to = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
                
                BOOL isCurrentToViewController = (selfObject == selfObject.navigationController.viewControllers.lastObject &&
                                                  selfObject == to);
                if (isCurrentToViewController && !selfObject.lockTransitionNavigationBar) {
                    BOOL shouldCustomNavigationBarTransition = NO;
                    if (!selfObject.transitionNavigationBar) {
                        UINavigationControllerOperation operation;
                        if (to.navigationController.topViewController == to) {
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

- (void)resizeTransitionNavigationBarFrame {
    if (!self.view.esui_visible) {
        return;
    }
    
    UIView *backgroundView = self.navigationController.navigationBar.esui_backgroundView;
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    self.transitionNavigationBar.frame = rect;
}

#pragma mark - 工具方法

- (void)renderNavigationStyleInViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![viewController.navigationController.viewControllers containsObject:viewController]) {
        return;
    }
    
    if ([viewController conformsToProtocol:@protocol(ESUINavigationBarTransitionDelegate)] &&
        [viewController conformsToProtocol:@protocol(ESUINavigationBarAppearanceDelegate)]) {
        ESUITransitionViewController *transitionViewController = (ESUITransitionViewController *)viewController;
   
        if ([transitionViewController respondsToSelector:@selector(preferredNavigationBarHidden)] &&
            [transitionViewController preferredNavigationBarHidden]) {
            if (!viewController.navigationController.isNavigationBarHidden) {
                [viewController.navigationController setNavigationBarHidden:YES animated:animated];
            }
        } else {
            if (viewController.navigationController.isNavigationBarHidden) {
                [viewController.navigationController setNavigationBarHidden:NO animated:animated];
            }
        }
        
        ESUIBarAppearanceController *barAppearanceController = (ESUIBarAppearanceController *)viewController;
        
        if ([barAppearanceController respondsToSelector:@selector(navigationBarBackgroundImage)]) {
            UIImage *backgroundImage = [barAppearanceController navigationBarBackgroundImage];
            [viewController.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        } else {
            UIImage *backgroundImage = [UINavigationBar.appearance backgroundImageForBarMetrics:UIBarMetricsDefault];
            [viewController.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        }
        
        if ([barAppearanceController respondsToSelector:@selector(navigationBarBarTintColor)]) {
            UIColor *barTintColor = [barAppearanceController navigationBarBarTintColor];
            viewController.navigationController.navigationBar.barTintColor = barTintColor;
        } else {
            viewController.navigationController.navigationBar.barTintColor = UINavigationBar.appearance.barTintColor;
        }
        
        if ([barAppearanceController respondsToSelector:@selector(navigationBarStyle)]) {
            UIBarStyle barStyle = [barAppearanceController navigationBarStyle];
            viewController.navigationController.navigationBar.barStyle = barStyle;
        } else {
            viewController.navigationController.navigationBar.barStyle = UINavigationBar.appearance.barStyle;
        }
        
        if ([barAppearanceController respondsToSelector:@selector(navigationBarShadowImage)]) {
            viewController.navigationController.navigationBar.shadowImage = [barAppearanceController navigationBarShadowImage];
        } else {
            viewController.navigationController.navigationBar.shadowImage = NavBarShadowImage;
        }
        
        UIColor *tintColor;
        if ([barAppearanceController respondsToSelector:@selector(navigationBarTintColor)]) {
            tintColor = [barAppearanceController navigationBarTintColor];
        } else {
            tintColor = NavBarTintColor;
        }
        
        if (tintColor) {
            if (@available(iOS 11, *)) {
                if (self.navigationController.esui_isPopping) {
                    UILabel *backButtonLabel = viewController.navigationController.navigationBar.esui_backButtonLabel;
                    if (backButtonLabel) {
                        backButtonLabel.esui_specifiedTextColor = backButtonLabel.textColor;
                        [viewController esui_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                            backButtonLabel.esui_specifiedTextColor = nil;
                        }];
                    }
                }
            }
            
            [viewController esui_animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                viewController.navigationController.navigationBar.tintColor = tintColor;
            } completion:nil];
        }
        
        UIColor *titleColor;
        if ([barAppearanceController respondsToSelector:@selector(titleViewTintColor)]) {
            titleColor = [barAppearanceController titleViewTintColor];
        } else {
            titleColor = NavBarTitleColor;
        }
        
        if (titleColor) {
            NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes;
            NSDictionary *originAttributes = viewController.navigationController.navigationBar.titleTextAttributes;
            if (originAttributes) {
                titleTextAttributes = [originAttributes mutableCopy];
            } else {
                titleTextAttributes = [NSMutableDictionary dictionary];
            }
            
            [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
            [viewController.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
        }
    }
}

+ (void)replaceStyleForNavigationBar:(UINavigationBar *)navbarA withNavigationBar:(UINavigationBar *)navbarB {
    navbarB.barStyle = navbarA.barStyle;
    navbarB.barTintColor = navbarA.barTintColor;
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
    UIColor *backgroundColor = [UIColor whiteColor];
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

- (void)setLockTransitionNavigationBar:(BOOL)value {
    objc_setAssociatedObject(self, @selector(lockTransitionNavigationBar), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lockTransitionNavigationBar {
    id value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value boolValue];
    }
    
    return NO;
}
@end
