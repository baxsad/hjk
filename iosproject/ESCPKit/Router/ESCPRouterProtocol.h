//
//  ESCPRouterProtocol.h
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESCPRouterDelegate.h"
#import "ESCPRouterCommon.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ESCPRouterProtocol <NSObject>

@required
@property (nullable, nonatomic, weak) id<ESCPRouterDelegate> delegate;

/// 注册路由页面
/// @param pattern 路由地址格式
/// @param factory 回调方法
- (void)register:(NSString *)pattern factory:(ESCPRouterViewControllerFactory)factory;

/// 注册路由事件
/// @param pattern 路由地址格式
/// @param factory 回调方法
- (void)handle:(NSString *)pattern factory:(ESCPRouterURLOpenHandlerFactory)factory;

/// 通过路由地址获取对应的页面
/// @param url 路由地址信息
/// @param context 上下文对象
- (UIViewController *_Nullable)viewControllerForURL:(NSURL *)url context:(id _Nullable)context;

/// 通过路由地址获取对应的方法实现
/// @param url 路由地址信息
/// @param context 上下文对象
- (BOOL)handlerForURL:(NSURL *)url context:(id _Nullable)context;

/// 通过路由地址导航到指定页面
/// @param url 路由地址信息
/// @param context 上下文对象
/// @param from 导航控制器
/// @param animated 是否需要过渡动画
/// @param completion 导航跳转完成回调
- (UIViewController *_Nullable)pushURL:(NSURL *)url context:(id _Nullable)context from:(UINavigationController *_Nullable)from animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/// 导航跳转到指定的页面
/// @param viewController 目标页面
/// @param context 上下文对象
/// @param from 导航控制器
/// @param animated 是否需要过渡动画
/// @param completion 导航跳转完成回调
- (UIViewController *_Nullable)pushViewController:(UIViewController *)viewController context:(id _Nullable)context from:(UINavigationController *_Nullable)from animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/// 通过路由地址模态显示指定页面
/// @param url 路由地址信息
/// @param context 上下文对象
/// @param wrap 是否需要包含导航控制器
/// @param from 从那个页面模态显示
/// @param animated 是否需要过渡动画
/// @param completion 导航跳转完成回调
- (UIViewController *_Nullable)presentURL:(NSURL *)url context:(id _Nullable)context wrap:(UINavigationController *_Nullable)wrap from:(UIViewController *_Nullable)from animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/// 模态显示指定页面
/// @param viewController 目标页面
/// @param context 上下文对象
/// @param wrap 是否需要包含导航控制器
/// @param from 从那个页面模态显示
/// @param animated 是否需要过渡动画
/// @param completion 导航跳转完成回调
- (UIViewController *_Nullable)presentViewController:(UIViewController *)viewController context:(id _Nullable)context wrap:(UINavigationController *_Nullable)wrap from:(UIViewController *_Nullable)from animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/// 打开一个路由，可以是打开页面也可以是自定义操作
/// @param url 路由地址信息
/// @param context 上下文对象
- (BOOL)openURL:(NSURL *)url context:(id _Nullable)context;
@end

NS_ASSUME_NONNULL_END
