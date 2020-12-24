//
//  HJKRouter.m
//  iosproject
//
//  Created by hlcisy on 2020/8/27.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKRouter.h"
#import "HJKRouterUtilities.h"

@interface UIViewController (HJKRouter)
+ (UIViewController *_Nullable)hjk_topMost;
@end

@interface HJKRouter ()
@property (nonatomic, strong) HJKURLMatcher *matcher;
@property (nonatomic, strong) NSMutableDictionary<NSString*,HJKURLDefinition*>* mutableRoutes;
@end

@implementation HJKRouter

- (instancetype)init {
    self = [super init];
    if (self) {
        _matcher = [[HJKURLMatcher alloc] init];
        _mutableRoutes = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)global {
    static HJKRouter *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[HJKRouter alloc] init];
    });
    
    return shared;
}

- (void)register:(nonnull NSString *)pattern factory:(nonnull HJKRouterViewControllerFactory)factory {
    HJKURLDefinition *route = [[HJKURLDefinition alloc] initWithPattern:pattern viewControllerFactory:factory];
    if (route) {
        NSString *cacheKey = [HJKRouterUtilities routeIdentifierWithRoute:route];
        [self.mutableRoutes setObject:route forKey:cacheKey];
    }
}

- (void)handle:(nonnull NSString *)pattern factory:(nonnull HJKRouterURLOpenHandlerFactory)factory {
    HJKURLDefinition *route = [[HJKURLDefinition alloc] initWithPattern:pattern openHandlerFactory:factory];
    if (route) {
        NSString *cacheKey = [HJKRouterUtilities routeIdentifierWithRoute:route];
        [self.mutableRoutes setObject:route forKey:cacheKey];
    }
}

- (UIViewController * _Nullable)viewControllerForURL:(nonnull NSURL *)url context:(id _Nullable)context {
    HJKURLMatcherResult *result = [self.matcher match:url];
    
    if (!result) {
        return nil;
    }
    
    NSString *cacheKey = [HJKRouterUtilities routeIdentifierWithMatcherResultNoPattern:result];
    HJKURLDefinition *route = [self.mutableRoutes objectForKey:cacheKey];
    if (route && route.isMatchOption) {
        route = nil;
    }
    
    if (route == nil) {
        cacheKey = [HJKRouterUtilities routeIdentifierWithMatcherResultPattern:result];
        route = [self.mutableRoutes objectForKey:cacheKey];
        if (route && !route.isMatchOption) {
            route = nil;
        }
    }
    
    if (route && route.viewControllerFactory) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        info[@"route"] = result.URL.absoluteString;
        if (route.isMatchOption) {
            info[route.match] = result.action;
        }
        if (result.queryParams) {
            info[@"params"] = result.queryParams;
        } else {
            info[@"params"] = [NSDictionary dictionary];
        }
        return route.viewControllerFactory(info,context);
    }
    
    return nil;
}

- (BOOL)handlerForURL:(nonnull NSURL *)url context:(id _Nullable)context {
    HJKURLMatcherResult *result = [self.matcher match:url];
    
    if (!result) {
        return NO;
    }
    
    NSString *cacheKey = [HJKRouterUtilities routeIdentifierWithMatcherResultNoPattern:result];
    HJKURLDefinition *route = [self.mutableRoutes objectForKey:cacheKey];
    if (route && route.isMatchOption) {
        route = nil;
    }
    
    if (route == nil) {
        cacheKey = [HJKRouterUtilities routeIdentifierWithMatcherResultPattern:result];
        route = [self.mutableRoutes objectForKey:cacheKey];
        if (route && !route.isMatchOption) {
            route = nil;
        }
    }
    
    if (route && route.openHandlerFactory) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        info[@"route"] = result.URL.absoluteString;
        if (route.isMatchOption) {
            info[route.match] = result.action;
        }
        if (result.queryParams) {
            info[@"params"] = result.queryParams;
        } else {
            info[@"params"] = [NSDictionary dictionary];
        }
        return route.openHandlerFactory(info,context);
    }
    
    return NO;
}

- (UIViewController * _Nullable)pushURL:(nonnull NSURL *)url context:(id _Nullable)context from:(UINavigationController *_Nullable)from animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    UIViewController *viewController = [self viewControllerForURL:url context:context];
    return [self pushViewController:viewController context:context from:from animated:animated completion:completion];
}

- (UIViewController * _Nullable)pushViewController:(nonnull UIViewController *)viewController context:(id _Nullable)context from:(UINavigationController *_Nullable)from animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return nil;
    }
    
    UINavigationController *navigationController = from;
    if (!navigationController) {
        navigationController = [UIViewController hjk_topMost].navigationController;
    }
    
    BOOL shouldPush = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(routerShouldPush:from:)]) {
        shouldPush = [self.delegate routerShouldPush:viewController from:navigationController];
    }
    
    if (shouldPush) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion) {
                completion();
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(routerDidPush:)]) {
                [self.delegate routerDidPush:viewController];
            }
        }];
        [navigationController pushViewController:viewController animated:animated];
        [CATransaction commit];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(routerCanceledPush:)]) {
            [self.delegate routerCanceledPush:viewController];
        }
    }
    
    return viewController;
}

- (UIViewController *_Nullable)presentURL:(NSURL *)url context:(id _Nullable)context wrap:(UINavigationController *_Nullable)wrap from:(UIViewController *_Nullable)from animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    UIViewController *viewController = [self viewControllerForURL:url context:context];
    return [self presentViewController:viewController context:context wrap:wrap from:from animated:animated completion:completion];
}

- (UIViewController *_Nullable)presentViewController:(UIViewController *)viewController context:(id _Nullable)context wrap:(UINavigationController *_Nullable)wrap from:(UIViewController *_Nullable)from animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    UIViewController *fromViewController = from;
    if (!fromViewController) {
        fromViewController = [UIViewController hjk_topMost];
    }
    
    UIViewController *viewControllerToPresent;
    
    if (wrap && ![viewController isKindOfClass:[UINavigationController class]]) {
        NSMutableArray *viewControllers = [wrap.viewControllers mutableCopy];
        [viewControllers addObject:viewController];
        [wrap setViewControllers:viewControllers];
        
        viewControllerToPresent = wrap;
    }
    
    BOOL shouldPresent = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(routerShouldPresent:from:)]) {
        shouldPresent = [self.delegate routerShouldPresent:viewController from:fromViewController];
    }
    
    if (shouldPresent) {
        [fromViewController presentViewController:viewControllerToPresent
                                         animated:animated
                                       completion:^{
            if (completion) {
                completion();
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(routerDidPresent:)]) {
                [self.delegate routerDidPresent:viewController];
            }
        }];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(routerCanceledPresent:)]) {
            [self.delegate routerCanceledPresent:viewController];
        }
    }
    
    return viewController;
}

- (BOOL)openURL:(nonnull NSURL *)url context:(id _Nullable)context {
    return [self handlerForURL:url context:context];
}
@end

@implementation UIViewController (HJKRouter)

+ (UIApplication *_Nullable)hjk_sharedApplication {
    SEL selector = NSSelectorFromString(@"sharedApplication");
    id response = [UIApplication performSelector:selector];
    
    if ([response isKindOfClass:[UIApplication class]]) {
        return response;
    }
    
    return nil;
}

+ (UIViewController *_Nullable)hjk_topMost {
    NSArray *currentWindows = [self.hjk_sharedApplication windows];
    UIViewController *rootViewController = nil;
    
    for (UIWindow *window in currentWindows) {
        if (window.rootViewController && window.isKeyWindow) {
            rootViewController = window.rootViewController;
            break;
        }
    }
    
    return [self hjk_topMostOfViewController:rootViewController];
}

+ (UIViewController *_Nullable)hjk_topMostOfViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self hjk_topMostOfViewController:viewController.presentedViewController];
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self hjk_topMostOfViewController:tabBarController.selectedViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self hjk_topMostOfViewController:navigationController.visibleViewController];
    }
    
    if ([viewController isKindOfClass:[UIPageViewController class]]) {
        UIPageViewController *pageViewController = (UIPageViewController *)viewController;
        if (pageViewController.viewControllers.count == 1) {
            return [self hjk_topMostOfViewController:pageViewController.viewControllers.firstObject];
        }
    }
    
    for (UIView *subview in viewController.view.subviews) {
        UIResponder *nextResponder = subview.nextResponder;
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return [self hjk_topMostOfViewController:(UIViewController *)nextResponder];
        }
    }
    
    return viewController;
}
@end
