//
//  ESUITransitionNavigationBar.h
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESUITransitionNavigationBar : UINavigationBar

/// 转场过程中假navBar对应的原始navBar
@property (nonatomic, weak) UINavigationBar *originalNavigationBar;
@end

NS_ASSUME_NONNULL_END
