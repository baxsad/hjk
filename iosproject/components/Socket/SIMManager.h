//
//  SIMManager.h
//  iosproject
//
//  Created by hlcisy on 2020/8/26.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "SIMComm.h"
#import "SIMConnListener.h"
#import "SIMMessageListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMManager : NSObject

/**
 * 单例对象
 */
+ (SIMManager *)sharedInstance;

/**
 * WebSocket 服务端地址
 */
@property (nonatomic, copy, readonly) NSURL *url;

/**
 * WebSocket 连接状态代理通知
 */
@property (nullable, nonatomic, weak) id<SIMConnListener> connListener;

/**
 * 添加 WebSocket 消息代理通知
 */
- (int)addMessageListener:(id<SIMMessageListener>)listener;

/**
 * 移除 WebSocket 消息代理通知
 */
- (int)removeMessageListener:(id<SIMMessageListener>)listener;

/**
 * 连接 WebSocket
 */
- (void)connect;

/**
 * 获取 WebSocket 连接状态
 */
@property (nonatomic, assign, readonly) SIMConnState connectState;

/**
 * 获取 WebSocket 是否已连接
 */
@property (nonatomic, assign, readonly) BOOL isConnecting;

/**
 * 是否支持断线重连
 */
@property (nonatomic, assign) BOOL autoReconnect;

/**
 * 支持重连的次数，如果重连次数超过此数值则判定失败
 */
@property (nonatomic, assign) NSInteger retryCount;
@end

NS_ASSUME_NONNULL_END
