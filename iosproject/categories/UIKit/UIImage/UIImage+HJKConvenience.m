//
//  UIImage+HJKConvenience.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIImage+HJKConvenience.h"
#import "UIImage+HJKDrawing.h"
#import "UIColor+HJK.h"
#import "HJKCore.h"

@implementation UIImage (HJKConvenience)

+ (UIImage *)hjk_imageWithColor:(UIColor *)color {
    return [UIImage hjk_imageWithColor:color size:CGSizeMake(4, 4) cornerRadius:0];
}

+ (UIImage *)hjk_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    size = CGSizeFlatted(size);
    if (!CGSizeIsValidated(size)) {
        NSAssert(NO, @"HJK CGPostError, %@:%d %s, 非法的size：%@\n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, NSStringFromCGSize(size), [NSThread callStackSymbols]);
    }
    
    color = color ? color : [UIColor clearColor];
    BOOL opaque = (cornerRadius == 0.0 && [color hjk_alpha] == 1.0);
    return [UIImage hjk_imageWithSize:size opaque:opaque scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        if (cornerRadius > 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            [path addClip];
            [path fill];
        } else {
            CGContextFillRect(contextRef, rect);
        }
    }];
}
@end
