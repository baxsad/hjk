//
//  UINavigationBar+ESUI.m
//  iosproject
//
//  Created by hlcisy on 2020/12/23.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINavigationBar+ESUI.h"
#import "NSObject+ESUIKVC.h"

@implementation UINavigationBar (ESUI)

- (UIView *)esui_contentView {
    return [self valueForKeyPath:@"visualProvider.contentView"];
}

- (UIView *)esui_backgroundView {
    return [self esui_valueForKey:@"_backgroundView"];
}
@end
