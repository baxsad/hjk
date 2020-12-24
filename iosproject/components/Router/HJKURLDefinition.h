//
//  HJKURLDefinition.h
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKRouterCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJKURLDefinition : NSObject
@property (nonatomic, strong, readonly) NSString *scheme;
@property (nonatomic, strong, readonly) NSString *pattern;
@property (nonatomic, strong, readonly) NSArray<NSString*> *patternPathComponents;
@property (nonatomic, strong, readonly) NSString *match;
@property (nonatomic, assign, readonly) BOOL isMatchOption;
@property (nonatomic, copy, readonly) HJKRouterViewControllerFactory viewControllerFactory;
@property (nonatomic, copy, readonly) HJKRouterURLOpenHandlerFactory openHandlerFactory;
- (nullable instancetype)initWithPattern:(NSString *)pattern viewControllerFactory:(HJKRouterViewControllerFactory)factory;
- (nullable instancetype)initWithPattern:(NSString *)pattern openHandlerFactory:(HJKRouterURLOpenHandlerFactory)factory;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
