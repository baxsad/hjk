//
//  ESUITransitionNavigationBar.m
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "ESUITransitionNavigationBar.h"
#import "ESUICategories.h"
#import "ESUICore.h"

@implementation ESUITransitionNavigationBar

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.0, *)) {
            /**
             * iOS 14 开启 customNavigationBarTransitionKey 的情况下转场效果错误
             */
            OverrideInstanceImplementation([ESUITransitionNavigationBar class], NSSelectorFromString([NSString stringWithFormat:@"_%@_%@", @"accessibility", @"navigationController"]), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UINavigationController *(ESUITransitionNavigationBar *selfObject) {
                    if (selfObject.originalNavigationBar) {
                        BeginIgnorePerformSelectorLeaksWarning
                        return [selfObject.originalNavigationBar performSelector:originCMD];
                        EndIgnorePerformSelectorLeaksWarning
                    }
                    
                    UINavigationController *(*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (UINavigationController *(*)(id, SEL))originalIMPProvider();
                    UINavigationController *result = originSelectorIMP(selfObject, originCMD);
                    return result;
                };
            });
        }
    });
}

- (void)setOriginalNavigationBar:(UINavigationBar *)originBar {
    _originalNavigationBar = originBar;
    
    if (self.barStyle != originBar.barStyle) {
        self.barStyle = originBar.barStyle;
    }
    
    if (self.translucent != originBar.translucent) {
        self.translucent = originBar.translucent;
    }
    
    if (![self.barTintColor isEqual:originBar.barTintColor]) {
        self.barTintColor = originBar.barTintColor;
    }
    
    UIImage *backgroundImage = [originBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    if (backgroundImage && backgroundImage.size.width <= 0 && backgroundImage.size.height <= 0) {
        backgroundImage = [UIImage esui_imageWithColor:[UIColor clearColor]];
    }
    
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:originBar.shadowImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 11, *)) {
        /**
         * iOS 11 以前，自己 init 的 navigationBar，它的 backgroundView 默认会一直保持与 navigationBar 的高度相等，
         * 但 iOS 11 Beta 1-5 里，自己 init 的 navigationBar.backgroundView.height 默认一直是 44，所以才加上这个兼容
         */
        self.esui_backgroundView.frame = self.bounds;
    }
}
@end
