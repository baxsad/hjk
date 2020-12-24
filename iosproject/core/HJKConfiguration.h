//
//  HJKConfiguration.h
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJKConfiguration : NSObject

+ (instancetype _Nullable )sharedInstance;

#pragma mark - Controller

@property (nonatomic, strong, nullable) UIColor  *viewControllerBackgroundColor;

#pragma mark - NavigationBar

@property (nonatomic, assign) UIBarStyle         navBarStyle;
@property (nonatomic, strong, nullable) UIImage  *navBarBackgroundImage;
@property (nonatomic, strong, nullable) UIImage  *navBarShadowImage;
@property (nonatomic, strong, nullable) UIColor  *navBarShadowImageColor;
@property (nonatomic, strong, nullable) UIColor  *navBarBarTintColor;
@property (nonatomic, strong, nullable) UIColor  *navBarTintColor;
@property (nonatomic, strong, nullable) UIColor  *navBarTitleColor;
@property (nonatomic, strong, nullable) UIFont   *navBarTitleFont;
@property (nonatomic, strong, nullable) UIColor  *navBarLargeTitleColor;
@property (nonatomic, strong, nullable) UIFont   *navBarLargeTitleFont;

#pragma mark - TabBar

@property (nonatomic, assign) UIBarStyle         tabBarStyle;
@property (nonatomic, strong, nullable) UIImage  *tabBarBackgroundImage;
@property (nonatomic, strong, nullable) UIColor  *tabBarShadowImageColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarBarTintColor;
@property (nonatomic, strong, nullable) UIFont   *tabBarItemTitleFont;
@property (nonatomic, strong, nullable) UIColor  *tabBarItemTitleColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarItemTitleColorSelected;
@property (nonatomic, strong, nullable) UIColor  *tabBarItemImageColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarItemImageColorSelected;

#pragma mark - Other

@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMask;
@property (nonatomic, assign) BOOL               statusbarStyleLightInitially;
@end

@interface UIViewController (HJKConfiguration)
- (NSArray <UIViewController *>*)hjk_existingViewControllersOfClass:(Class)class;
@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000

UIKIT_EXTERN API_AVAILABLE(ios(13.0), tvos(13.0)) @interface UITabBarAppearance (HJKConfiguration)

/**
 * 同时设置 stackedLayoutAppearance、inlineLayoutAppearance、compactInlineLayoutAppearance 三个状态下的 itemAppearance
 */
- (void)hjk_applyItemAppearanceWithBlock:(void (^)(UITabBarItemAppearance *itemAppearance))block;
@end

#endif

@interface UITabBarItem (HJKConfiguration)
- (void)hjk_updateTintColorForiOS12AndEarlier:(nullable UIColor *)tintColor;
@end

NS_ASSUME_NONNULL_END
