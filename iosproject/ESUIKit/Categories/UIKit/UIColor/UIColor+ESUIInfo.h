//
//  UIColor+ESUIInfo.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ESUIInfo)

/**
 * 获取当前 UIColor 对象里的红色色值
 * @return 红色通道的色值，值范围为0.0-1.0
 */
@property (nonatomic, assign, readonly) CGFloat esui_red;

/**
 * 获取当前 UIColor 对象里的绿色色值
 * @return 绿色通道的色值，值范围为0.0-1.0
 */
@property (nonatomic, assign, readonly) CGFloat esui_green;

/**
 * 获取当前 UIColor 对象里的蓝色色值
 * @return 蓝色通道的色值，值范围为0.0-1.0
 */
@property (nonatomic, assign, readonly) CGFloat esui_blue;

/**
 * 获取当前 UIColor 对象里的透明色值
 * @return 透明通道的色值，值范围为0.0-1.0
 */
@property (nonatomic, assign, readonly) CGFloat esui_alpha;

/**
 * 获取当前 UIColor 对象里的 hue（色相），注意 hue 的值是一个角度，所以0和1（0°和360°）是等价的，用 return 值去做判断时要特别注意。
 */
@property (nonatomic, assign, readonly) CGFloat esui_hue;

/**
 * 获取当前 UIColor 对象里的 saturation（饱和度）
 */
@property (nonatomic, assign, readonly) CGFloat esui_saturation;

/**
 * 获取当前 UIColor 对象里的 brightness（亮度）
 */
@property (nonatomic, assign, readonly) CGFloat esui_brightness;
@end

NS_ASSUME_NONNULL_END
