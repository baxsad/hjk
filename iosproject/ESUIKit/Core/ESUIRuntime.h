//
//  ESUIRuntime.h
//  iosproject
//
//  Created by hlcisy on 2020/9/10.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ESUICategories.h"

/// 判断 class 是否重写了 superClass 的实例方法
/// @param targetClass 要检查的 class，不能为空
/// @param targetSelector 要检查的 selector，不能为空
CG_INLINE BOOL HasOverrideSuperclassInstanceMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) {
        return NO;
    }
    
    Class superclass = class_getSuperclass(targetClass);
    Method methodOfSuperclass = class_getInstanceMethod(superclass, targetSelector);
    if (!methodOfSuperclass) {
        return YES;
    }
    
    return method != methodOfSuperclass;
}

/// 判断 class 是否重写了 superClass 的类方法
/// @param targetClass 要检查的 class，不能为空
/// @param targetSelector 要检查的 selector，不能为空
CG_INLINE BOOL HasOverrideSuperclassClassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getClassMethod(targetClass, targetSelector);
    if (!method) {
        return NO;
    }
    
    Class superclass = class_getSuperclass(targetClass);
    Method methodOfSuperclass = class_getClassMethod(superclass, targetSelector);
    if (!methodOfSuperclass) {
        return YES;
    }
    
    return method != methodOfSuperclass;
}

/// 用 block 重写某个 class 的指定实例方法
/// @param targetClass 要重写的 class
/// @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
/// @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现
CG_INLINE BOOL OverrideInstanceImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    __block IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = HasOverrideSuperclassInstanceMethod(targetClass, targetSelector);
    
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        if (!imp) {
            imp = imp_implementationWithBlock(^(id selfObject){
                NSLog(([NSString stringWithFormat:@"%@", targetClass]), @"%@ 没有初始实现，%@\n%@", NSStringFromSelector(targetSelector), selfObject, [NSThread callStackSymbols]);
            });
        }
        
        return imp;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        const char *typeEncoding = method_getTypeEncoding(originMethod) ?: "v@:";
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), typeEncoding);
    }
    
    return YES;
}

/// 用 block 重写某个 class 的指定类方法
/// @param targetClass 要重写的 class
/// @param targetSelector 要重写的 class 里的类方法，注意如果该方法不存在于 targetClass 里，则什么都不做
/// @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现
CG_INLINE BOOL OverrideClassImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getClassMethod(targetClass, targetSelector);
    __block IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = HasOverrideSuperclassClassMethod(targetClass, targetSelector);
    
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        if (!imp) {
            imp = imp_implementationWithBlock(^(id selfObject){
                NSLog(([NSString stringWithFormat:@"%@", targetClass]), @"%@ 没有初始实现，%@\n%@", NSStringFromSelector(targetSelector), selfObject, [NSThread callStackSymbols]);
            });
        }
        
        return imp;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        const char *typeEncoding = method_getTypeEncoding(originMethod) ?: "v@:";
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), typeEncoding);
    }
    
    return YES;
}
