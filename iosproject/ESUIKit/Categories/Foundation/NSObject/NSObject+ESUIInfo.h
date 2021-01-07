//
//  NSObject+ESUIInfo.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ESUIInfo)

/// 使用 block 遍历指定 class 的所有成员变量（也即 _xxx 那种），不包含 property 对应的 _property 成员变量，也不包含 superclasses 里定义的变量
/// @param block 用于遍历的 block
- (void)esui_enumrateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block;

/// 使用 block 遍历指定 class 的所有成员变量（也即 _xxx 那种），不包含 property 对应的 _property 成员变量
/// @param aClass 指定的 class
/// @param includingInherited 是否要包含由继承链带过来的 ivars
/// @param block 用于遍历的 block
+ (void)esui_enumrateIvarsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block;

/// 使用 block 遍历指定 class 的所有属性，不包含 superclasses 里定义的 property
/// @param block 用于遍历的 block，如果要获取 property 的信息。
- (void)esui_enumratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block;

/// 使用 block 遍历指定 class 的所有属性
/// @param aClass 指定的 class
/// @param includingInherited 是否要包含由继承链带过来的 property
/// @param block 用于遍历的 block，如果要获取 property 的信息。
+ (void)esui_enumratePropertiesOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(objc_property_t property, NSString *propertyName))block;

/// 使用 block 遍历当前实例的所有方法，不包含 superclasses 里定义的 method
/// @param block 用于遍历的 block
- (void)esui_enumrateInstanceMethodsUsingBlock:(void (^)(Method method, SEL selector))block;

/// 使用 block 遍历指定的某个类的实例方法
/// @param aClass 指定的 class
/// @param includingInherited 是否要包含由继承链带过来的 method
/// @param block 用于遍历的 block
+ (void)esui_enumrateInstanceMethodsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Method method, SEL selector))block;

/// 遍历某个 protocol 里的所有方法
/// @param protocol 要遍历的 protocol，例如 \@protocol(xxx)
/// @param block 遍历过程中调用的 block
+ (void)esui_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL selector))block;
@end

NS_ASSUME_NONNULL_END
