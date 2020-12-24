//
//  UINasaViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UINasaViewController.h"

@interface UINasaViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation UINasaViewController

- (void)didInitialize {
    [super didInitialize];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.title = @"NASA";
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImage *image = [UIImage imageNamed:@"icon_nasa_background"];
        _backgroundImageView = [[UIImageView alloc] initWithImage:image];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}
@end
