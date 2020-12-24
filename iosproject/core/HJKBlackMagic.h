//
//  HJKBlackMagic.h
//  iosproject
//
//  Created by hlcisy on 2020/9/10.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

CG_INLINE BOOL
HasOverrideSuperclassInstanceMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

CG_INLINE BOOL
HasOverrideSuperclassClassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getClassMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getClassMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

CG_INLINE BOOL
OverrideInstanceImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = HasOverrideSuperclassInstanceMethod(targetClass, targetSelector);
    
    /**
     以 block 的方式达到实时获取初始方法的 IMP 的目的，从而避免先 swizzle 了 subclass 的方法，再 swizzle superclass 的方法，会发现前者的方法调用不会触发后者 swizzle 后的版本的 bug。
     */
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        if (hasOverride) {
            return imp;
        }
        Class superclass = class_getSuperclass(targetClass);
        IMP result = class_getMethodImplementation(superclass, targetSelector);
        return result;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), method_getTypeEncoding(originMethod));
    }
    
    return YES;
}

CG_INLINE BOOL
OverrideClassImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getClassMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = HasOverrideSuperclassClassMethod(targetClass, targetSelector);
    
    /**
     以 block 的方式达到实时获取初始方法的 IMP 的目的，从而避免先 swizzle 了 subclass 的方法，再 swizzle superclass 的方法，会发现前者的方法调用不会触发后者 swizzle 后的版本的 bug。
     */
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        if (hasOverride) {
            return imp;
        }
        Class superclass = class_getSuperclass(targetClass);
        IMP result = class_getMethodImplementation(superclass, targetSelector);
        return result;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), method_getTypeEncoding(originMethod));
    }
    
    return YES;
}
