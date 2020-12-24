//
//  UINavigationController+HJKController.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (HJKController)

/// 是否在 push 的过程中
@property (nonatomic, readonly) BOOL hjk_isPushing;

/// 是否在 pop 的过程中，包括手势、以及代码触发的 pop
@property (nonatomic, readonly) BOOL hjk_isPopping;

/// 获取顶部的 ViewController，相比于系统的方法，这个方法能获取到 pop 的转场过程中顶部还没有完全消失的 ViewController
/// 请注意：这种情况下，获取到的 topViewController 已经不在栈内
@property (nullable, nonatomic, readonly) UIViewController *hjk_topViewController;

/// 获取<b>rootViewController</b>
@property (nullable, nonatomic, readonly) UIViewController *hjk_rootViewController;
@end

NS_ASSUME_NONNULL_END
