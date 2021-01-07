//
//  NSArray+ESUIMap.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSArray+ESUIMap.h"

@implementation NSArray (ESUIMap)

- (NSArray *)esui_mapWithBlock:(id (NS_NOESCAPE^)(id item))block {
    if (!block) {
        return self;
    }

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [result addObject:block(self[i])];
    }
    return [result copy];
}
@end
