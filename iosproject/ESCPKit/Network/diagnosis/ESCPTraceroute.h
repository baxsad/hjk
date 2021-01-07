//
//  ESCPTraceroute.h
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const int TRACEROUTE_PORT     = 30001;
static const int TRACEROUTE_MAX_TTL  = 30;
static const int TRACEROUTE_ATTEMPTS = 3;
static const int TRACEROUTE_TIMEOUT  = 5000000;

@protocol ESCPTracerouteDelegate <NSObject>
- (void)appendRouteLog:(NSString *)routeLog;
- (void)traceRouteDidEnd;
@end

@interface ESCPTraceroute : NSObject {
    int udpPort;
    int maxTTL;
    int readTimeout;
    int maxAttempts;
    NSString *running;
    bool isrunning;
}
@property (nonatomic, weak) id<ESCPTracerouteDelegate> delegate;
- (ESCPTraceroute *)initWithMaxTTL:(int)ttl timeout:(int)timeout maxAttempts:(int)attempts port:(int)port;
- (Boolean)doTraceRoute:(NSString *)host;
- (void)stopTrace;
- (bool)isRunning;
@end

NS_ASSUME_NONNULL_END
