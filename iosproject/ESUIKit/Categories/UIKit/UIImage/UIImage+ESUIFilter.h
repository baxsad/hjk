//
//  UIImage+ESUIFilter.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ESUIFilter)

/// 保持当前图片的形状不变，使用指定的颜色去重新渲染它，生成一张新图片并返回
/// @param tintColor 要用于渲染的新颜色
/// @return 与当前图片形状一致但颜色与参数tintColor相同的新图片
- (nullable UIImage *)esui_imageWithTintColor:(nullable UIColor *)tintColor;

/// 置灰当前图片
/// @return 已经置灰的图片
- (nullable UIImage *)esui_grayImage;
@end

NS_ASSUME_NONNULL_END
