//
//  UIViewController+NavigationBarTransition.h
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ESUITransitionNavigationBar;

@interface UIViewController (NavigationBarTransition)

/// 用来模仿真的navBar的，在转场过程中存在的一条假navBar
@property (nonatomic, strong, nullable) ESUITransitionNavigationBar *transitionNavigationBar;

/// 是否要把真的navBar隐藏
@property (nonatomic, assign) BOOL prefersNavigationBarBackgroundViewHidden;

/// 原始containerView的背景色
@property (nonatomic, strong) UIColor *originContainerViewBackgroundColor;

/// 因为有些特殊情况下viewDidAppear之后，有可能还会调用到viewWillLayoutSubviews，导致原始的navBar隐藏，所以用这个属性做个保护。
@property (nonatomic, assign) BOOL lockTransitionNavigationBar;

/// 添加假的navBar
- (void)addTransitionNavigationBarIfNeeded;

/// 把navbarA的样式应用到navbarB
+ (void)replaceStyleForNavigationBar:(UINavigationBar *)navbarA withNavigationBar:(UINavigationBar *)navbarB;

/// 根据配置或者前后两个控制器的样式判断是否需要添加假的导航栏进行转场过渡
- (BOOL)shouldCustomTransitionAutomaticallyForOperation:(UINavigationControllerOperation)operation firstViewController:(UIViewController *)first secondViewController:(UIViewController *)second;
@end

NS_ASSUME_NONNULL_END
