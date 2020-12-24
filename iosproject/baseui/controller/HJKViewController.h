//
//  HJKViewController.h
//  iosproject
//
//  Created by hlcisy on 2020/8/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJKNavigationBarTransitionDelegate.h"
#import "HJKNavigationBarAppearanceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HJKViewControllerTransitionAppearanceDelegate <HJKNavigationBarTransitionDelegate, HJKNavigationBarAppearanceDelegate>

@end

@interface HJKViewController : UIViewController <HJKViewControllerTransitionAppearanceDelegate>

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

/**
 * 初始化时调用的方法，会在两个 NS_DESIGNATED_INITIALIZER 方法中被调用
 */
- (void)didInitialize;

/**
 * 当前界面支持的横竖屏方向，默认为 SupportedOrientationMask
 */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMask;
@end

@interface HJKViewController (UISubclassingHooks)

/**
 * 负责初始化和设置 Controller 里面的 View，也就是 self.view 的 subview。
 * 目的在于分类代码，所有与 View 初始化相关的代码都写在这里。
 */
- (void)initSubviews NS_REQUIRES_SUPER;

/**
 * 负责设置和更新 NavigationItem，包括title、leftBarButtonItem、rightBarButtonItem。
 * 会在 viewWillAppear 里面自动调用，业务也可在需要的时候自行调用
 * 目的在于分类代码，所有与 NavigationItem 相关的代码都写在这里。
 */
- (void)setupNavigationItems NS_REQUIRES_SUPER;

/**
 * 负责设置和更新 ToolbarItem。在viewWillAppear里面自动调用，允许手动调用。
 * 目的在于分类代码，所有与 ToolbarItem 相关的代码都写在这里。在需要修改 ToolbarItem 的时候都只调用这个接口。
 */
- (void)setupToolbarItems;
@end

NS_ASSUME_NONNULL_END
