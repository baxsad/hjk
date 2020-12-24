//
//  HJKConfigurationMacros.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKConfiguration.h"

#define HJKUICMI ({[HJKConfiguration sharedInstance];})

#pragma mark - Controller

#define UIViewControllerBackgroundColor                 [HJKUICMI viewControllerBackgroundColor]

#pragma mark - NavigationBar

#define NavBarStyle                                     [HJKUICMI navBarStyle]
#define NavBarBackgroundImage                           [HJKUICMI navBarBackgroundImage]
#define NavBarShadowImage                               [HJKUICMI navBarShadowImage]
#define NavBarShadowImageColor                          [HJKUICMI navBarShadowImageColor]
#define NavBarBarTintColor                              [HJKUICMI navBarBarTintColor]
#define NavBarTintColor                                 [HJKUICMI navBarTintColor]
#define NavBarTitleColor                                [HJKUICMI navBarTitleColor]
#define NavBarTitleFont                                 [HJKUICMI navBarTitleFont]
#define NavBarLargeTitleColor                           [HJKUICMI navBarLargeTitleColor]
#define NavBarLargeTitleFont                            [HJKUICMI navBarLargeTitleFont]

#pragma mark - TabBar

#define TabBarStyle                                     [HJKUICMI tabBarStyle]
#define TabBarBackgroundImage                           [HJKUICMI tabBarBackgroundImage]
#define TabBarShadowImageColor                          [HJKUICMI tabBarShadowImageColor]
#define TabBarBarTintColor                              [HJKUICMI tabBarBarTintColor]
#define TabBarItemTitleFont                             [HJKUICMI tabBarItemTitleFont]
#define TabBarItemTitleColor                            [HJKUICMI tabBarItemTitleColor]
#define TabBarItemTitleColorSelected                    [HJKUICMI tabBarItemTitleColorSelected]
#define TabBarItemImageColor                            [HJKUICMI tabBarItemImageColor]
#define TabBarItemImageColorSelected                    [HJKUICMI tabBarItemImageColorSelected]

#pragma mark - Others

#define SupportedOrientationMask                        [HJKUICMI supportedOrientationMask]
#define StatusbarStyleLightInitially                    [HJKUICMI statusbarStyleLightInitially]
