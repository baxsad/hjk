//
//  NSObject+HJKKVC.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSObject+HJKKVC.h"
#import "NSObject+HJKInfo.h"
#import "NSString+HJKFormat.h"

@interface NSThread (HJKKVC)
@property (nonatomic, assign) BOOL hjk_shouldIgnoreUIKVCAccessProhibited;
@end

@implementation NSThread (HJKKVC)

- (void)setHjk_shouldIgnoreUIKVCAccessProhibited:(BOOL)value {
    objc_setAssociatedObject(self, @selector(hjk_shouldIgnoreUIKVCAccessProhibited), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hjk_shouldIgnoreUIKVCAccessProhibited {
    id value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return [value boolValue];
    }
    
    return NO;
}
@end

@implementation NSObject (HJKKVC)

- (nullable id)hjk_valueForKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        if ([self isKindOfClass:[UIView class]]) {
            [NSThread currentThread].hjk_shouldIgnoreUIKVCAccessProhibited = YES;
            id value = [self valueForKey:key];
            [NSThread currentThread].hjk_shouldIgnoreUIKVCAccessProhibited = NO;
            return value;
        }
    }
    return [self valueForKey:key];
}

- (void)hjk_setValue:(nullable id)value forKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        if ([self isKindOfClass:[UIView class]]) {
            [NSThread currentThread].hjk_shouldIgnoreUIKVCAccessProhibited = YES;
            [self setValue:value forKey:key];
            [NSThread currentThread].hjk_shouldIgnoreUIKVCAccessProhibited = NO;
            return;
        }
    }
    
    [self setValue:value forKey:key];
}

- (BOOL)hjk_canGetValueForKey:(NSString *)key {
    NSArray<NSString *> *getters = @[
        [NSString stringWithFormat:@"get%@", key.hjk_capitalizedString],   /// get<Key>
        key,                                                               /// <Key>
        [NSString stringWithFormat:@"is%@", key.hjk_capitalizedString],    /// is<Key>
        [NSString stringWithFormat:@"_%@", key]                            /// _<key>
    ];
    for (NSString *selectorString in getters) {
        if ([self respondsToSelector:NSSelectorFromString(selectorString)]) return YES;
    }
    
    if (![self.class accessInstanceVariablesDirectly]) return NO;
    
    return [self _hjk_hasSpecifiedIvarWithKey:key];
}

- (BOOL)hjk_canSetValueForKey:(NSString *)key {
    NSArray<NSString *> *setter = @[
        [NSString stringWithFormat:@"set%@:", key.hjk_capitalizedString],   /// set<Key>:
        [NSString stringWithFormat:@"_set%@", key.hjk_capitalizedString]    /// _set<Key>
    ];
    for (NSString *selectorString in setter) {
        if ([self respondsToSelector:NSSelectorFromString(selectorString)]) return YES;
    }
    
    if (![self.class accessInstanceVariablesDirectly]) return NO;
    
    return [self _hjk_hasSpecifiedIvarWithKey:key];
}

- (BOOL)_hjk_hasSpecifiedIvarWithKey:(NSString *)key {
    __block BOOL result = NO;
    NSArray<NSString *> *ivars = @[
        [NSString stringWithFormat:@"_%@", key],
        [NSString stringWithFormat:@"_is%@", key.hjk_capitalizedString],
        key,
        [NSString stringWithFormat:@"is%@", key.hjk_capitalizedString]
    ];
    [NSObject hjk_enumrateIvarsOfClass:self.class includingInherited:YES usingBlock:^(Ivar  _Nonnull ivar, NSString * _Nonnull ivarDescription) {
        if (!result) {
            NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
            if ([ivars containsObject:ivarName]) {
                result = YES;
            }
        }
    }];
    return result;
}
@end

@interface NSException (HJKKVC)

@end

@implementation NSException (HJKKVC)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            OverrideInstanceImplementation(object_getClass([NSException class]), @selector(raise:format:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(NSObject *selfObject, NSExceptionName raise, NSString *format, ...) {
                    
                    if (raise == NSGenericException && [format isEqualToString:@"Access to %@'s %@ ivar is prohibited. This is an application bug"]) {
                        if (NSThread.currentThread.hjk_shouldIgnoreUIKVCAccessProhibited) {
                            return;
                        }
                    }
                    
                    id (*originSelectorIMP)(id, SEL, NSExceptionName name, NSString *, ...);
                    originSelectorIMP = (id (*)(id, SEL, NSExceptionName name, NSString *, ...))originalIMPProvider();
                    va_list args;
                    va_start(args, format);
                    NSString *reason =  [[NSString alloc] initWithFormat:format arguments:args];
                    originSelectorIMP(selfObject, originCMD, raise, reason);
                    va_end(args);
                };
            });
        });
    }
}
@end
