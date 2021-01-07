//
//  ESUIHelper.h
//  iosproject
//
//  Created by hlcisy on 2020/9/14.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESUIHelper : NSObject

@end

@interface ESUIHelper (Device)

/// 如 iPhone12,5、iPad6,8
@property (class, nonatomic, readonly) NSString *deviceModel;

/// 如 iPhone 11 Pro Max、iPad Pro (12.9 inch)，如果是模拟器，会在后面带上“ Simulator”字样。
@property (class, nonatomic, readonly) NSString *deviceName;

/// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
@property (class, nonatomic, readonly) double iosVersion;

/// 数字形式的操作系统版本号，可直接用于大小比较；如 110205 代表 11.2.5 版本；根据 iOS 规范，版本号最多可能有3位
@property (class, nonatomic, readonly) NSInteger numberiOSVersion;

/// 是否是 iPad 设备
@property (class, nonatomic, readonly) BOOL isIPad;

/// 是否是 isIPhone 设备
@property (class, nonatomic, readonly) BOOL isIPhone;

/// 是否是模拟器设备
@property (class, nonatomic, readonly) BOOL isSimulator;

/// 系统设置里是否开启了“放大显示-试图-放大”
@property (class, nonatomic, readonly) BOOL isZoomedMode;

/// 是否横竖屏（用户界面横屏了才会返回YES）
@property (class, nonatomic, readonly) BOOL isLandscape;

/// 是否横竖屏（无论支不支持横屏，只要设备横屏了，就会返回YES）
@property (class, nonatomic, readonly) BOOL isDeviceLandscape;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
@property (class, nonatomic, readonly) BOOL isNotchedScreen;

/// 将屏幕分为普通和紧凑两种，这个方法用于判断普通屏幕（也即大屏幕）
/// 只要是通常意义上的“大屏幕手机”（例如 Plus 系列）都会被视为 Regular Screen
@property (class, nonatomic, readonly) BOOL isRegularScreen;

/// iPhone 12 Pro Max
@property (class, nonatomic, readonly) BOOL is67InchScreen;

/// iPhone XS Max / 11 Pro Max
@property (class, nonatomic, readonly) BOOL is65InchScreen;

/// iPhone 12 / 12 Pro
@property (class, nonatomic, readonly) BOOL is61InchScreenAndiPhone12;

/// iPhone XR / 11
@property (class, nonatomic, readonly) BOOL is61InchScreen;

/// iPhone X / XS / 11Pro
@property (class, nonatomic, readonly) BOOL is58InchScreen;

/// iPhone 8 Plus
@property (class, nonatomic, readonly) BOOL is55InchScreen;

/// iPhone 12 mini
@property (class, nonatomic, readonly) BOOL is54InchScreen;

/// iPhone 8
@property (class, nonatomic, readonly) BOOL is47InchScreen;

/// iPhone 5
@property (class, nonatomic, readonly) BOOL is40InchScreen;

/// iPhone 4
@property (class, nonatomic, readonly) BOOL is35InchScreen;

/// Screen {428, 926}
@property (class, nonatomic, readonly) CGSize screenSizeFor67Inch;

/// Screen {414, 896}
@property (class, nonatomic, readonly) CGSize screenSizeFor65Inch;

/// Screen {390, 844}
@property (class, nonatomic, readonly) CGSize screenSizeFor61InchAndiPhone12;

/// Screen {414, 896}
@property (class, nonatomic, readonly) CGSize screenSizeFor61Inch;

/// Screen {375, 812}
@property (class, nonatomic, readonly) CGSize screenSizeFor58Inch;

/// Screen {414, 736}
@property (class, nonatomic, readonly) CGSize screenSizeFor55Inch;

/// Screen {375, 812}
@property (class, nonatomic, readonly) CGSize screenSizeFor54Inch;

/// Screen {375, 667}
@property (class, nonatomic, readonly) CGSize screenSizeFor47Inch;

/// Screen {320, 568}
@property (class, nonatomic, readonly) CGSize screenSizeFor40Inch;

/// Screen {320, 480}
@property (class, nonatomic, readonly) CGSize screenSizeFor35Inch;

/// 用于获取 isNotchedScreen 设备的 insets
@property (class, nonatomic, readonly) UIEdgeInsets safeAreaInsetsForDeviceWithNotch;

/// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算，iOS 13 起，来电等情况下状态栏高度不会改变)
@property (class, nonatomic, readonly) CGFloat statusBarHeight;

/// 状态栏高度(如果状态栏不可见，也会返回一个普通状态下可见的高度)
@property (class, nonatomic, readonly) CGFloat statusBarHeightConstant;

/// 导航栏的静态高度(主要区分 iPad 和横竖屏)
@property (class, nonatomic, readonly) CGFloat navigationBarHeight;

/// 代表(导航栏+状态栏)，这里用于获取其高度（状态栏高度不固定）
@property (class, nonatomic, readonly) CGFloat navigationContentHeight;

/// 代表(导航栏+状态栏)，这里用于获取它的静态常量值
@property (class, nonatomic, readonly) CGFloat navigationContentHeightConstant;

/// TabBar的高度（如果是刘海屏会加上 Home Indicator 的高度）
@property (class, nonatomic, readonly) CGFloat tabBarHeight;
@end

@interface ESUIHelper (ViewController)

/// 获取当前应用里最顶层的可见viewController
/// @warning 注意返回值可能为nil，要做好保护
+ (nullable UIViewController *)visibleViewController;
@end

NS_ASSUME_NONNULL_END
