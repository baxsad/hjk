//
//  NSObject+HJKInfo.m
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "NSObject+HJKInfo.h"
#import "NSString+HJKTrims.h"
#import <objc/message.h>

@implementation NSObject (HJKInfo)

- (void)hjk_enumrateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block {
    [self hjk_enumrateIvarsIncludingInherited:NO usingBlock:block];
}

- (void)hjk_enumrateIvarsIncludingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block {
    NSMutableArray<NSString *> *ivarDescriptions = [NSMutableArray new];
    NSString *ivarList = self.hjk_ivarList;
    NSError *error;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"in %@:(.*?)((?=in \\w+:)|$)", NSStringFromClass(self.class)] options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (!error) {
        NSArray<NSTextCheckingResult *> *result = [reg matchesInString:ivarList options:NSMatchingReportCompletion range:NSMakeRange(0, ivarList.length)];
        [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ivars = [ivarList substringWithRange:[obj rangeAtIndex:1]];
            [ivars enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
                if (![line hasPrefix:@"\t\t"]) {
                    line = line.hjk_trim;
                    if (line.length > 2) {
                        NSRange range = [line rangeOfString:@":"];
                        if (range.location != NSNotFound) {
                            line = [line substringToIndex:range.location];
                        }
                        NSUInteger typeStart = [line rangeOfString:@" ("].location;
                        line = [NSString stringWithFormat:@"%@ %@", [line substringWithRange:NSMakeRange(typeStart + 2, line.length - 1 - (typeStart + 2))], [line substringToIndex:typeStart]];
                        [ivarDescriptions addObject:line];
                    }
                }
            }];
        }];
    }
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
        for (NSString *desc in ivarDescriptions) {
            if ([desc hasSuffix:ivarName]) {
                block(ivar, desc);
                break;
            }
        }
    }
    free(ivars);
    
    if (includingInherited) {
        Class superclass = self.superclass;
        if (superclass) {
            [NSObject hjk_enumrateIvarsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)hjk_enumrateIvarsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar, NSString *))block {
    if (!block) return;
    NSObject *obj = nil;
    if ([aClass isSubclassOfClass:[UICollectionView class]]) {
        obj = [[aClass alloc] initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
    } else if ([aClass isSubclassOfClass:[UIApplication class]]) {
        obj = UIApplication.sharedApplication;
    } else {
        obj = [aClass new];
    }
    [obj hjk_enumrateIvarsIncludingInherited:includingInherited usingBlock:block];
}

- (void)hjk_enumratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block {
    [NSObject hjk_enumratePropertiesOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)hjk_enumratePropertiesOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(objc_property_t, NSString *))block {
    if (!block) return;
    
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; i++) {
        objc_property_t property = properties[i];
        if (block) block(property, [NSString stringWithFormat:@"%s", property_getName(property)]);
    }
    
    free(properties);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject hjk_enumratePropertiesOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

- (void)hjk_enumrateInstanceMethodsUsingBlock:(void (^)(Method, SEL))block {
    [NSObject hjk_enumrateInstanceMethodsOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)hjk_enumrateInstanceMethodsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Method, SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(method, selector);
    }
    
    free(methods);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject hjk_enumrateInstanceMethodsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)hjk_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}

#pragma mark - Provate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (NSString *)hjk_methodList {
    return [self performSelector:NSSelectorFromString(@"_methodDescription")];
}

- (NSString *)hjk_shortMethodList {
    return [self performSelector:NSSelectorFromString(@"_shortMethodDescription")];
}

- (NSString *)hjk_ivarList {
    return [self performSelector:NSSelectorFromString(@"_ivarDescription")];
}

#pragma clang diagnostic pop
@end
