//
//  NSArray+ESUIFilter.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (ESUIFilter)

/// 过滤数组元素，将 block 返回 YES 的 item 重新组装成一个数组返回
/// @param block 遍历元素的回调
- (NSArray<ObjectType> *)esui_filterWithBlock:(BOOL (NS_NOESCAPE^)(ObjectType item))block;
@end

NS_ASSUME_NONNULL_END
