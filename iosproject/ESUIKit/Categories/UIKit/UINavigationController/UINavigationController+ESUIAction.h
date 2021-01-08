//
//  UINavigationController+ESUIAction.h
//  iosproject
//
//  Created by hlcisy on 2021/1/7.
//  Copyright © 2021 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ESUINavigationAction) {
    ESUINavigationActionUnknow,         /// 初始、各种动作的 completed 之后都会立即转入 unknown 状态
    
    ESUINavigationActionWillPush,       /// push 方法被触发，但尚未进行真正的 push 动作
    ESUINavigationActionDidPush,        /// 系统的 push 已经执行完，viewControllers 已被刷新
    ESUINavigationActionPushCompleted,  /// push 动画结束（如果没有动画，则在 did push 后立即进入 completed）
    
    ESUINavigationActionWillPop,        /// pop 方法被触发，但尚未进行真正的 pop 动作
    ESUINavigationActionDidPop,         /// 系统的 pop 已经执行完，viewControllers 已被刷新（注意可能有 pop 失败的情况）
    ESUINavigationActionPopCompleted,   /// pop 动画结束（如果没有动画，则在 did pop 后立即进入 completed）
    
    ESUINavigationActionWillSet,        /// setViewControllers 方法被触发，但尚未进行真正的 set 动作
    ESUINavigationActionDidSet,         /// 系统的 setViewControllers 已经执行完，viewControllers 已被刷新
    ESUINavigationActionSetCompleted,   /// setViewControllers 动画结束（如果没有动画，则在 did set 后立即进入 completed）
};

typedef void (^ESUINavigationActionDidChangeBlock)(ESUINavigationAction action,
                                                   BOOL animated,
                                                   __kindof UINavigationController * _Nullable weakNavigationController,
                                                   __kindof UIViewController * _Nullable appearingViewController,
                                                   NSArray<__kindof UIViewController *> * _Nullable disappearingViewControllers);

@interface UINavigationController (ESUIAction)

/// NS_DESIGNATED_INITIALIZER 方法被调用时就会调用这个方法，一些 init 时要处理的事情都可以统一放在这里面
- (void)esui_didInitialize NS_REQUIRES_SUPER;

/// 导航控制器过渡状态
@property (nonatomic, assign, readonly) ESUINavigationAction esui_navigationAction;

/// 添加一个 block 用于监听当前 UINavigationController 的 push/pop/setViewControllers 操作
- (void)esui_addNavigationActionDidChangeBlock:(ESUINavigationActionDidChangeBlock)block;

/// 是否在 push 的过程中
@property (nonatomic, readonly) BOOL esui_isPushing;

/// 是否在 pop 的过程中，包括手势、以及代码触发的 pop
@property (nonatomic, readonly) BOOL esui_isPopping;
@end

NS_ASSUME_NONNULL_END
