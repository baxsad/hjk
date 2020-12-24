//
//  HJKRouterDelegate.h
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HJKRouterDelegate <NSObject>
@optional
- (BOOL)routerShouldPush:(UIViewController *)viewController from:(UINavigationController *)from;
- (void)routerDidPush:(UIViewController *)viewController;
- (void)routerCanceledPush:(UIViewController *)viewController;
- (BOOL)routerShouldPresent:(UIViewController *)viewController from:(UIViewController *)from;
- (BOOL)routerDidPresent:(UIViewController *)viewController;
- (BOOL)routerCanceledPresent:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
