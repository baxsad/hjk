//
//  SIMMutableListeners.m
//  iosproject
//
//  Created by hlcisy on 2020/9/11.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "SIMMutableListeners.h"

@interface NSPointerArray (WS)
- (NSUInteger)sim_indexOfPointer:(nullable void *)pointer;
- (BOOL)sim_containsPointer:(void *)pointer;
@end

@implementation NSPointerArray (WS)

- (NSUInteger)sim_indexOfPointer:(nullable void *)pointer {
    if (!pointer) {
        return NSNotFound;
    }
    
    NSPointerArray *array = [self copy];
    for (NSUInteger i = 0; i < array.count; i++) {
        if ([array pointerAtIndex:i] == ((void *)pointer)) {
            return i;
        }
    }
    return NSNotFound;
}

- (BOOL)sim_containsPointer:(void *)pointer {
    if (!pointer) {
        return NO;
    }
    if ([self sim_indexOfPointer:pointer] != NSNotFound) {
        return YES;
    }
    return NO;
}
@end

@interface SIMMutableListeners ()
@property (nonatomic, strong, readwrite) NSPointerArray *listeners;
@end

@implementation SIMMutableListeners

+ (instancetype)weakListeners {
    SIMMutableListeners *listeners = [[SIMMutableListeners alloc] init];
    listeners.listeners = [NSPointerArray weakObjectsPointerArray];
    return listeners;
}

+ (instancetype)strongListeners {
    SIMMutableListeners *listeners = [[SIMMutableListeners alloc] init];
    listeners.listeners = [NSPointerArray strongObjectsPointerArray];
    return listeners;
}

- (void)addListener:(id)listener {
    if (![self containsListener:listener] && listener != self) {
        [self.listeners addPointer:(__bridge void *)listener];
    }
}

- (BOOL)removeListener:(id)listener {
    NSUInteger index = [self.listeners sim_indexOfPointer:(__bridge void *)listener];
    if (index != NSNotFound) {
        [self.listeners removePointerAtIndex:index];
        return YES;
    }
    return NO;
}

- (void)removeAllListeners {
    for (NSInteger i = self.listeners.count - 1; i >= 0; i--) {
        [self.listeners removePointerAtIndex:i];
    }
}

- (BOOL)containsListener:(id)listener {
    return [self.listeners sim_containsPointer:(__bridge void *)listener];
}
@end
