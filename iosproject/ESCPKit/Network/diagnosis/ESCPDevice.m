//
//  ESCPDevice.m
//  iosproject
//
//  Created by hlcisy on 2020/9/29.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPDevice.h"
#import "ESUIKit.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>

@implementation ESCPDevice

static NSString *applicationName = nil;
+ (NSString *)getApplicationName {
    if (!applicationName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        applicationName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return applicationName;
}

static NSString *applicationVersion = nil;
+ (NSString *)getApplicationVersion {
    if (!applicationVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        applicationVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return applicationVersion;
}

static NSString *deviceName = nil;
+ (NSString *)getDeviceName {
    if (!deviceName) {
        deviceName = [ESUIHelper deviceName];
    }
    return deviceName;
}

static NSString *deviceVersion = nil;
+ (NSString *)getDeviceVersion {
    if (!deviceVersion) {
        deviceVersion = [[UIDevice currentDevice] systemVersion];
    }
    return deviceVersion;
}

+ (NSString *)getOperatorName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *carrierName = [carrier carrierName];
    return carrierName?:@"Unknown";
}

+ (NSString *)getNetWorkType {
    NSString *networkType = nil;
    
    ReachabilityStatus status = GLobalRealReachability.currentReachabilityStatus;
    if (status == RealStatusViaWiFi) {
        networkType = @"WIFI";
    } else if (status == RealStatusViaWWAN) {
        WWANAccessType access = GLobalRealReachability.currentWWANtype;
        if (access == WWANType4G) {
            networkType = @"4G";
        } else if (access == WWANType3G) {
            networkType = @"3G";
        } else if (access == WWANType2G) {
            networkType = @"2G";
        } else {
            networkType = @"Unknown";
        }
    } else {
        networkType = @"Unknown";
    }
    
    return networkType;
}
@end
