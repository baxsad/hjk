//
//  SIMManager.m
//  iosproject
//
//  Created by hlcisy on 2020/8/26.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "SIMManager.h"
#import "SIMTools.h"
#import "SIMMutableListeners.h"
#import <RealReachability/RealReachability.h>
#import <SocketRocket/SRWebSocket.h>

@interface SIMManager ()
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, assign) SIMConnState connectState;
@property (nonatomic, strong) NSError *connectError;
@property (nonatomic, strong) NSTimer *heartbeatTimer;
@property (nonatomic, strong) NSTimer *connectingTimer;
@property (nonatomic, strong) NSTimer *pingpongTimer;
@property (nonatomic, strong) SIMMutableListeners *messageListeners;
@end

@interface SIMManager (SocketRocketDelegate) <SRWebSocketDelegate>

@end

static NSInteger const kMaxRetryCount = NSIntegerMax;
static NSTimeInterval const kConnectingTimeout  = 15.0;
static NSTimeInterval const kHeartbeatFrequency = 150.0;
static NSTimeInterval const kPingpongTimeout    = 10.0;

@implementation SIMManager
@synthesize connectState = _connectState;

- (instancetype)init {
    self = [super init];
    if (self) {
        _connectState = SIM_IDLE;
        _connectError = nil;
        _autoReconnect = YES;
        _retryCount = kMaxRetryCount;
        _messageListeners = [SIMMutableListeners weakListeners];
        // _url = [NSURL URLWithString:@"ws://10.6.26.254:8080"];
        _url = [NSURL URLWithString:@"ws://192.168.1.175:8080"];
        
        /**
         * 添加通知事件
         * 1. 进入后台
         * 2. 回到前台
         * 3. Resign Active
         * 4. Become Active
         * 5. 网络状态变化
         */
        [self _addNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    /**
     * 1. 销毁连接超时计时器
     * 2. 销毁心跳计时器
     * 3. 销毁心跳超时计时器
     */
    [self _invalidateConnectingTimer];
    [self _invalidateHeartbeatTimer];
    [self _invalidatePingpongTimer];
}

+ (SIMManager *)sharedInstance {
    static SIMManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[SIMManager alloc] init];
    });
    
    return shared;
}

- (int)addMessageListener:(id<SIMMessageListener>)listener {
    [self.messageListeners addListener:listener];
    return 0;
}

- (int)removeMessageListener:(id<SIMMessageListener>)listener {
    [self.messageListeners removeListener:listener];
    return 0;
}

#pragma mark - Public

- (void)connect {
    [self _open];
}

- (SIMConnState)connectState {
    return _connectState;
}

- (void)setConnectState:(SIMConnState)connectState {
    /**
     * 如果不是断连状态，则清空错误信息
     */
    if (connectState != SIM_DISCONNECTED) {
        self.connectError = nil;
    }
    
    /**
     * 如果新状态和上次状态相同则略过
     */
    if (connectState == _connectState) {
        return;
    }
    
    /**
     * 更新连接状态
     */
    _connectState = connectState;
    
    SEL selector = @selector(connectStateDidChange:error:);
    if (self.connListener && [self.connListener respondsToSelector:selector]) {
        if ([NSThread currentThread] != [NSThread mainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.connListener connectStateDidChange:self.connectState error:self.connectError];
            });
        } else {
            [self.connListener connectStateDidChange:self.connectState error:self.connectError];
        }
    }
}

- (BOOL)isConnecting {
    return _connectState == SIM_CONNECTED;
}

#pragma mark - Notification

- (void)_addNotifications {
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self
                   selector:@selector(_sim_applicationDidEnterBackground:)
                       name:UIApplicationDidEnterBackgroundNotification
                     object:nil];
    [notiCenter addObserver:self
                   selector:@selector(_sim_applicationWillEnterForeground:)
                       name:UIApplicationWillEnterForegroundNotification
                     object:nil];
    [notiCenter addObserver:self
                   selector:@selector(_sim_applicationWillResignActive:)
                       name:UIApplicationWillResignActiveNotification
                     object:nil];
    [notiCenter addObserver:self
                   selector:@selector(_sim_applicationDidBecomeActive:)
                       name:UIApplicationDidBecomeActiveNotification
                     object:nil];
    [notiCenter addObserver:self
                   selector:@selector(_sim_networkChanged:)
                       name:kRealReachabilityChangedNotification
                     object:nil];
}

- (void)_sim_applicationDidEnterBackground:(NSNotification *)noti {
    
}

- (void)_sim_applicationWillEnterForeground:(NSNotification *)noti {
    
}

- (void)_sim_applicationWillResignActive:(NSNotification *)noti {
    
}

- (void)_sim_applicationDidBecomeActive:(NSNotification *)noti {
    
}

- (void)_sim_networkChanged:(NSNotification *)noti {
    RealReachability *reachability = (RealReachability *)noti.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    
    switch (status) {
        case RealStatusUnknown:
        case RealStatusNotReachable: {
            /**
             * 网络断连，标记为离线状态
             */
            self.connectState = SIM_OFFLINE;
        } break;
            
        case RealStatusViaWiFi:
        case RealStatusViaWWAN: {
            /**
             * 网络恢复，如果上次是网络状态是离线则执行重连操作
             */
            if (self.connectState == SIM_OFFLINE) {
                [self _reconnect];
            }
        } break;
            
        default:
            break;
    }
}

#pragma mark - WebSocket

- (int)_open {
    /**
     * 如果网络状态不可用则标记为断连状态
     */
    RealReachability *reachability = [RealReachability sharedInstance];
    ReachabilityStatus reachabilityStatus = [reachability currentReachabilityStatus];
    if (reachabilityStatus == RealStatusUnknown ||
        reachabilityStatus == RealStatusNotReachable) {
        self.connectError = [self _errorWithCode:0 reason:@"network unavailable"];
        self.connectState = SIM_DISCONNECTED;
        return -1;
    }
    
    /**
     * 建立连接之前先断开上次的连接
     */
    [self _close:NO reason:nil];
    
    /**
     * 更新为连接中状态
     */
    self.connectState = SIM_CONNECTING;
    
    /**
     * 开启连接超时倒计时
     */
    [self _startConnectingTimer];
    
    _webSocket = [[SRWebSocket alloc] initWithURL:_url];
    _webSocket.delegate = self;
    
    /**
     * 打开链接
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webSocket open];
    });;
    
    return 0;
}

- (void)_close:(BOOL)updateState reason:(nullable NSString *)reason {
    if (_webSocket) {
        _webSocket.delegate = nil;
        [_webSocket close];
        _webSocket = nil;
    }
    
    if (updateState) {
        if (reason == nil || reason.length == 0) {
            reason = @"unknown";
        }
        self.connectError = [self _errorWithCode:0 reason:reason];
        self.connectState = SIM_DISCONNECTED;
        
        /**
         * 触发重连机制
         */
        [self _reconnect];
    }
}

- (void)_reconnect {
    /**
     * 自动重连开关关闭则略过
     */
    if (!self.autoReconnect) return;
    
    /**
     * 如果重连次数用完则略过
     */
    if (self.retryCount <= 0) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /**
         * 开启链接，重连次数减一
         * 如果打开连接未完成（没有网络），则保留重连次数
         */
        if ([self _open] == 0) {
            self.retryCount --;
            if (self.connListener && [self.connListener respondsToSelector:@selector(reconnectWithNumberOfTimes:)]) {
                [self.connListener reconnectWithNumberOfTimes:kMaxRetryCount - self.retryCount];
            }
        }
    });
}

- (void)_resetRetryCount {
    self.retryCount = kMaxRetryCount;
}

#pragma mark - Heartbeat

- (void)_startHeartbeatTimer {
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
        self.heartbeatTimer = nil;
    }
    
    self.heartbeatTimer = [NSTimer timerWithTimeInterval:kHeartbeatFrequency
                                                  target:self
                                                selector:@selector(_heartbeatEvent)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.heartbeatTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)_invalidateHeartbeatTimer {
    if (self.heartbeatTimer) {
        [self.heartbeatTimer invalidate];
        self.heartbeatTimer = nil;
    }
}

- (void)_heartbeatEvent {
    if (self.webSocket.readyState == SR_OPEN) {
        /**
         * 开启心跳超时计时器
         * 发送心跳包
         */
        [self _startPingpongTimer];
        [self.webSocket sendPing:nil];
    } else {
        /**
         * 如果连接不是打开状态，则更新状态为断开连接
         */
        self.connectState = SIM_DISCONNECTED;
        
        /**
         * 触发重连机制
         */
        [self _reconnect];
    }
}

#pragma mark - Connecting Timeout

- (void)_startConnectingTimer {
    if (self.connectingTimer) {
        [self.connectingTimer invalidate];
        self.connectingTimer = nil;
    }
    
    self.connectingTimer = [NSTimer timerWithTimeInterval:kConnectingTimeout
                                                   target:self
                                                 selector:@selector(_connectingTimeoutEvent)
                                                 userInfo:nil
                                                  repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.connectingTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)_invalidateConnectingTimer {
    if (self.connectingTimer) {
        [self.connectingTimer invalidate];
        self.connectingTimer = nil;
    }
}

- (void)_connectingTimeoutEvent {
    /**
     * 连接超时
     * 1. 销毁连接超时计时器
     * 2. 关闭连接（应该是重连的）
     */
    [self _invalidateConnectingTimer];
    [self _close:YES reason:@"connecting timeout"];
}

#pragma mark - Pingpong Timeout

- (void)_startPingpongTimer {
    if (self.pingpongTimer) {
        [self.pingpongTimer invalidate];
        self.pingpongTimer = nil;
    }
    
    self.pingpongTimer = [NSTimer timerWithTimeInterval:kPingpongTimeout
                                                 target:self
                                               selector:@selector(_pingpongTimeoutEvent)
                                               userInfo:nil
                                                repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.pingpongTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)_invalidatePingpongTimer {
    if (self.pingpongTimer) {
        [self.pingpongTimer invalidate];
        self.pingpongTimer = nil;
    }
}

- (void)_pingpongTimeoutEvent {
    /**
     * 心跳超时
     * 1. 销毁连接超时计时器
     * 2. 关闭连接（应该是重连的）
     */
    [self _invalidatePingpongTimer];
    [self _close:YES reason:@"heartbeat timeout"];
}

#pragma mark - Helper

- (NSError *)_errorWithCode:(int)code reason:(NSString *)reason {
    NSDictionary *info = @{NSLocalizedDescriptionKey:reason};
    NSErrorDomain domain = @"SIMManagerErrorDomain";
    return [NSError errorWithDomain:domain code:code userInfo:info];
}
@end

@implementation SIMManager (SocketRocketDelegate)

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    /**
     * 如果能收到消息说明连接是正常的，则也可以代替心跳所以可以暂停掉心跳超时计时器
     * 心跳的作用就是来保证连接不被关闭的
     */
    [self _invalidatePingpongTimer];
    
    /**
     * 收到消息说明连接正常，这里如果连接状态是断连状态的话则更新为连接状态
     * 此逻辑是一个异常情况的处理逻辑吧，如果出现状态不对的情况此处可以更新过来
     */
    if (self.connectState != SIM_CONNECTED) {
        self.connectState = SIM_CONNECTED;
    }
    
    for (id<SIMMessageListener> listener in self.messageListeners.listeners) {
        if (listener && [listener respondsToSelector:@selector(receiveMessage:)]) {
            if ([NSThread currentThread] != [NSThread mainThread]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [listener receiveMessage:message];
                });
            } else {
                [listener receiveMessage:message];
            }
        }
    };
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    /**
     * 连接已经建立
     * 1. 销毁连接超时计时器
     * 2. 销毁心跳超时计时器
     * 3. 开启心跳保活
     * 4. 重置重连次数（重连次数一般指连续连接失败的场景）
     */
    [self _invalidateConnectingTimer];
    [self _invalidatePingpongTimer];
    [self _startHeartbeatTimer];
    [self _resetRetryCount];
    
    /**
     * 更新连接状态为已连接
     */
    self.connectState = SIM_CONNECTED;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    /**
     * 连接失败
     * 1. 销毁连接超时计时器
     * 2. 销毁心跳计时器
     * 3. 销毁心跳超时计时器
     */
    [self _invalidateConnectingTimer];
    [self _invalidateHeartbeatTimer];
    [self _invalidatePingpongTimer];
    
    if (error.code == 57) {
        NSLog(@"socket closed, mostly when in background, try reconncet");
        self.connectError = [self _errorWithCode:0 reason:error.localizedDescription];
        self.connectState = SIM_DISCONNECTED;
    } else if (error.code == 61) {
        NSLog(@"connection refused, looks like the server is down");
        self.connectError = [self _errorWithCode:0 reason:error.localizedDescription];
        self.connectState = SIM_DISCONNECTED;
    } else {
        self.connectError = [self _errorWithCode:0 reason:error.localizedDescription];
        self.connectState = SIM_DISCONNECTED;
    }
    
    /**
     * 触发重连机制
     */
    [self _reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    /**
     * 连接关闭
     * 1. 销毁连接超时计时器
     * 2. 销毁心跳计时器
     * 3. 销毁心跳超时计时器
     */
    [self _invalidateConnectingTimer];
    [self _invalidateHeartbeatTimer];
    [self _invalidatePingpongTimer];
    
    /**
     * 更新状态为失去连接
     */
    self.connectError = [self _errorWithCode:0 reason:reason];
    self.connectState = SIM_DISCONNECTED;
    
    /**
     * 触发重连机制
     */
    [self _reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    /**
     * 收到心跳包回应说明连接正常，则销毁心跳包超时计时器
     */
    [self _invalidatePingpongTimer];
}
@end
