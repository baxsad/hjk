//
//  NSString+ESUIArray.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSString+ESUIArray.h"
#import "NSString+ESUITrims.h"
#import "NSArray+ESUIFilter.h"

@implementation NSString (ESUIArray)

- (NSArray<NSString *> *)esui_toArray {
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

- (NSArray<NSString *> *)esui_toTrimmedArray {
    return [[self esui_toArray] esui_filterWithBlock:^BOOL(NSString *item) {
        return item.esui_trim.length > 0;
    }];
}
@end
