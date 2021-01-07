//
//  ESCPURLDefinition.h
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPRouterCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCPURLDefinition : NSObject
@property (nonatomic, strong, readonly) NSString *scheme;
@property (nonatomic, strong, readonly) NSString *pattern;
@property (nonatomic, strong, readonly) NSArray<NSString*> *patternPathComponents;
@property (nonatomic, strong, readonly) NSString *match;
@property (nonatomic, assign, readonly) BOOL isMatchOption;
@property (nonatomic, copy, readonly) ESCPRouterViewControllerFactory viewControllerFactory;
@property (nonatomic, copy, readonly) ESCPRouterURLOpenHandlerFactory openHandlerFactory;
- (nullable instancetype)initWithPattern:(NSString *)pattern viewControllerFactory:(ESCPRouterViewControllerFactory)factory;
- (nullable instancetype)initWithPattern:(NSString *)pattern openHandlerFactory:(ESCPRouterURLOpenHandlerFactory)factory;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
