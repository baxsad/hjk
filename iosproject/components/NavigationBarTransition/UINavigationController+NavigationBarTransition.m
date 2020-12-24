//
//  UINavigationController+NavigationBarTransition.m
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINavigationController+NavigationBarTransition.h"
#import "UIViewController+NavigationBarTransition.h"

@implementation UINavigationController (NavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UINavigationController class], @selector(pushViewController:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                void (^callSuperBlock)(UIViewController *, BOOL) = ^void(UIViewController *aViewController, BOOL aAnimated) {
                    void (*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                    originSelectorIMP = (void (*)(id, SEL, UIViewController *, BOOL))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, aViewController, aAnimated);
                };
                
                UIViewController *disappearingViewController = selfObject.viewControllers.lastObject;
                if (!disappearingViewController) {
                    callSuperBlock(viewController, animated);
                    return;
                }
                
                if ([selfObject shouldCustomTransitionAutomaticallyForOperation:UINavigationControllerOperationPush
                                                            firstViewController:disappearingViewController
                                                           secondViewController:viewController]) {
                    [disappearingViewController addTransitionNavigationBarIfNeeded];
                    [disappearingViewController setPrefersNavigationBarBackgroundViewHidden:YES];
                }
                
                callSuperBlock(viewController, animated);
            };
        });
        
        OverrideInstanceImplementation([UINavigationController class], @selector(setViewControllers:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, NSArray<UIViewController *> *viewControllers, BOOL animated) {
                void (^callSuperBlock)(NSArray<UIViewController *> *, BOOL) = ^void(NSArray<UIViewController *> *viewControllers, BOOL aAnimated) {
                    void (*originSelectorIMP)(id, SEL, NSArray<UIViewController *> *, BOOL);
                    originSelectorIMP = (void (*)(id, SEL, NSArray<UIViewController *> *, BOOL))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, viewControllers, aAnimated);
                };
                
                if (viewControllers.count <= 0 || !animated) {
                    callSuperBlock(viewControllers, animated);
                    return;
                }
                
                UIViewController *disappearingViewController = selfObject.viewControllers.lastObject;
                UIViewController *appearingViewController = viewControllers.lastObject;
                if (!disappearingViewController) {
                    callSuperBlock(viewControllers, animated);
                    return;
                }
                
                [selfObject handlePopViewControllerNavigationBarTransitionWithDisappearViewController:disappearingViewController
                                                                                 appearViewController:appearingViewController];
                callSuperBlock(viewControllers, animated);
            };
        });
        
        OverrideInstanceImplementation([UINavigationController class], @selector(popViewControllerAnimated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIViewController *(UINavigationController *selfObject, BOOL animated) {
                UIViewController *disappearingViewController = selfObject.viewControllers.lastObject;
                UIViewController *appearingViewController = nil;
                if (selfObject.viewControllers.count >= 2) {
                    appearingViewController = selfObject.viewControllers[selfObject.viewControllers.count - 2];
                }
                
                if (disappearingViewController && appearingViewController) {
                    [selfObject handlePopViewControllerNavigationBarTransitionWithDisappearViewController:disappearingViewController
                                                                                     appearViewController:appearingViewController];
                }
                
                UIViewController *(*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (UIViewController *(*)(id, SEL, BOOL))originalIMPProvider();
                UIViewController *result = originSelectorIMP(selfObject, originCMD, animated);
                return result;
            };
        });
        
        OverrideInstanceImplementation([UINavigationController class], @selector(popToViewController:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^NSArray<UIViewController *> *(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                UIViewController *disappearingViewController = selfObject.viewControllers.lastObject;
                UIViewController *appearingViewController = viewController;
                
                NSArray<UIViewController *> *(*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                originSelectorIMP = (NSArray<UIViewController *> * (*)(id, SEL, UIViewController *, BOOL))originalIMPProvider();
                NSArray<UIViewController *> *poppedViewControllers = originSelectorIMP(selfObject, originCMD, viewController, animated);
                
                if (poppedViewControllers) {
                    [selfObject handlePopViewControllerNavigationBarTransitionWithDisappearViewController:disappearingViewController
                                                                                     appearViewController:appearingViewController];
                }
                
                return poppedViewControllers;
            };
        });
        
        OverrideInstanceImplementation([UINavigationController class], @selector(popToRootViewControllerAnimated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^NSArray<UIViewController *> * (__unsafe_unretained __kindof UINavigationController *selfObject, BOOL animated) {
                NSArray<UIViewController *> *(*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (NSArray<UIViewController *> *(*)(id, SEL, BOOL))originalIMPProvider();
                NSArray<UIViewController *> *result = originSelectorIMP(selfObject, originCMD, animated);
                
                if (selfObject.viewControllers.count > 1) {
                    UIViewController *disappearingViewController = selfObject.viewControllers.lastObject;
                    UIViewController *appearingViewController = selfObject.viewControllers.firstObject;
                    if (result) {
                        [selfObject handlePopViewControllerNavigationBarTransitionWithDisappearViewController:disappearingViewController
                                                                                         appearViewController:appearingViewController];
                    }
                }
                
                return result;
            };
        });
    });
}

- (void)handlePopViewControllerNavigationBarTransitionWithDisappearViewController:(UIViewController *)disappearViewController appearViewController:(UIViewController *)appearViewController {
    if ([self shouldCustomTransitionAutomaticallyForOperation:UINavigationControllerOperationPop
                                          firstViewController:disappearViewController
                                         secondViewController:appearViewController]) {
        [disappearViewController addTransitionNavigationBarIfNeeded];
        if (appearViewController.transitionNavigationBar) {
            [UIViewController replaceStyleForNavigationBar:(UINavigationBar *)appearViewController.transitionNavigationBar
                                         withNavigationBar:self.navigationBar];
        }
        disappearViewController.prefersNavigationBarBackgroundViewHidden = YES;
    }
}
@end
