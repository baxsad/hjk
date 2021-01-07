//
//  NSString+ESUI.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSString+ESUI.h"

@implementation NSString (ESUI)

- (BOOL(^)(NSString *aString))esui_isEqualTo {
    return ^BOOL(NSString *aString) {
        return [self isEqualToString:aString];
    };
}

- (NSString *(^)(NSString *aString))esui_stringByAppending {
    return ^NSString *(NSString *aString) {
        return [self stringByAppendingString:aString];
    };
}

- (NSArray *(^)(NSString *separator))esui_componentsSeparatedBy {
    return ^NSArray *(NSString *separator) {
        return [self componentsSeparatedByString:separator];
    };
}

- (NSRange (^)(NSString *searchString))esui_rangeOf {
    return ^NSRange(NSString *searchString) {
        return [self rangeOfString:searchString];
    };
}
@end
