//
//  NSString+HJKTrims.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSString+HJKTrims.h"

@implementation NSString (HJKTrims)

- (NSString *)hjk_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)hjk_trimAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)hjk_trimLineBreakCharacter {
    return [self stringByReplacingOccurrencesOfString:@"[\r\n]" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}
@end
