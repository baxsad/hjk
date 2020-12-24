//
//  UIArtemisProjectCell.m
//  iosproject
//
//  Created by hlcisy on 2020/9/30.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIArtemisProjectCell.h"

@interface UIArtemisProjectCell ()
@property (nonatomic, strong) UIView *cardView;
@end

@implementation UIArtemisProjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cardView = [UIView new];
    self.cardView.backgroundColor = [UIColor hjk_colorWithHexString:@"#F7110D"];
    self.cardView.layer.cornerRadius = 13.0;
    if (@available(iOS 13.0, *)) {
        self.cardView.layer.cornerCurve = kCACornerCurveCircular;
    } else {
        // Fallback on earlier versions
    }
    self.cardView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
}
@end
