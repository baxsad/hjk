//
//  ESUINavigationBarTransitionDelegate.h
//  iosproject
//
//  Created by hlcisy on 2020/12/23.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ESUINavigationBarTransitionDelegate <NSObject>

@optional

/// 设置每个界面导航栏的显示/隐藏
- (BOOL)preferredNavigationBarHidden;

/// 设置导航栏转场的时候是否需要使用自定义的 push / pop transition 效果
- (nullable NSString *)customNavigationBarTransitionKey;

/// 在实现了系统的自定义转场情况下，导航栏转场的时候是否需要使用自定义的 push / pop transition 效果
/// 默认不实现的话则不会使用，只要前后其中一个 vc 实现并返回了 YES 则会使用
- (BOOL)shouldCustomizeNavigationBarTransitionIfUsingCustomTransitionForOperation:(UINavigationControllerOperation)operation fromViewController:(nullable UIViewController *)from toViewController:(nullable UIViewController *)to;

/// 自定义navBar效果过程中UINavigationController的containerView的背景色
- (nullable UIColor *)containerViewBackgroundColorWhenTransitioning;
@end

NS_ASSUME_NONNULL_END
