//
//  HJKRouterCommon.h
//  iosproject
//
//  Created by hlcisy on 2020/8/28.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 路由对应的页面的工厂方法，具体跳转到哪个页面实现写在这里面
 */
typedef UIViewController*_Nullable(^HJKRouterViewControllerFactory)(NSDictionary *info, id _Nullable context);

/**
 * 路由对应的事件回调，可以自定义路由的操作
 */
typedef BOOL(^HJKRouterURLOpenHandlerFactory)(NSDictionary *info, id _Nullable context);

NS_ASSUME_NONNULL_END
