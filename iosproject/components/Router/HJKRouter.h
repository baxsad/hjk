//
//  HJKRouter.h
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKRouterProtocol.h"
#import "HJKURLMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJKRouter : NSObject <HJKRouterProtocol>
+ (instancetype)global;
@property (nonatomic, strong, readonly) HJKURLMatcher *matcher;
@property (nullable, nonatomic, weak) id<HJKRouterDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
