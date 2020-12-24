//
//  UISpaceXViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UISpaceXViewController.h"

@interface UISpaceXViewController ()
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation UISpaceXViewController

- (void)didInitialize {
    [super didInitialize];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.titleView = self.titleImageView;
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        UIImage *image = [UIImage imageNamed:@"icon_spacex_logo"];
        _titleImageView = [[UIImageView alloc] initWithImage:[image hjk_imageWithTintColor:[UIColor whiteColor]]];
    }
    return _titleImageView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImage *image = [UIImage imageNamed:@"icon_spacex_background"];
        _backgroundImageView = [[UIImageView alloc] initWithImage:image];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}
@end
