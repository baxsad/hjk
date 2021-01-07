//
//  UIImage+ESUIConvenience.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ESUIConvenience)

/**
 * 创建一个size为(4, 4)的纯色的UIImage
 *
 * @param color 图片的颜色
 * @return 纯色的UIImage
 */
+ (nullable UIImage *)esui_imageWithColor:(nullable UIColor *)color;

/**
 * 创建一个纯色的UIImage
 *
 * @param  color           图片的颜色
 * @param  size            图片的大小
 * @param  cornerRadius    图片的圆角
 * @return 纯色的UIImage
 */
+ (nullable UIImage *)esui_imageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
