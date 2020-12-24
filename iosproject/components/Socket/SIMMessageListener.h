//
//  SIMMessageListener.h
//  iosproject
//
//  Created by hlcisy on 2020/8/26.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SIMManager;

@protocol SIMMessageListener <NSObject>
@optional
- (void)receiveMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
