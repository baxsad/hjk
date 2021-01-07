//
//  UIImage+ESUIInfo.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ESUIInfo)

/// 当前图片是否是可拉伸/平铺的，也即通过 resizableImageWithCapInsets: 处理过的图片
@property (nonatomic, assign, readonly) BOOL esui_resizable;

/// 获取当前图片的像素大小，如果是多倍图，会被放大到一倍来算
@property (nonatomic, assign, readonly) CGSize esui_sizeInPixel;

/// 判断一张图是否不存在 alpha 通道，注意 “不存在 alpha 通道” 不等价于 “不透明”。
/// @note 一张不透明的图有可能是存在 alpha 通道但 alpha 值为 1。
- (BOOL)esui_opaque;

/// 获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
/// @link http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/ @/link
/// @return 代表图片平均颜色的UIColor对象
- (UIColor *)esui_averageColor;
@end

NS_ASSUME_NONNULL_END
