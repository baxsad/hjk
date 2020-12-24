//
//  HJKRouterUtilities.h
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKURLDefinition.h"
#import "HJKURLMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJKRouterUtilities : NSObject
+ (NSString *)routeIdentifierWithRoute:(HJKURLDefinition *)route;
+ (NSString *)routeIdentifierWithMatcherResultPattern:(HJKURLMatcherResult *)result;
+ (NSString *)routeIdentifierWithMatcherResultNoPattern:(HJKURLMatcherResult *)result;
@end

NS_ASSUME_NONNULL_END
