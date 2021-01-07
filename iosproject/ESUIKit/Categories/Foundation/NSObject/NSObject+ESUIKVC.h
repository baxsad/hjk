//
//  NSObject+ESUIKVC.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ESUIKVC)

/// iOS 13 下系统禁止通过 KVC 访问私有 API，因此提供这种方式在遇到 access prohibited 的异常时可以取代 valueForKey: 使用。
/// @param key ivar 属性名，支持下划线或不带下划线
- (nullable id)esui_valueForKey:(NSString *)key;

/// iOS 13 下系统禁止通过 KVC 访问私有 API，因此提供这种方式在遇到 access prohibited 的异常时可以取代 setValue:forKey: 使用。
/// @param value ivar 设置的值
/// @param key ivar 属性名，支持下划线或不带下划线
- (void)esui_setValue:(nullable id)value forKey:(NSString *)key;

/// 检查给定的 key 是否可以用于当前对象的 valueForKey: 调用。
/// @param key key
/// @note 这是针对 valueForKey: 内部查找 key 的逻辑的精简版，去掉了一些不常用的，如果按精简版查找不到，会返回 NO（但按完整版可能是能查找到的），避免抛出异常。文档描述的查找方法完整版请查看 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/SearchImplementation.html
- (BOOL)esui_canGetValueForKey:(NSString *)key;

/// 检查给定的 key 是否可以用于当前对象的 setValue:forKey: 调用。
/// @param key key
/// @note 对于 setter 而言这就是完整版的检查流程，可核对文档 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/SearchImplementation.html
- (BOOL)esui_canSetValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
