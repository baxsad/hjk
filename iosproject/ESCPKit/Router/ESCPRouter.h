//
//  ESCPRouter.h
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPRouterProtocol.h"
#import "ESCPURLMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCPRouter : NSObject <ESCPRouterProtocol>
+ (instancetype)global;
@property (nonatomic, strong, readonly) ESCPURLMatcher *matcher;
@property (nullable, nonatomic, weak) id<ESCPRouterDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
