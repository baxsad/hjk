//
//  UINavigationBar+HJK.h
//  iosproject
//
//  Created by hlcisy on 2020/12/23.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (HJK)

/**
 * UINavigationBar 在 iOS 11 下所有的 item 都会由 contentView 管理
 * 只要在 UINavigationController init 完成后就能拿到 hjk_contentView 的值
 */
@property (nonatomic, strong, readonly, nullable) UIView *hjk_contentView API_AVAILABLE(ios(11.0));

/**
 * UINavigationBar 的背景 view，可能显示磨砂、背景图，顶部有一部分溢出到 UINavigationBar 外。
 * 在 iOS 10 及以后是私有的 _UIBarBackground 类。
 * 在 iOS 9 及以前是私有的 _UINavigationBarBackground 类。
 */
@property (nonatomic, strong, readonly, nullable) UIView *hjk_backgroundView;
@end

NS_ASSUME_NONNULL_END
