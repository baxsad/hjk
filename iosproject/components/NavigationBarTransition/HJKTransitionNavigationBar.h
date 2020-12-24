//
//  HJKTransitionNavigationBar.h
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJKTransitionNavigationBar : UINavigationBar

/// 转场过程中假navBar对应的原始navBar
@property (nonatomic, weak) UINavigationBar *originalNavigationBar;
@end

@interface UINavigationBar (NavigationBarTransition)

/// 转场过程中真navBar对应的假navBar
@property (nonatomic, strong) UINavigationBar *transitionNavigationBar;

/// 获取 iOS 11之后的系统自带的返回按钮 Label，如果在转场时，会获取到最上面控制器的
@property (nullable, nonatomic, strong, readonly) UILabel *hjk_backButtonLabel;
@end

NS_ASSUME_NONNULL_END
