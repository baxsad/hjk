//
//  NSString+ESUI.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSString+ESUIFormat.h"
#import "NSString+ESUITrims.h"
#import "NSString+ESUIArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ESUI)

/// 比较字符串是否相等
- (BOOL(^)(NSString *aString))esui_isEqualTo;

/// 拼接字符串返回一个拼接后的新字符串
- (NSString *(^)(NSString *aString))esui_stringByAppending;

/// 将字符串切割成数组
- (NSArray *(^)(NSString *separator))esui_componentsSeparatedBy;

/// 查找字符串中特定的字符
- (NSRange (^)(NSString *searchString))esui_rangeOf;
@end

NS_ASSUME_NONNULL_END
