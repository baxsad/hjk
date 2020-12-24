//
//  HJKPing.h
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HJKPingDelegate <NSObject>

/**
 * Ping 日志输出
 */
- (void)appendPingLog:(NSString *)pingLog;

/**
 * Ping 结束
 */
- (void)netPingDidEnd;
@end

@interface HJKPing : NSObject

/**
 * Ping 代理
 */
@property (nonatomic, weak) id<HJKPingDelegate> delegate;

/**
 * 开始 Ping 指定的地址
 */
- (void)runWithHostName:(NSString *)hostName normalPing:(BOOL)normalPing;

/**
 * 结束 Ping
 */
- (void)stopPing;
@end

NS_ASSUME_NONNULL_END
