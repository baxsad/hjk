//
//  HJKTimeTools.m
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKTimeTools.h"
#include <sys/time.h>

@implementation HJKTimeTools

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
