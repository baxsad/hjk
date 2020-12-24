//
//  UILabel+NavigationBarTransition.m
//  iosproject
//
//  Created by hlcisy on 2020/12/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UILabel+NavigationBarTransition.h"
#import "HJKCategories.h"
#import "HJKCore.h"

@implementation UILabel (NavigationBarTransition)

+ (void)load {
    if (@available(iOS 11, *)) ; else return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideInstanceImplementation(NSClassFromString(@"UIButtonLabel"), @selector(setAttributedText:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UILabel *selfObject, NSAttributedString *attributedText) {
                if (selfObject.hjk_specifiedTextColor) {
                    NSMutableAttributedString *mutableAttributedText;
                    if ([attributedText isKindOfClass:NSMutableAttributedString.class]) {
                        mutableAttributedText = (NSMutableAttributedString *)attributedText;
                    } else {
                        mutableAttributedText = [attributedText mutableCopy];
                    }
                    
                    [mutableAttributedText addAttributes:@{NSForegroundColorAttributeName : selfObject.hjk_specifiedTextColor}
                                                   range:NSMakeRange(0, mutableAttributedText.length)];
                    attributedText = mutableAttributedText;
                }
                
                void (*originSelectorIMP)(id, SEL, NSAttributedString *);
                originSelectorIMP = (void (*)(id, SEL, NSAttributedString *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, attributedText);
            };
        });
    });
}

- (void)setHjk_specifiedTextColor:(UIColor *)value {
    objc_setAssociatedObject(self, @selector(hjk_specifiedTextColor), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)hjk_specifiedTextColor {
    return (UIColor *)objc_getAssociatedObject(self, _cmd);
}
@end
