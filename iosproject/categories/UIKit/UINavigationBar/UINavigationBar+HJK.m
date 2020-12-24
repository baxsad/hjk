//
//  UINavigationBar+HJK.m
//  iosproject
//
//  Created by hlcisy on 2020/12/23.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINavigationBar+HJK.h"
#import "NSObject+HJKKVC.h"

@implementation UINavigationBar (HJK)

- (UIView *)hjk_contentView {
    return [self valueForKeyPath:@"visualProvider.contentView"];
}

- (UIView *)hjk_backgroundView {
    return [self hjk_valueForKey:@"_backgroundView"];
}
@end
