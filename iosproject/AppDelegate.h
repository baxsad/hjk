//
//  AppDelegate.h
//  iosproject
//
//  Created by hlcisy on 2020/8/23.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nullable, nonatomic, strong) UIWindow *window;
@end

@interface AppDelegate (Appearance)
- (void)makeDefaultAppearance;
@end

@interface AppDelegate (KeyWindow)
- (void)makeKeyWindowAndVisible;
@end

