//
//  ESCPURLDefinition.m
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPURLDefinition.h"
#import "ESUIKit.h"

@interface ESCPURLDefinition ()
@property (nonatomic, strong, readwrite) NSString *scheme;
@property (nonatomic, strong, readwrite) NSString *pattern;
@property (nonatomic, strong, readwrite) NSArray<NSString*> *patternPathComponents;
@property (nonatomic, strong, readwrite) NSString *match;
@property (nonatomic, copy, readwrite) ESCPRouterViewControllerFactory viewControllerFactory;
@property (nonatomic, copy, readwrite) ESCPRouterURLOpenHandlerFactory openHandlerFactory;
@end

@implementation ESCPURLDefinition

- (instancetype)init {
    return [self initWithPattern:@""];
}

+ (instancetype)new {
    return [[self alloc] initWithPattern:@""];
}

- (instancetype)initWithPattern:(NSString *)pattern {
    NSParameterAssert(pattern.length);
    self = [super init];
    if (self) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"/"];
        pattern = [pattern stringByTrimmingCharactersInSet:set];
        NSURL *url = [[NSURL alloc] initWithString:pattern];
        if (!url) {
            return nil;
        }
        
        self.pattern = pattern;
        
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
            [pathComponents addObjectsFromArray:[path componentsSeparatedByString:@"/"]];
        }
        
        NSString *matchString = @"";
        if ([lastpath rangeOfString:@":"].location != NSNotFound) {
            [pathComponents removeLastObject];
            if ([lastpath characterAtIndex:0] == ':') {
                matchString = [lastpath substringFromIndex:1];
            }
        }
        
        self.match = matchString;
        self.scheme = scheme;
        self.patternPathComponents = [pathComponents esui_filterWithBlock:^BOOL(NSString *path) {
            return path.length > 0;
        }];
    }
    
    if (self.pattern.length &&
        self.scheme.length &&
        self.patternPathComponents.count) {
        return self;
    }
    
    return nil;
}

- (nullable instancetype)initWithPattern:(NSString *)pattern viewControllerFactory:(nonnull ESCPRouterViewControllerFactory)factory {
    self = [self initWithPattern:pattern];
    if (self) {
        self.viewControllerFactory = factory;
    }
    
    return self;
}

- (nullable instancetype)initWithPattern:(NSString *)pattern openHandlerFactory:(ESCPRouterURLOpenHandlerFactory)factory {
    self = [self initWithPattern:pattern];
    if (self) {
        self.openHandlerFactory = factory;
    }
    
    return self;
}

- (BOOL)isMatchOption {
    return self.match.length > 0;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if ([object isKindOfClass:[ESCPURLDefinition class]]) {
        return [self isEqualToURLDefinition:object];
    } else {
        return [super isEqual:object];
    }
}

- (BOOL)isEqualToURLDefinition:(ESCPURLDefinition *)definition {
    if (!((self.pattern == nil && definition.pattern == nil) ||
          [self.pattern isEqualToString:definition.pattern])) {
        return NO;
    }
    
    if (!((self.scheme == nil && definition.scheme == nil) ||
          [self.scheme isEqualToString:definition.scheme])) {
        return NO;
    }
    
    if (!((self.patternPathComponents == nil && definition.patternPathComponents == nil) ||
          [self.patternPathComponents isEqualToArray:definition.patternPathComponents])) {
        return NO;
    }
    
    if (!((self.match == nil && definition.match == nil) ||
          [self.match isEqualToString:definition.match])) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash {
    return self.pattern.hash ^ self.scheme.hash ^ self.patternPathComponents.hash ^ self.match.hash;
}
@end
