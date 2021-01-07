//
//  UIListView.h
//  iosproject
//
//  Created by hlcisy on 2020/11/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIListCell.h"

NS_ASSUME_NONNULL_BEGIN

@class UIListView;

@protocol UIListViewDataSource <NSObject>
- (NSUInteger)listView:(UIListView *)listView numberOfRowsInSection:(NSInteger)section;
- (UIListCell *)listView:(UIListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)listView:(UIListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSUInteger)numberOfSectionsInListView:(UIListView *)listView;
- (void)listView:(UIListView *)listView visibleCellCount:(NSUInteger)cellCount reuseCellCount:(NSUInteger)reuseCount;
@end

@interface UIListView : UIScrollView
@property (nullable, nonatomic, weak) id<UIListViewDataSource> dataSource;
- (void)reloadData;
- (UIListCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
