//
//  UINavigationBar+NavigationBarTransition.m
//  iosproject
//
//  Created by hlcisy on 2021/1/8.
//  Copyright © 2021 hlcisy. All rights reserved.
//

#import "UINavigationBar+NavigationBarTransition.h"
#import "ESUICategories.h"
#import "ESUICore.h"

@implementation UINavigationBar (NavigationBarTransition)
@dynamic esui_backButtonLabel;

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

- (UILabel *)esui_backButtonLabel {
    if (@available(iOS 11, *)) {
        __block UILabel *backButtonLabel = nil;
        [self.esui_contentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
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
