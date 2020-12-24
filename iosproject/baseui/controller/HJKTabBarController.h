//
//  HJKTabBarController.h
//  iosproject
//
//  Created by hlcisy on 2020/9/11.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJKTabBarController : UITabBarController

/**
 * 初始化时调用的方法，会在 initWithNibName:bundle: 和 initWithCoder: 这两个指定的初始化方法中被调用
 * 所以子类如果需要同时支持两个初始化方法，则建议把初始化时要做的事情放到这个方法里
 */
- (void)didInitialize NS_REQUIRES_SUPER;
@end

NS_ASSUME_NONNULL_END
