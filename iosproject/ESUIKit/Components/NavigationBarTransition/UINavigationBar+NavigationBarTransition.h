//
//  UINavigationBar+NavigationBarTransition.h
//  iosproject
//
//  Created by hlcisy on 2021/1/8.
//  Copyright © 2021 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (NavigationBarTransition)

/// 转场过程中真navBar对应的假navBar
@property (nonatomic, strong) UINavigationBar *transitionNavigationBar;

/// 获取 iOS 11之后的系统自带的返回按钮 Label，如果在转场时，会获取到最上面控制器的
@property (nullable, nonatomic, strong, readonly) UILabel *esui_backButtonLabel;
@end

NS_ASSUME_NONNULL_END
