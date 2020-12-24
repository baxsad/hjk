//
//  HJKRouterUtilities.m
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKRouterUtilities.h"

@implementation HJKRouterUtilities

+ (NSString *)routeIdentifierWithRoute:(HJKURLDefinition *)route {
    NSMutableString *identifier = [NSMutableString string];
    [identifier appendString:route.scheme];
    [identifier appendString:@"://"];
    [identifier appendString:[route.patternPathComponents componentsJoinedByString:@"/"]];
    
    return [identifier copy];;
}

+ (NSString *)routeIdentifierWithMatcherResultPattern:(HJKURLMatcherResult *)result {
    NSMutableString *identifier = [NSMutableString string];
    [identifier appendString:result.scheme];
    [identifier appendString:@"://"];
    [identifier appendString:[result.patternPathComponents componentsJoinedByString:@"/"]];
    
    return [identifier copy];;
}

+ (NSString *)routeIdentifierWithMatcherResultNoPattern:(HJKURLMatcherResult *)result {
    NSMutableString *identifier = [NSMutableString string];
    [identifier appendString:result.scheme];
    [identifier appendString:@"://"];
    [identifier appendString:[result.pathComponents componentsJoinedByString:@"/"]];
    
    return [identifier copy];;
}
@end
