//
//  UIView+HJKStatus.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HJKStatus)

/// 判断当前的 view 是否属于可视
/// 可视的定义为已存在于 view 层级树里，或者在所处的 UIViewController 的 [viewWillAppear, viewWillDisappear) 生命周期之间
@property(nonatomic, assign, readonly) BOOL hjk_visible;
@end

NS_ASSUME_NONNULL_END
