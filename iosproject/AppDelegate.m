//
//  AppDelegate.m
//  iosproject
//
//  Created by hlcisy on 2020/8/23.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "AppDelegate.h"
#import "UIArtemisViewController.h"
#import "UISpaceXViewController.h"
#import "UINasaViewController.h"
#import "UISocketRocketViewController.h"
#import "UINetDiagnosisViewController.h"
#import "UIListDemoViewController.h"
#import <RealReachability/RealReachability.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GLobalRealReachability startNotifier];
    
    /**
     * Register routes
     */
    [ESCPRouter.global register:@"project://home/category/:action/" factory:^UIViewController * _Nullable(NSDictionary *info, id _Nullable context) {
        if ([[info objectForKey:@"action"] isEqualToString:@"websocket"]) {
            UISocketRocketViewController *socket = [[UISocketRocketViewController alloc] init];
            return socket;
        } else if ([[info objectForKey:@"action"] isEqualToString:@"demo"]) {
            UINetDiagnosisViewController *diagnosis = [[UINetDiagnosisViewController alloc] init];
            return diagnosis;
        } else if ([[info objectForKey:@"action"] isEqualToString:@"list"]) {
            UIListDemoViewController *diagnosis = [[UIListDemoViewController alloc] init];
            return diagnosis;
        }
        
        return nil;
    }];
    
    /**
     * Setup Default Appearance
     */
    [self makeDefaultAppearance];
    
    /**
     * Make KeyWindow And Visible
     */
    [self makeKeyWindowAndVisible];
    
    return YES;
}
@end

@implementation AppDelegate (Appearance)

- (void)makeDefaultAppearance {
    UIColor *barTintColor = [UIColor esui_colorWithHexString:@"#0c5cde"];
    UIImage *barBackgroundImage = [UIImage esui_imageWithColor:barTintColor];
    UIImage *barShadowImage = [UIImage esui_imageWithColor:UIColor.clearColor
                                                      size:CGSizeMake(4, 1.0/UIScreen.mainScreen.scale)
                                              cornerRadius:0];
    
    ESUICMI.viewControllerBackgroundColor = [UIColor whiteColor];
    ESUICMI.statusbarStyleLightInitially = YES;
    ESUICMI.navBarStyle = UIBarStyleDefault;
    ESUICMI.navBarBackgroundImage = barBackgroundImage;
    ESUICMI.navBarShadowImage = barShadowImage;
    ESUICMI.navBarTitleColor = [UIColor whiteColor];
    ESUICMI.navBarTintColor = [UIColor whiteColor];
    ESUICMI.tabBarStyle = UIBarStyleDefault;
    ESUICMI.tabBarBackgroundImage = [UIImage esui_imageWithColor:[UIColor esui_colorWithHexString:@"#fefefe"]];
    ESUICMI.tabBarItemTitleColor = [UIColor esui_colorWithHexString:@"#888888"];
    ESUICMI.tabBarItemTitleColorSelected = [UIColor esui_colorWithHexString:@"#0c5cde"];
    ESUICMI.tabBarItemImageColor = [UIColor esui_colorWithHexString:@"#888888"];
    ESUICMI.tabBarItemImageColorSelected = [UIColor esui_colorWithHexString:@"#0c5cde"];
}
@end

@implementation AppDelegate (KeyWindow)

- (void)makeKeyWindowAndVisible {
    self.window = [[ESUIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    if (@available(iOS 13.0, *)) {
        [self.window setBackgroundColor:[UIColor systemBackgroundColor]];
    } else {
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    
    UIArtemisViewController *artemis = [[UIArtemisViewController alloc] init];
    ESUIBaseNavigationController *artemisNavigation = [[ESUIBaseNavigationController alloc] initWithRootViewController:artemis];
    artemisNavigation.tabBarItem.title = @"Artemis";
    artemisNavigation.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_artemis"];
    
    UINasaViewController *nasa = [[UINasaViewController alloc] init];
    ESUIBaseNavigationController *nasaNavigation = [[ESUIBaseNavigationController alloc] initWithRootViewController:nasa];
    nasaNavigation.tabBarItem.title = @"NASA";
    nasaNavigation.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_nasa"];
    
    UISpaceXViewController *spacex = [[UISpaceXViewController alloc] init];
    ESUIBaseNavigationController *spacexNavigation = [[ESUIBaseNavigationController alloc] initWithRootViewController:spacex];
    spacexNavigation.tabBarItem.title = @"SpaceX";
    spacexNavigation.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_spacex"];

    ESUIBaseTabBarController *root = [[ESUIBaseTabBarController alloc] init];
    root.viewControllers = @[artemisNavigation,nasaNavigation,spacexNavigation];
    [self.window setRootViewController:root];
    [self.window makeKeyAndVisible];
}
@end
