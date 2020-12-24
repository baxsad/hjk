//
//  HJKTransitionNavigationBar.m
//  iosproject
//
//  Created by hlcisy on 2020/11/6.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "HJKTransitionNavigationBar.h"
#import "HJKCategories.h"
#import "HJKCore.h"

@implementation HJKTransitionNavigationBar

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.0, *)) {
            /**
             * iOS 14 开启 customNavigationBarTransitionKey 的情况下转场效果错误
             */
            OverrideInstanceImplementation([HJKTransitionNavigationBar class], NSSelectorFromString([NSString stringWithFormat:@"_%@_%@", @"accessibility", @"navigationController"]), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UINavigationController *(HJKTransitionNavigationBar *selfObject) {
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
        backgroundImage = [UIImage hjk_imageWithColor:[UIColor clearColor]];
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
        self.hjk_backgroundView.frame = self.bounds;
    }
}
@end

@implementation UINavigationBar (NavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation([UINavigationBar class], @selector(setShadowImage:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(__unsafe_unretained __kindof UINavigationBar *selfObject, UIImage *shadowImage) {
                    void (*originSelectorIMP)(id, SEL, UIImage *);
                    originSelectorIMP = (void (*)(id, SEL, UIImage *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, shadowImage);
                    
                    if (selfObject.transitionNavigationBar) {
                        selfObject.transitionNavigationBar.shadowImage = shadowImage;
                    }
                };
        });
        
        OverrideInstanceImplementation([UINavigationBar class], @selector(setBarTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(__unsafe_unretained __kindof UINavigationBar *selfObject, UIColor *barTintColor) {
                    void (*originSelectorIMP)(id, SEL, UIColor *);
                    originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, barTintColor);
                    
                    if (selfObject.transitionNavigationBar) {
                        selfObject.transitionNavigationBar.barTintColor = barTintColor;
                    }
                };
        });
        
        OverrideInstanceImplementation([UINavigationBar class], @selector(setBackgroundImage:forBarMetrics:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(__unsafe_unretained __kindof UINavigationBar *selfObject, UIImage *backgroundImage, UIBarMetrics metrics) {
                    void (*originSelectorIMP)(id, SEL, UIImage *, UIBarMetrics);
                    originSelectorIMP = (void (*)(id, SEL, UIImage *, UIBarMetrics))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, backgroundImage, metrics);
                    
                    if (selfObject.transitionNavigationBar) {
                        [selfObject.transitionNavigationBar setBackgroundImage:backgroundImage forBarMetrics:metrics];
                    }
                };
        });
    });
}

- (void)setTransitionNavigationBar:(UINavigationBar *)value {
    objc_setAssociatedObject(self, @selector(transitionNavigationBar), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar *)transitionNavigationBar {
    return (UINavigationBar *)objc_getAssociatedObject(self, _cmd);
}

- (UILabel *)hjk_backButtonLabel {
    if (@available(iOS 11, *)) {
        __block UILabel *backButtonLabel = nil;
        [self.hjk_contentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIButtonBarButton")]) {
                UIButton *titleButton = [subview valueForKeyPath:@"visualProvider.titleButton"];
                backButtonLabel = titleButton.titleLabel;
                *stop = YES;
            }
        }];
        return backButtonLabel;
    }
    return nil;
}
@end
