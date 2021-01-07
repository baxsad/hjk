//
//  UIListCell.m
//  iosproject
//
//  Created by hlcisy on 2020/11/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIListCell.h"

@interface UIListCell ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation UIListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initContentView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _initContentView];
    }
    return self;
}

- (void)_initContentView {
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect cellBounds = self.bounds;
    CGRect contentBounds = self.contentView.frame;
    if (!CGSizeEqualToSize(cellBounds.size, contentBounds.size)) {
        self.contentView.frame = cellBounds;
    }
}
@end
