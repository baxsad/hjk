//
//  HJKTimeTools.h
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJKTimeTools : NSObject

/**
 * 获得当前精确时间（1970年1月1日到现在的时间）
 */
+ (NSTimeInterval)getMicroSeconds;

/**
 * 计算指定时间和当前时刻的间隔
 */
+ (long)computeDurationSince:(long)uTime;
@end

NS_ASSUME_NONNULL_END
