//
//  UIArtemisViewController.m
//  iosproject
//
//  Created by hlcisy on 2020/9/11.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIArtemisViewController.h"
#import "UIArtemisProjectCell.h"

@interface UIArtemisViewController (TableViewDelegate) <UITableViewDelegate, UITableViewDataSource>

@end

@interface UIArtemisViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UIArtemisViewController

- (void)didInitialize {
    [super didInitialize];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, 0, 8);
        view;
    });
    self.tableView.tableFooterView =  ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, 0, 8);
        view;
    });
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UIArtemisProjectCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.title = @"Artemis";
}

#pragma mark - Actions

- (void)socket {
    NSURL *url = [NSURL URLWithString:@"project://home/category/websocket"];
    [ESCPRouter.global pushURL:url context:nil from:self.navigationController animated:YES completion:^{
        
    }];
}

- (void)demo {
    NSURL *url = [NSURL URLWithString:@"project://home/category/demo"];
    [ESCPRouter.global pushURL:url context:nil from:self.navigationController animated:YES completion:^{
        
    }];
}

- (void)list {
    NSURL *url = [NSURL URLWithString:@"project://home/category/list"];
    [ESCPRouter.global pushURL:url context:nil from:self.navigationController animated:YES completion:^{
        
    }];
}
@end

@implementation UIArtemisViewController (TableViewDelegate)

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIArtemisProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ScreenWidth;
    UIEdgeInsets safeAreaInsets = ESUIHelper.safeAreaInsetsForDeviceWithNotch;
    CGFloat cellWidth = width - safeAreaInsets.left - safeAreaInsets.right;
    return cellWidth * 0.33;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self socket];
    } else if (indexPath.row == 1) {
        [self demo];
    } else if (indexPath.row == 2) {
        [self list];
    }
}
@end
