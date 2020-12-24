//
//  UIViewController+HJKRuntime.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIViewController+HJKRuntime.h"
#import "NSObject+HJKRuntime.h"

@implementation UIViewController (HJKRuntime)

- (BOOL)hjk_hasOverrideUIKitMethod:(_Nonnull SEL)selector {
    NSMutableArray<Class> *viewControllerSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                               [UIImagePickerController class],
                                               [UINavigationController class],
                                               [UITableViewController class],
                                               [UICollectionViewController class],
                                               [UITabBarController class],
                                               [UISplitViewController class],
                                               [UIPageViewController class],
                                               [UIViewController class],
                                               nil];
    
    if (NSClassFromString(@"UIAlertController")) {
        [viewControllerSuperclasses addObject:[UIAlertController class]];
    }
    if (NSClassFromString(@"UISearchController")) {
        [viewControllerSuperclasses addObject:[UISearchController class]];
    }
    for (NSInteger i = 0, l = viewControllerSuperclasses.count; i < l; i++) {
        Class superclass = viewControllerSuperclasses[i];
        if ([self hjk_hasOverrideMethod:selector ofSuperclass:superclass]) {
            return YES;
        }
    }
    return NO;
}
@end
