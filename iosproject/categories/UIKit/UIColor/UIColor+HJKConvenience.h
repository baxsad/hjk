//
//  UIColor+HJKConvenience.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HJKConvenience)

/// 使用HEX命名方式的颜色字符串生成一个UIColor对象
/// @param hexString 支持以 # 开头和不以 # 开头的 hex 字符串
/// @return UIColor对象
+ (nullable UIColor *)hjk_colorWithHexString:(nullable NSString *)hexString;
@end

NS_ASSUME_NONNULL_END
