//
//  HJKHelper.h
//  iosproject
//
//  Created by hlcisy on 2020/9/14.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJKHelper : NSObject

@end

@interface HJKHelper (Device)
+ (nonnull NSString *)deviceModel; // iPhone12,5、iPad6,8
+ (nonnull NSString *)deviceName;  // iPhone 11 Pro Max、iPad Pro (12.9 inch)
+ (BOOL)isIPad;
+ (BOOL)isIPhone;
+ (BOOL)isSimulator;
+ (BOOL)isNotchedScreen;
+ (BOOL)isRegularScreen;
+ (BOOL)is67InchScreen; // iPhone 12 Pro Max
+ (BOOL)is65InchScreen; // iPhone XS Max / 11 Pro Max
+ (BOOL)is61InchScreen; // iPhone XR / 11
+ (BOOL)is60InchScreen; // iPhone 12 / 12 Pro
+ (BOOL)is58InchScreen; // iPhone X / XS / 11 Pro
+ (BOOL)is55InchScreen; // iPhone 8 Plus
+ (BOOL)is54InchScreen; // iPhone 12 mini
+ (BOOL)is47InchScreen; // iPhone 8
+ (BOOL)is40InchScreen; // iPhone 5
+ (BOOL)is35InchScreen; // iPhone 4
+ (CGSize)screenSizeFor67Inch; // 67  Screen {428, 926}
+ (CGSize)screenSizeFor65Inch; // 65  Screen {414, 896}
+ (CGSize)screenSizeFor61Inch; // 61  Screen {414, 896}
+ (CGSize)screenSizeFor60Inch; // 60  Screen {390, 844}
+ (CGSize)screenSizeFor58Inch; // 58  Screen {375, 812}
+ (CGSize)screenSizeFor55Inch; // 55  Screen {414, 736}
+ (CGSize)screenSizeFor54Inch; // 54  Screen {375, 812}
+ (CGSize)screenSizeFor47Inch; // 47  Screen {375, 667}
+ (CGSize)screenSizeFor40Inch; // 40  Screen {320, 568}
+ (CGSize)screenSizeFor35Inch; // 35  Screen {320, 480}
+ (UIEdgeInsets)safeAreaInsetsForDeviceWithNotch;
+ (CGFloat)statusBarHeight;
+ (CGFloat)statusBarHeightConstant;
+ (CGFloat)navigationBarHeight;
+ (CGFloat)navigationContentHeight;
+ (CGFloat)navigationContentHeightConstant;
@end

@interface HJKHelper (ViewController)

/// 获取当前应用里最顶层的可见viewController
/// @warning 注意返回值可能为nil，要做好保护
+ (nullable UIViewController *)visibleViewController;
@end

NS_ASSUME_NONNULL_END
