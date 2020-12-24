//
//  HJKNavigationBarAppearanceDelegate.h
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HJKNavigationBarAppearanceDelegate <NSObject>

@optional

/// 设置 titleView 的 tintColor
- (nullable UIColor *)titleViewTintColor;

/// 设置导航栏的背景图，默认为 NavBarBackgroundImage
- (nullable UIImage *)navigationBarBackgroundImage;

/// 设置导航栏底部的分隔线图片，默认为 NavBarShadowImage，必须在 navigationBar 设置了背景图后才有效（系统限制如此）
- (nullable UIImage *)navigationBarShadowImage;

/// 设置当前导航栏的 barTintColor，默认为 NavBarBarTintColor
- (nullable UIColor *)navigationBarBarTintColor;

/// 设置当前导航栏的 barStyle，默认为 NavBarStyle
- (UIBarStyle)navigationBarStyle;

/// 设置当前导航栏的 UIBarButtonItem 的 tintColor，默认为NavBarTintColor
- (nullable UIColor *)navigationBarTintColor;
@end

NS_ASSUME_NONNULL_END
