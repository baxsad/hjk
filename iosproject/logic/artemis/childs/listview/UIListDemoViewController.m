//
//  UIListDemoViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIListDemoViewController.h"
#import "UIListView.h"
#import <FPSLabel/FPSLabel.h>

@interface UIListCardCell : UIListCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation UIListCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.width.equalTo(self.imageView.mas_height);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.top.greaterThanOrEqualTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}
@end

@interface UIListGoodsCell : UIListCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation UIListGoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.width.equalTo(self.imageView.mas_height);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.top.greaterThanOrEqualTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}
@end

@interface UIListDemoViewController () <UIListViewDataSource>
@property (nonatomic, strong) UIView *headerStatusView;
@property (nonatomic, strong) UIListView *listView;
@property (nonatomic, strong) UILabel *cellCountLabel;
@property (nonatomic, strong) UILabel *reusePoolCountLabel;
@end

@implementation UIListDemoViewController

- (void)didInitialize {
    [super didInitialize];
    
    self.esui_preferredStatusBarStyleBlock = ^UIStatusBarStyle{
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listView reloadData];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.headerStatusView = [[UIView alloc] init];
    [self.view addSubview:self.headerStatusView];
    [self.headerStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ESUIHelper.navigationContentHeightConstant);
        make.height.mas_equalTo(64);
    }];
    
    FPSLabel *fps = [[FPSLabel alloc] init];
    fps.layer.cornerRadius = 0;
    fps.layer.masksToBounds = YES;
    [self.headerStatusView addSubview:fps];
    [fps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headerStatusView);
    }];
    
    self.cellCountLabel = [[UILabel alloc] init];
    self.cellCountLabel.backgroundColor = [UIColor lightGrayColor];
    self.cellCountLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.cellCountLabel.textColor = [UIColor whiteColor];
    self.cellCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerStatusView addSubview:self.cellCountLabel];
    [self.cellCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.headerStatusView);
        make.left.equalTo(fps.mas_right);
        make.width.equalTo(fps);
    }];
    
    self.reusePoolCountLabel = [[UILabel alloc] init];
    self.reusePoolCountLabel.backgroundColor = [UIColor lightGrayColor];
    self.reusePoolCountLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.reusePoolCountLabel.textColor = [UIColor whiteColor];
    self.reusePoolCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerStatusView addSubview:self.reusePoolCountLabel];
    [self.reusePoolCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.headerStatusView);
        make.left.equalTo(self.cellCountLabel.mas_right);
        make.width.equalTo(fps);
    }];
    
    self.listView = [[UIListView alloc] init];
    self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.listView.dataSource = self;
    self.listView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.listView registerClass:[UIListGoodsCell class] forCellReuseIdentifier:@"GoodsCell"];
    [self.listView registerClass:[UIListCardCell class] forCellReuseIdentifier:@"CardCell"];
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerStatusView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-ESUIHelper.safeAreaInsetsForDeviceWithNotch.bottom);
    }];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.title = @"List View";
}

#pragma mark - <UIListViewDataSource>

- (NSUInteger)numberOfSectionsInListView:(UIListView *)listView {
    return 2077;
}

- (NSUInteger)listView:(UIListView *)listView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)listView:(UIListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 99;
}

- (UIListCell *)listView:(UIListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIListCardCell *cell = (UIListCardCell *)[listView dequeueReusableCellWithIdentifier:@"CardCell"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://tvax2.sinaimg.cn/crop.0.0.1080.1080.180/ec658312ly8gko6175lktj20u00u0wgz.jpg?KID=imgbed,tva&Expires=1606399108&ssig=aRV0TmbpKj"]];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"section:%@ row:%@",@(indexPath.section),@(indexPath.row)];
        cell.detailLabel.text = @"Probably at least one of the constraints in the following list is one you don't want.";
        return cell;
    } else {
        UIListGoodsCell *cell = (UIListGoodsCell *)[listView dequeueReusableCellWithIdentifier:@"GoodsCell"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://tvax4.sinaimg.cn/crop.0.0.214.214.180/aafbc54cly8fz49hho61tj205y05yt8w.jpg?KID=imgbed,tva&Expires=1607351700&ssig=iOIQJJR0CW"]];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"section:%@ row:%@",@(indexPath.section),@(indexPath.row)];
        cell.detailLabel.text = @"Created by hlcisy on 2020/11/24. Copyright © 2020 hlcisy. All rights reserved.";
        return cell;
    }
}

- (void)listView:(UIListView *)listView visibleCellCount:(NSUInteger)cellCount reuseCellCount:(NSUInteger)reuseCount {
    self.cellCountLabel.text = [NSString stringWithFormat:@"Cell=%@",@(cellCount)];
    self.reusePoolCountLabel.text = [NSString stringWithFormat:@"Reuse=%@",@(reuseCount)];
}

#pragma mark -

- (nullable UIImage *)navigationBarBackgroundImage {
    UIColor *color = [UIColor whiteColor];
    return [UIImage esui_imageWithColor:color size:CGSizeMake(4, 4) cornerRadius:0];
}

- (nullable UIColor *)navigationBarTintColor {
    return [UIColor darkTextColor];
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}
@end
