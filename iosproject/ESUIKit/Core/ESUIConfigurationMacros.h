//
//  ESUIConfigurationMacros.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESUIConfiguration.h"

#define ESUICMI ({[ESUIConfiguration sharedInstance];})

#pragma mark - Controller

#define UIViewControllerBackgroundColor                 [ESUICMI viewControllerBackgroundColor]

#pragma mark - NavigationBar

#define NavBarStyle                                     [ESUICMI navBarStyle]
#define NavBarBackgroundImage                           [ESUICMI navBarBackgroundImage]
#define NavBarShadowImage                               [ESUICMI navBarShadowImage]
#define NavBarShadowImageColor                          [ESUICMI navBarShadowImageColor]
#define NavBarBarTintColor                              [ESUICMI navBarBarTintColor]
#define NavBarTintColor                                 [ESUICMI navBarTintColor]
#define NavBarTitleColor                                [ESUICMI navBarTitleColor]
#define NavBarTitleFont                                 [ESUICMI navBarTitleFont]
#define NavBarLargeTitleColor                           [ESUICMI navBarLargeTitleColor]
#define NavBarLargeTitleFont                            [ESUICMI navBarLargeTitleFont]

#pragma mark - TabBar

#define TabBarStyle                                     [ESUICMI tabBarStyle]
#define TabBarBackgroundImage                           [ESUICMI tabBarBackgroundImage]
#define TabBarShadowImageColor                          [ESUICMI tabBarShadowImageColor]
#define TabBarBarTintColor                              [ESUICMI tabBarBarTintColor]
#define TabBarItemTitleFont                             [ESUICMI tabBarItemTitleFont]
#define TabBarItemTitleColor                            [ESUICMI tabBarItemTitleColor]
#define TabBarItemTitleColorSelected                    [ESUICMI tabBarItemTitleColorSelected]
#define TabBarItemImageColor                            [ESUICMI tabBarItemImageColor]
#define TabBarItemImageColorSelected                    [ESUICMI tabBarItemImageColorSelected]

#pragma mark - Others

#define SupportedOrientationMask                        [ESUICMI supportedOrientationMask]
#define StatusbarStyleLightInitially                    [ESUICMI statusbarStyleLightInitially]
