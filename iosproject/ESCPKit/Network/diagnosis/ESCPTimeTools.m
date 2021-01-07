//
//  ESCPTimeTools.m
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPTimeTools.h"
#include <sys/time.h>

@implementation ESCPTimeTools

+ (NSTimeInterval)getMicroSeconds {
    struct timeval time;
    gettimeofday(&time, NULL);
    return time.tv_usec;
}

+ (long)computeDurationSince:(long)uTime {
    long now = [self getMicroSeconds];
    if (now < uTime) {
        return 1000000 - uTime + now;
    }
    return now - uTime;
}
@end
