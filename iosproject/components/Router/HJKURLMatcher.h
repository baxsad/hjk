//
//  HJKURLMatcher.h
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJKURLMatcherResult : NSObject
@property (nullable, nonatomic, strong, readonly) NSURL *URL;
@property (nullable, nonatomic, strong, readonly) NSString *scheme;
@property (nullable, nonatomic, strong, readonly) NSArray<NSString*> *pathComponents;
@property (nullable, nonatomic, strong, readonly) NSArray<NSString*> *patternPathComponents;
@property (nullable, nonatomic, strong, readonly) NSDictionary *queryParams;
@property (nullable, nonatomic, strong, readonly) NSString *action;
@property (nullable, nonatomic, strong, readonly) NSDictionary *values;
@end

@interface HJKURLMatcher : NSObject
- (HJKURLMatcherResult *_Nullable)match:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
