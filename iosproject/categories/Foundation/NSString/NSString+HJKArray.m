//
//  NSString+HJKArray.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSString+HJKArray.h"
#import "NSString+HJKTrims.h"
#import "NSArray+HJKFilter.h"

@implementation NSString (HJKArray)

- (NSArray<NSString *> *)hjk_toArray {
    if (!self.length) {
        return nil;
    }
    
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *stringItem = [self substringWithRange:NSMakeRange(i, 1)];
        [array addObject:stringItem];
    }
    return [array copy];
}

- (NSArray<NSString *> *)hjk_toTrimmedArray {
    return [[self hjk_toArray] hjk_filterWithBlock:^BOOL(NSString *item) {
        return item.hjk_trim.length > 0;
    }];
}
@end
