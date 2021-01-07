//
//  ESCPRouterUtilities.m
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPRouterUtilities.h"

@implementation ESCPRouterUtilities

+ (NSString *)routeIdentifierWithRoute:(ESCPURLDefinition *)route {
    NSMutableString *identifier = [NSMutableString string];
    [identifier appendString:route.scheme];
    [identifier appendString:@"://"];
    [identifier appendString:[route.patternPathComponents componentsJoinedByString:@"/"]];
    
    return [identifier copy];;
}

+ (NSString *)routeIdentifierWithMatcherResultPattern:(ESCPURLMatcherResult *)result {
    NSMutableString *identifier = [NSMutableString string];
    [identifier appendString:result.scheme];
    [identifier appendString:@"://"];
    [identifier appendString:[result.patternPathComponents componentsJoinedByString:@"/"]];
    
    return [identifier copy];;
}

+ (NSString *)routeIdentifierWithMatcherResultNoPattern:(ESCPURLMatcherResult *)result {
    NSMutableString *identifier = [NSMutableString string];
    [identifier appendString:result.scheme];
    [identifier appendString:@"://"];
    [identifier appendString:[result.pathComponents componentsJoinedByString:@"/"]];
    
    return [identifier copy];;
}
@end
