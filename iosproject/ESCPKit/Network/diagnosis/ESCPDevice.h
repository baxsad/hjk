//
//  ESCPDevice.h
//  iosproject
//
//  Created by hlcisy on 2020/9/29.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RealReachability/RealReachability.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCPDevice : NSObject

/**
 * @abstract 获取应用名称
 */
+ (NSString *)getApplicationName;

/**
 * @abstract 获取应用版本号
 */
+ (NSString *)getApplicationVersion;

/**
 * @abstract 获取设备型号：iPhone 11 Pro Max、iPad Pro (12.9 inch)
 * @see [ESUIHelper deviceName]
 */
+ (NSString *)getDeviceName;

/**
 * @abstract 获取设备版本号：iPhone 11 Pro Max、iPad Pro (12.9 inch)
 */
+ (NSString *)getDeviceVersion;

/**
 * @abstract 获取运营商名字
 */
+ (NSString *)getOperatorName;

/**
 * @abstract 获取网络类型
 * @see RealReachability
 */
+ (NSString *)getNetWorkType;
@end

NS_ASSUME_NONNULL_END
