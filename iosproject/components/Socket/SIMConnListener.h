//
//  SIMConnListener.h
//  iosproject
//
//  Created by hlcisy on 2020/8/26.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "SIMComm.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SIMConnListener <NSObject>
@optional
- (void)connectStateDidChange:(SIMConnState)state error:(nullable NSError *)error;
- (void)reconnectWithNumberOfTimes:(NSInteger)times;
@end

NS_ASSUME_NONNULL_END
