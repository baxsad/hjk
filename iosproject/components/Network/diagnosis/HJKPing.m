//
//  HJKPing.m
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKPing.h"
#import "HJKTimeTools.h"
#import "SimplePing.h"
#include <netdb.h>

#define MAXCOUNT_PING 4

@interface HJKPing () <SimplePingDelegate>

/**
 * 监测第一次ping是否成功
 */
@property (nonatomic, assign) BOOL isStartSuccess;

/**
 * 当前执行次数
 */
@property (nonatomic, assign) NSInteger sendCount;

/**
 * 每次执行的开始时间
 */
@property (nonatomic, assign) NSTimeInterval startTime;

/**
 * 目标域名的IP地址
 */
@property (nonatomic, strong) NSString *hostAddress;

@property (nonatomic, assign) BOOL isLargePing;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SimplePing *ping;
@end

@implementation HJKPing

- (void)dealloc {
    [self.ping stop];
}

- (void)stopPing {
    [self.ping stop];
    self.ping = nil;
    _sendCount = MAXCOUNT_PING + 1;
}

/**
 * 调用pinger解析指定域名
 * @param hostName 指定域名
 */
- (void)runWithHostName:(NSString *)hostName normalPing:(BOOL)normalPing {
    assert(self.ping == nil);
    self.ping = [[SimplePing alloc] initWithHostName:hostName];
    assert(self.ping != nil);
    
    _isLargePing = !normalPing;
    self.ping.delegate = self;
    [self.ping start];

    _sendCount = 1;
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (self.ping != nil || _sendCount <= MAXCOUNT_PING);
}

/**
 * 发送Ping数据，pinger会组装一个ICMP控制报文的数据发送过去
 */
- (void)sendPing {
    if (self.timer) {
        [self.timer invalidate];
    }
    
    if (_sendCount > MAXCOUNT_PING) {
        _sendCount++;
        self.ping = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(netPingDidEnd)]) {
            [self.delegate netPingDidEnd];
        }
    } else {
        assert(self.ping != nil);
        _sendCount++;
        _startTime = [HJKTimeTools getMicroSeconds];
        if (_isLargePing) {
            NSString *testStr = @"";
            for (int i=0; i<408; i++) {
                testStr = [testStr stringByAppendingString:@"abcdefghi "];
            }
            testStr = [testStr stringByAppendingString:@"abcdefgh"];
            NSData *data = [testStr dataUsingEncoding:NSASCIIStringEncoding];
            [self.ping sendPingWithData:data];
        } else {
            [self.ping sendPingWithData:nil];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                      target:self
                                                    selector:@selector(pingTimeout:)
                                                    userInfo:[NSNumber numberWithInteger:_sendCount]
                                                     repeats:NO];
    }
}

- (void)pingTimeout:(NSTimer *)index {
    if ([[index userInfo] intValue] == _sendCount && _sendCount <= MAXCOUNT_PING + 1 &&
        _sendCount > 1) {
        NSString *timeoutLog =
            [NSString stringWithFormat:@"ping: cannot resolve %@: TimeOut", _hostAddress];
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
            [self.delegate appendPingLog:timeoutLog];
        }
        [self sendPing];
    }
}

#pragma mark - <Pingdelegate>

/**
 * PingDelegate: 套接口开启之后发送ping数据，并开启一个timer（1s间隔发送数据）
 */
- (void)simplePing:(SimplePing *)ping didStartWithAddress:(NSData *)address {
#pragma unused(ping)
    assert(ping == self.ping);
    assert(address != nil);
    _hostAddress = [self DisplayAddressForAddress:address];

    /**
     * Send the first ping straight away.
     */
    
    _isStartSuccess = YES;
    [self sendPing];
}

/**
 * PingDelegate: ping命令发生错误之后，立即停止timer和线程
 */
- (void)simplePing:(SimplePing *)ping didFailWithError:(NSError *)error {
#pragma unused(ping)
    assert(ping == self.ping);
#pragma unused(error)
    NSString *failCreateLog = [NSString stringWithFormat:@"#%li try create failed: %@",
                               _sendCount,
                               [self shortErrorFromError:error]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
        [self.delegate appendPingLog:failCreateLog];
    }

    /**
     * 如果不是创建套接字失败，都是发送数据过程中的错误,可以继续try发送数据
     */
    
    if (_isStartSuccess) {
        [self sendPing];
    } else {
        [self stopPing];
    }
}

/**
 * PingDelegate: 发送ping数据成功
 */
- (void)simplePing:(SimplePing *)ping didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber; {
#pragma unused(ping)
    assert(ping == self.ping);
#pragma unused(packet)
}

/**
 * PingDelegate: 发送ping数据失败
 */
- (void)simplePing:(SimplePing *)ping didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
#pragma unused(ping)
    assert(ping == self.ping);
#pragma unused(packet)
#pragma unused(error)
    NSString *sendFailLog = [NSString stringWithFormat:@"#%u send failed: %@",
                             sequenceNumber,
                             [self shortErrorFromError:error]];

    if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
        [self.delegate appendPingLog:sendFailLog];
    }

    [self sendPing];
}

/**
 * PingDelegate: 成功接收到PingResponse数据
 */
- (void)simplePing:(SimplePing *)ping didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
#pragma unused(ping)
    assert(ping == self.ping);
#pragma unused(packet)
    
    /**
     * 由于IPV6在IPheader中不返回TTL数据，所以这里不返回TTL，改为返回Type
     * @see http://blog.sina.com.cn/s/blog_6a1837e901012ds8.html
     */
    
    NSString *icmpReplyType = [NSString stringWithFormat:@"%@",
                               [self icmpInPacket:packet]->type == 129 ? @"ICMPv6TypeEchoReply" : @"ICMPv4TypeEchoReply"];
    NSString *successLog = [NSString
        stringWithFormat:@"%lu bytes from %@ icmp_seq=#%u type=%@ time=%ldms",
                         (unsigned long)[packet length], _hostAddress,
                         sequenceNumber,
                         icmpReplyType,
                         [HJKTimeTools computeDurationSince:_startTime] / 1000];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
        [self.delegate appendPingLog:successLog];
    }

    [self sendPing];
}

/**
 * PingDelegate: 接收到错误的pingResponse数据
 */
- (void)simplePing:(SimplePing *)ping didReceiveUnexpectedPacket:(NSData *)packet {
    const ICMPHeader *icmpPtr;
    if (self.ping && ping == self.ping) {
        icmpPtr = [self icmpInPacket:packet];
        NSString *errorLog = @"";
        if (icmpPtr != NULL) {
            errorLog = [NSString
                stringWithFormat:@"#%u unexpected ICMP type=%u, code=%u, identifier=%u",
                                 (unsigned int)OSSwapBigToHostInt16(icmpPtr->sequenceNumber),
                                 (unsigned int)icmpPtr->type, (unsigned int)icmpPtr->code,
                                 (unsigned int)OSSwapBigToHostInt16(icmpPtr->identifier)];
        } else {
            errorLog = [NSString stringWithFormat:@"#%li try unexpected packet size=%zu", _sendCount,
                                                  (size_t)[packet length]];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
            [self.delegate appendPingLog:errorLog];
        }
    }

    /**
     * 当检测到错误数据的时候，再次发送
     */
    
    [self sendPing];
}

#pragma mark - Helper

- (const struct ICMPHeader *)icmpInPacket:(NSData *)packet {
    const struct ICMPHeader *result;
    result = nil;
    
    if (packet.length >= sizeof(*result)) {
        result = packet.bytes;
    }
    
    return result;
}

/**
 * 将ping接收的数据转换成ip地址
 * @param address 接受的ping数据
 */
-(NSString *)DisplayAddressForAddress:(NSData *)address {
    int err;
    NSString *result;
    char hostStr[NI_MAXHOST];
    
    result = nil;
    
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t)[address length], hostStr, sizeof(hostStr), NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
            assert(result != nil);
        }
    }
    
    return result;
}

/**
 * 解析错误数据并翻译
 */
- (NSString *)shortErrorFromError:(NSError *)error {
    NSString *result;
    NSNumber *failureNum;
    int failure;
    const char *failureStr;
    
    assert(error != nil);
    
    result = nil;
    
    /**
     * Handle DNS errors as a special case.
     */
    
    if ([[error domain] isEqual:(NSString *)kCFErrorDomainCFNetwork] &&
        ([error code] == kCFHostErrorUnknown)) {
        failureNum = [[error userInfo] objectForKey:(id)kCFGetAddrInfoFailureKey];
        if ([failureNum isKindOfClass:[NSNumber class]]) {
            failure = [failureNum intValue];
            if (failure != 0) {
                failureStr = gai_strerror(failure);
                if (failureStr != NULL) {
                    result = [NSString stringWithUTF8String:failureStr];
                    assert(result != nil);
                }
            }
        }
    }
    
    /**
     * Otherwise try various properties of the error object.
     */
    
    if (result == nil) {
        result = [error localizedFailureReason];
    }
    
    if (result == nil) {
        result = [error localizedDescription];
    }
    
    if (result == nil) {
        result = [error description];
    }
    
    assert(result != nil);
    return result;
}
@end
