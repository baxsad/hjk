//
//  NSString+HJKFormat.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSString+HJKFormat.h"
#import "NSCharacterSet+HJKURLEcode.h"

@implementation NSString (HJKFormat)

- (NSString *)hjk_capitalizedString {
    if (self.length)
        return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]].copy;
    return nil;
}

- (NSString *)hjk_stringByEncodingUserInputQuery {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet hjk_URLUserInputQueryAllowedCharacterSet]];
}

- (NSString *)hjk_removeMagicalChar {
    if (self.length == 0) {
        return self;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u0300-\u036F]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    return modifiedString;
}
@end
