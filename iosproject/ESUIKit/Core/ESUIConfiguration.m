//
//  ESUIConfiguration.m
//  iosproject
//
//  Created by hlcisy on 2020/9/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESUIConfiguration.h"
#import "ESUICategories.h"
#import <objc/runtime.h>

@interface ESUIConfiguration ()
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
@property (nonatomic, strong) UITabBarAppearance *tabBarAppearance API_AVAILABLE(ios(13.0));
@property (nonatomic, strong) UINavigationBarAppearance *navigationBarAppearance API_AVAILABLE(ios(13.0));
#endif
@end

@implementation ESUIConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static ESUIConfiguration *sharedInstance;
    dispatch_once(&pred, ^{
        sharedInstance = [[ESUIConfiguration alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}

- (void)initDefaultConfiguration {
    self.supportedOrientationMask = UIInterfaceOrientationMaskAll;
}

#pragma mark - getter/setter

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000

- (UITabBarAppearance *)tabBarAppearance {
    if (!_tabBarAppearance) {
        _tabBarAppearance = [[UITabBarAppearance alloc] init];
        [_tabBarAppearance configureWithDefaultBackground];
    }
    return _tabBarAppearance;
}

- (void)updateTabBarAppearance {
    if (@available(iOS 13.0, *)) {
        UITabBar.appearance.standardAppearance = self.tabBarAppearance;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.standardAppearance = self.tabBarAppearance;
        }];
    }
}

- (UINavigationBarAppearance *)navigationBarAppearance {
    if (!_navigationBarAppearance) {
        _navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
    }
    return _navigationBarAppearance;
}

- (void)updateNavigationBarAppearance {
    if (@available(iOS 13.0, *)) {
        UINavigationBar.appearance.standardAppearance = self.navigationBarAppearance;
        [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
            navigationController.navigationBar.standardAppearance = self.navigationBarAppearance;
        }];
    }
}

#endif

- (void)setNavBarStyle:(UIBarStyle)navBarStyle {
    _navBarStyle = navBarStyle;
    [UINavigationBar appearance].barStyle = navBarStyle;
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.barStyle = navBarStyle;
    }];
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage {
    _navBarBackgroundImage = navBarBackgroundImage;
    [[UINavigationBar appearance] setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        [navigationController.navigationBar setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }];
}

- (void)setNavBarShadowImage:(UIImage *)navBarShadowImage {
    _navBarShadowImage = navBarShadowImage;
    [self configureNavBarShadowImage];
}

- (void)setNavBarShadowImageColor:(UIColor *)navBarShadowImageColor {
    _navBarShadowImageColor = navBarShadowImageColor;
    [self configureNavBarShadowImage];
}

- (void)configureNavBarShadowImage {
    UIImage *shadowImage = self.navBarShadowImage;
    if (shadowImage || self.navBarShadowImageColor) {
        if (shadowImage) {
            if (self.navBarShadowImageColor && shadowImage.renderingMode != UIImageRenderingModeAlwaysOriginal) {
                shadowImage = [shadowImage esui_imageWithTintColor:self.navBarShadowImageColor];
            }
        } else {
            UIColor *imageColor = self.navBarShadowImageColor;
            CGSize imageSize = CGSizeMake(4, 1.0/UIScreen.mainScreen.scale);
            shadowImage = [UIImage esui_imageWithColor:imageColor size:imageSize cornerRadius:0];
        }
        
        _navBarShadowImage = shadowImage;
    }
    
    [UINavigationBar appearance].shadowImage = shadowImage;
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.shadowImage = shadowImage;
    }];
}

- (void)setNavBarBarTintColor:(UIColor *)navBarBarTintColor {
    _navBarBarTintColor = navBarBarTintColor;
    [UINavigationBar appearance].barTintColor = navBarBarTintColor;
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.barTintColor = navBarBarTintColor;
    }];
}

- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    _navBarTintColor = navBarTintColor;
    
    /**
     * tintColor 并没有声明 UI_APPEARANCE_SELECTOR，但是 appearance 方式实测是生效的
     */
    [UINavigationBar appearance].tintColor = navBarTintColor;
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.tintColor = navBarTintColor;
    }];
}

- (void)setNavBarTitleColor:(UIColor *)navBarTitleColor {
    _navBarTitleColor = navBarTitleColor;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)setNavBarTitleFont:(UIFont *)navBarTitleFont {
    _navBarTitleFont = navBarTitleFont;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)updateNavigationBarTitleAttributesIfNeeded {
    NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes = [UINavigationBar appearance].titleTextAttributes.mutableCopy;
    if (!titleTextAttributes) {
        titleTextAttributes = [[NSMutableDictionary alloc] init];
    }
    if (self.navBarTitleFont) {
        titleTextAttributes[NSFontAttributeName] = self.navBarTitleFont;
    }
    if (self.navBarTitleColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = self.navBarTitleColor;
    }
    
    [UINavigationBar appearance].titleTextAttributes = titleTextAttributes;
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    }];
}

- (void)setNavBarLargeTitleColor:(UIColor *)navBarLargeTitleColor {
    _navBarLargeTitleColor = navBarLargeTitleColor;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)setNavBarLargeTitleFont:(UIFont *)navBarLargeTitleFont {
    _navBarLargeTitleFont = navBarLargeTitleFont;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)updateNavigationBarLargeTitleTextAttributesIfNeeded {
    if (@available(iOS 11, *)) {
        NSMutableDictionary<NSString *, id> *largeTitleTextAttributes = [[NSMutableDictionary alloc] init];
        if (self.navBarLargeTitleFont) {
            largeTitleTextAttributes[NSFontAttributeName] = self.navBarLargeTitleFont;
        }
        if (self.navBarLargeTitleColor) {
            largeTitleTextAttributes[NSForegroundColorAttributeName] = self.navBarLargeTitleColor;
        }
        
        [UINavigationBar appearance].largeTitleTextAttributes = largeTitleTextAttributes;
        [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
            navigationController.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes;
        }];
    }
}

- (void)setTabBarStyle:(UIBarStyle)tabBarStyle {
    _tabBarStyle = tabBarStyle;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:tabBarStyle == UIBarStyleDefault ? UIBlurEffectStyleSystemChromeMaterialLight : UIBlurEffectStyleSystemChromeMaterialDark];
        [self updateTabBarAppearance];
    } else {
#endif
        [UITabBar appearance].barStyle = tabBarStyle;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.barStyle = tabBarStyle;
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarBackgroundImage:(UIImage *)tabBarBackgroundImage {
    _tabBarBackgroundImage = tabBarBackgroundImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.backgroundImage = tabBarBackgroundImage;
        [self updateTabBarAppearance];
    } else {
#endif
        [UITabBar appearance].backgroundImage = tabBarBackgroundImage;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.backgroundImage = tabBarBackgroundImage;
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarShadowImageColor:(UIColor *)tabBarShadowImageColor {
    _tabBarShadowImageColor = tabBarShadowImageColor;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.shadowColor = tabBarShadowImageColor;
        [self updateTabBarAppearance];
    } else {
#endif
        UIColor *imageColor = tabBarShadowImageColor;
        CGSize imageSize = CGSizeMake(1, 1.0/UIScreen.mainScreen.scale);
        UIImage *shadowImage = [UIImage esui_imageWithColor:imageColor size:imageSize cornerRadius:0];
        [[UITabBar appearance] setShadowImage:shadowImage];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.shadowImage = shadowImage;
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarBarTintColor:(UIColor *)tabBarBarTintColor {
    _tabBarBarTintColor = tabBarBarTintColor;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.backgroundColor = tabBarBarTintColor;
        [self updateTabBarAppearance];
    } else {
#endif
        [UITabBar appearance].barTintColor = tabBarBarTintColor;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.barTintColor = tabBarBarTintColor;
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarItemTitleFont:(UIFont *)tabBarItemTitleFont {
    _tabBarItemTitleFont = tabBarItemTitleFont;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance esui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
            attributes[NSFontAttributeName] = tabBarItemTitleFont;
            itemAppearance.normal.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        if (tabBarItemTitleFont) {
            textAttributes[NSFontAttributeName] = tabBarItemTitleFont;
        }
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            }];
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarItemTitleColor:(UIColor *)tabBarItemTitleColor {
    _tabBarItemTitleColor = tabBarItemTitleColor;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance esui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
            attributes[NSForegroundColorAttributeName] = tabBarItemTitleColor;
            itemAppearance.normal.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSForegroundColorAttributeName] = tabBarItemTitleColor;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            }];
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarItemTitleColorSelected:(UIColor *)tabBarItemTitleColorSelected {
    _tabBarItemTitleColorSelected = tabBarItemTitleColorSelected;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance esui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.selected.titleTextAttributes.mutableCopy;
            attributes[NSForegroundColorAttributeName] = tabBarItemTitleColorSelected;
            itemAppearance.selected.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected]];
        textAttributes[NSForegroundColorAttributeName] = tabBarItemTitleColorSelected;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
            }];
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarItemImageColor:(UIColor *)tabBarItemImageColor {
    _tabBarItemImageColor = tabBarItemImageColor;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance esui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            itemAppearance.normal.iconColor = tabBarItemImageColor;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
    [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
        [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [item esui_updateTintColorForiOS12AndEarlier:tabBarItemImageColor];
        }];
    }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setTabBarItemImageColorSelected:(UIColor *)tabBarItemImageColorSelected {
    _tabBarItemImageColorSelected = tabBarItemImageColorSelected;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance esui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            itemAppearance.selected.iconColor = tabBarItemImageColorSelected;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        /**
         * iOS 12 及以下使用 tintColor 实现，tintColor 并没有声明 UI_APPEARANCE_SELECTOR，但是 appearance 方式实测是生效的
         */
        [UITabBar appearance].tintColor = tabBarItemImageColorSelected;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.tintColor = tabBarItemImageColorSelected;
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    }
#endif
}

- (void)setStatusbarStyleLightInitially:(BOOL)statusbarStyleLightInitially {
    _statusbarStyleLightInitially = statusbarStyleLightInitially;
    [[ESUIHelper visibleViewController] setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Appearance Updating Views

- (NSArray <UITabBarController *>*)appearanceUpdatingTabBarControllers {
    return (NSArray <UITabBarController *>*)[self appearanceUpdatingViewControllersOfClass:UITabBarController.class];
}

- (NSArray <UINavigationController *>*)appearanceUpdatingNavigationControllers {
    return (NSArray <UINavigationController *>*)[self appearanceUpdatingViewControllersOfClass:UINavigationController.class];
}

- (NSArray <UIViewController *>*)appearanceUpdatingViewControllersOfClass:(Class)class {
    NSMutableArray *viewControllers = [NSMutableArray array];
    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (window.rootViewController) {
            [viewControllers addObjectsFromArray:[window.rootViewController esui_existingViewControllersOfClass:class]];
        }
    }];
    return viewControllers;
}
@end

@implementation UIViewController (ESUIConfiguration)

- (NSArray <UIViewController *>*)esui_existingViewControllersOfClass:(Class)class {
    NSMutableSet *viewControllers = [NSMutableSet set];
    if (self.presentedViewController) {
        [viewControllers addObjectsFromArray:[self.presentedViewController esui_existingViewControllersOfClass:class]];
    }
    if ([self isKindOfClass:UINavigationController.class]) {
        UIViewController *visibleViewController = ((UINavigationController *)self).visibleViewController;
        [viewControllers addObjectsFromArray:[visibleViewController esui_existingViewControllersOfClass:class]];
    }
    if ([self isKindOfClass:UITabBarController.class]) {
        UIViewController *selectedViewController = ((UITabBarController *)self).selectedViewController;
        [viewControllers addObjectsFromArray:[selectedViewController esui_existingViewControllersOfClass:class]];
    }
    if ([self isKindOfClass:class]) {
        [viewControllers addObject:self];
    }
    
    return viewControllers.allObjects;
}
@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000

@implementation UITabBarAppearance (ESUIConfiguration)

- (void)esui_applyItemAppearanceWithBlock:(void (^)(UITabBarItemAppearance * _Nonnull))block {
    block(self.stackedLayoutAppearance);
    block(self.inlineLayoutAppearance);
    block(self.compactInlineLayoutAppearance);
}
@end

#endif

const NSInteger ESUIImageOriginalRenderingModeDefault = -1000;

@interface UIImage (ESUIConfiguration)
@property (nonatomic, assign) UIImageRenderingMode esuiconf_originalRenderingMode;
@property (nonatomic, assign) BOOL esuiconf_hasSetOriginalRenderingMode;
@end

@implementation UITabBarItem (ESUIConfiguration)

/**
 * iOS 12 及以下的 UITabBarItem.image 有个问题是，如果不强制指定 original，系统总是会以 template 的方式渲染未选中时的图片，并且颜色也是系统默认的灰色，无法改变。为了让未选中时的图片颜色能跟随配置表变化，这里对 renderingMode 为非 Original 的图片会强制转换成配置表的颜色，并将 renderMode 修改为 AlwaysOriginal 以保证图片颜色不会被系统覆盖
 */
- (void)esui_updateTintColorForiOS12AndEarlier:(UIColor *)tintColor {
    if (@available(iOS 13.0, *)) return;
    if (!tintColor) return;
    
    UIImage *(^tintImageBlock)(UITabBarItem *item, UIImage *image, UIColor *configColor) = ^UIImage *(UITabBarItem *item, UIImage *image, UIColor *configColor) {
        
        if (!image || !configColor) return nil;
        
        UIImageRenderingMode renderingMode = image.renderingMode;
        UIImageRenderingMode originalRenderingMode = image.esuiconf_originalRenderingMode;
        
        if (originalRenderingMode == ESUIImageOriginalRenderingModeDefault) {
            if (renderingMode != UIImageRenderingModeAlwaysOriginal) {
                image = [[image esui_imageWithTintColor:configColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                image.esuiconf_originalRenderingMode = renderingMode;
                return image;
            }
        } else if (originalRenderingMode != UIImageRenderingModeAlwaysOriginal && renderingMode == UIImageRenderingModeAlwaysOriginal) {
            image = [[image esui_imageWithTintColor:configColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            image.esuiconf_originalRenderingMode = originalRenderingMode;
            return image;
        }
        return nil;
    };
    
    UIImage *normalImage = tintImageBlock(self, self.image, [ESUIConfiguration sharedInstance].tabBarItemImageColor);
    if (normalImage) {
        self.image = normalImage;
    }
    UIImage *selectedImage = self.selectedImage;
    
    /**
     * 系统的 UITabBarItem 只设置 image 不设置 selectedImage 时，访问 selectedImage 会直接返回 self.image 的值，但如果把相同的一个 image 对象同时赋值给 image 和 selectedImage，则两者的指针地址不同，因为 selectedImage setter 里会做一次 copy
     */
    BOOL hasSetSelectedImage = selectedImage != self.image;
    
    if (!hasSetSelectedImage && !normalImage) {
        /**
         * 说明没有设置 selectedImage，且 image 是 original 的，则此时 selectedImage 独立对待，从而让配置表对没设置 selectedImage 的也能配置它的颜色
         */
        selectedImage = [self.image imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
    
    selectedImage = tintImageBlock(self, selectedImage, [ESUIConfiguration sharedInstance].tabBarItemImageColorSelected);
    
    if (selectedImage) {
        self.selectedImage = selectedImage;
        
        /**
         * selectedImage setter 里会生成一个新的 selectedImage 实例，所以这里要复制原实例的属性
         */
        self.selectedImage.esuiconf_originalRenderingMode = selectedImage.esuiconf_originalRenderingMode;
    }
}
@end

@implementation UIImage (ESUIConfiguration)

static char kAssociatedObjectKey_hasSetOriginalRenderingMode;
- (void)setEsuiconf_hasSetOriginalRenderingMode:(BOOL)value {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_hasSetOriginalRenderingMode, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)esuiconf_hasSetOriginalRenderingMode {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_hasSetOriginalRenderingMode)) boolValue];
}

static char kAssociatedObjectKey_originalRenderingMode;
- (void)setEsuiconf_originalRenderingMode:(UIImageRenderingMode)value {
    self.esuiconf_originalRenderingMode = YES;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_originalRenderingMode, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageRenderingMode)esuiconf_originalRenderingMode {
    if (!self.esuiconf_originalRenderingMode) return ESUIImageOriginalRenderingModeDefault;
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_originalRenderingMode)) integerValue];
}
@end

