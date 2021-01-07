//
//  UIView+ESUIController.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ESUIController)

/// 当前的 view 是否是某个 UIViewController.view
@property (nonatomic, assign) BOOL esui_isControllerRootView;

/// 获取当前 view 所在的 UIViewController，会递归查找 superview，因此注意使用场景不要有过于频繁的调用
@property (nullable, nonatomic, weak, readonly) __kindof UIViewController *esui_viewController;
@end

NS_ASSUME_NONNULL_END
