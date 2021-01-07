//
//  ESCPRouterUtilities.h
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPURLDefinition.h"
#import "ESCPURLMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCPRouterUtilities : NSObject
+ (NSString *)routeIdentifierWithRoute:(ESCPURLDefinition *)route;
+ (NSString *)routeIdentifierWithMatcherResultPattern:(ESCPURLMatcherResult *)result;
+ (NSString *)routeIdentifierWithMatcherResultNoPattern:(ESCPURLMatcherResult *)result;
@end

NS_ASSUME_NONNULL_END
