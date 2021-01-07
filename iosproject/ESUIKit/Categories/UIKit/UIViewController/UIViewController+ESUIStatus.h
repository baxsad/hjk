//
//  UIViewController+ESUIStatus.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ESUIViewControllerVisibleState) {
    ESUIViewControllerUnknow        = 1 << 0,   /// 初始化完成但尚未触发 viewDidLoad
    ESUIViewControllerViewDidLoad   = 1 << 1,   /// 触发了 viewDidLoad
    ESUIViewControllerWillAppear    = 1 << 2,   /// 触发了 viewWillAppear
    ESUIViewControllerDidAppear     = 1 << 3,   /// 触发了 viewDidAppear
    ESUIViewControllerWillDisappear = 1 << 4,   /// 触发了 viewWillDisappear
    ESUIViewControllerDidDisappear  = 1 << 5,   /// 触发了 viewDidDisappear
    ESUIViewControllerVisible       = ESUIViewControllerWillAppear | ESUIViewControllerDidAppear,
};

@interface UIViewController (ESUIStatus)

/// 获取当前 viewController 所处的的生命周期阶段
/// 也即 viewDidLoad/viewWillApear/viewDidAppear/viewWillDisappear/viewDidDisappear
@property (nonatomic, assign, readonly) ESUIViewControllerVisibleState esui_visibleState;

/// 在当前 viewController 生命周期发生变化的时候调用
@property (nullable, nonatomic, copy) void (^esui_visibleStateDidChangeBlock)(__kindof UIViewController *viewController, ESUIViewControllerVisibleState visibleState);

/// 提供一个 block 可以方便地控制是否要隐藏状态栏，适用于无法重写父类方法的场景。
/// 默认不实现这个 block 则不干预显隐。
@property (nullable, nonatomic, copy) BOOL (^esui_prefersStatusBarHiddenBlock)(void);

/// 提供一个 block 可以方便地控制状态栏样式，适用于无法重写父类方法的场景。默认不实现这个 block 则不干预样式。
/// @note iOS 13 及以后，自己显示的 UIWindow 无法盖住状态栏了，但 iOS 12 及以前的系统，以 UIWindow 显示的浮层是可以盖住状态栏的，请知悉。
@property (nullable, nonatomic, copy) UIStatusBarStyle (^esui_preferredStatusBarStyleBlock)(void);

/// 提供一个 block 可以方便地控制状态栏动画，适用于无法重写父类方法的场景。
/// 默认不实现这个 block 则不干预动画。
@property (nullable, nonatomic, copy) UIStatusBarAnimation (^esui_preferredStatusBarUpdateAnimationBlock)(void);

/// 提供一个 block 可以方便地控制全面屏设备屏幕底部的 Home Indicator 的显隐，适用于无法重写父类方法的场景。
/// 默认不实现这个 block 则不干预显隐。
@property (nullable, nonatomic, copy) BOOL (^esui_prefersHomeIndicatorAutoHiddenBlock)(void) API_AVAILABLE(ios(11.0));

/// 可用于对  View 执行一些操作， 如果此时处于转场过渡中，这些操作会跟随转场进度以动画的形式展示过程
/// @param animation 要执行的操作
/// @param completion 转场完成或取消后的回调
/// @note 如果处于非转场过程中，也会执行 animation ，随后执行 completion，业务无需关心是否处于转场过程中。
- (void)esui_animateAlongsideTransition:(void (^ __nullable)(id <UIViewControllerTransitionCoordinatorContext>context))animation completion:(void (^ __nullable)(id <UIViewControllerTransitionCoordinatorContext>context))completion;
@end

NS_ASSUME_NONNULL_END
