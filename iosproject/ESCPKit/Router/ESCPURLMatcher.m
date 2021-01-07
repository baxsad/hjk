//
//  ESCPURLMatcher.m
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPURLMatcher.h"
#import "ESUIKit.h"

@interface ESCPURLMatcherResult ()
@property (nullable, nonatomic, strong, readwrite) NSURL *URL;
@property (nullable, nonatomic, strong, readwrite) NSString *scheme;
@property (nullable, nonatomic, strong, readwrite) NSArray<NSString*> *pathComponents;
@property (nullable, nonatomic, strong, readwrite) NSArray<NSString*> *patternPathComponents;
@property (nullable, nonatomic, strong, readwrite) NSDictionary *queryParams;
@property (nullable, nonatomic, strong, readwrite) NSString *action;
@property (nullable, nonatomic, strong, readwrite) NSDictionary *values;
@end

@implementation ESCPURLMatcherResult

@end

@interface NSURL (ESCPURLMatcher)
- (NSDictionary<NSString *, NSString *> *)escprt_queryItems;
@end

@interface NSString (ESCPURLMatcher)
- (NSArray<NSString*> *)escprt_trimmedPathComponents;
@end

@implementation ESCPURLMatcher

- (ESCPURLMatcherResult *_Nullable)match:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    NSString *scheme   = url.scheme;
    if (!scheme || !scheme.length) {
        return nil;
    }
    NSString *host     = url.host;
    NSString *path     = url.path;
    NSString *lastpath = url.lastPathComponent;
    
    NSMutableArray<NSString *> *pathComponents = [NSMutableArray array];
    if (host) { [pathComponents addObject:host]; }
    if (path) {
        [pathComponents addObjectsFromArray:[path.escprt_trimmedPathComponents esui_filterWithBlock:^BOOL(NSString * _Nonnull item) {
            return item.length > 0;
        }]];
    }
    
    if (pathComponents.count < 2) {
        return nil;
    }
    
    NSArray *components1 = [pathComponents copy];
    [pathComponents removeLastObject];
    NSArray *components2 = [pathComponents copy];
    
    ESCPURLMatcherResult *result = [[ESCPURLMatcherResult alloc] init];
    result.URL = url;
    result.scheme = scheme;
    result.pathComponents = components1;
    result.patternPathComponents = components2;
    result.action = lastpath;
    result.values = url.escprt_queryItems;
    
    return result;
}
@end

@implementation NSURL (ESCPURLMatcher)

- (NSDictionary<NSString *, NSString *> *)escprt_queryItems {
    if (!self.absoluteString.length) {
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            [params setObject:obj.value ?: [NSNull null] forKey:obj.name];
        }
    }];
    return [params copy];
}
@end

@implementation NSString (ESCPURLMatcher)

- (NSArray<NSString*> *)escprt_trimmedPathComponents {
    NSString *trimStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    return [trimStr componentsSeparatedByString:@"/"];
}
@end
