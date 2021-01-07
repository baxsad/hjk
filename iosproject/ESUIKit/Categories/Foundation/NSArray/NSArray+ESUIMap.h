//
//  NSArray+ESUIMap.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (ESUIMap)

/// 转换数组元素，将每个 item 都经过 block 转换成一遍 返回转换后的新数组
/// @param block 遍历元素的回调
- (NSArray *)esui_mapWithBlock:(id (NS_NOESCAPE^)(ObjectType item))block;
@end

NS_ASSUME_NONNULL_END
