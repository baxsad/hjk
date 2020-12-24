//
//  UIViewController+HJKRuntime.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HJKRuntime)

/// 判断当前类是否有重写某个指定的 UIViewController 的方法
/// @param selector 要判断的方法
/// @return YES 表示当前类重写了指定的方法，NO 表示没有重写，使用的是 UIViewController 默认的实现
- (BOOL)hjk_hasOverrideUIKitMethod:(_Nonnull SEL)selector;
@end

NS_ASSUME_NONNULL_END
