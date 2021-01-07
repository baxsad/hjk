//
//  UIViewController+ESUIController.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ESUIController)

/// 获取和自身处于同一个UINavigationController里的上一个UIViewController
@property (nullable, nonatomic, weak, readonly) UIViewController *esui_previousViewController;

/// 获取当前controller里的最高层可见viewController（可见的意思是还会判断self.view.window是否存在）
/// @return 当前controller里的最高层可见viewController
- (nullable UIViewController *)esui_visibleViewControllerIfExist;

/// 当前 viewController 是否是被以 present 的方式显示的，是则返回 YES，否则返回 NO
/// @warning 对于被放在 UINavigationController 里显示的 UIViewController，如果 self 是 self.navigationController 的第一个 viewController，则如果 self.navigationController 是被 present 起来的，那么 self.esui_isPresented = self.navigationController.esui_isPresented = YES。利用这个特性，可以方便地给 navigationController 的第一个界面的左上角添加关闭按钮。
- (BOOL)esui_isPresented;

/// 是否应该响应一些UI相关的通知，例如 UIKeyboardNotification、UIMenuControllerNotification等，因为有可能当前界面已经被切走了（push到其他界面），但仍可能收到通知，所以在响应通知之前都应该做一下这个判断
- (BOOL)esui_isViewLoadedAndVisible;
@end

NS_ASSUME_NONNULL_END
