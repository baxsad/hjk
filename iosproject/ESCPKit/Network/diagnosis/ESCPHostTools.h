//
//  ESCPHostTools.h
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCPHostTools : NSObject

/*!
 * 获取当前设备ip地址
 */
+ (NSString *)localNativeIPAddress;

/*!
 * 获取当前设备网关地址
 */
+ (NSString *)localGatewayIPAddress;

/*!
 * 获取本地网络的DNS地址
 */
+ (NSArray *)localDNSServers;

/*!
 * 通过域名获取服务器DNS地址
 */
+ (NSArray *)remoteDNSServersWithHost:(NSString *)host;
@end

NS_ASSUME_NONNULL_END
