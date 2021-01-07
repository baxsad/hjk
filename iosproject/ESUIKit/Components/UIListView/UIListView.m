//
//  UIListView.m
//  iosproject
//
//  Created by hlcisy on 2020/11/24.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import "UIListView.h"

@interface UIListRowMeta : NSObject
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, assign) CGFloat height;
@end

@implementation UIListRowMeta

@end

@interface UIListView () <UIScrollViewDelegate>

/**
 * 存储当前列表上所有的 IndexPath
 */
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *indexPaths;

/**
 * 记录当前列表上所有 Cell 的位置信息
 */
@property (nonatomic, strong) NSMutableArray<UIListRowMeta *> *rowRecords;

/**
 * indexPath 与 RowMeta 的对应关系
 */
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UIListRowMeta *> *rowMetasOfIndexPath;

/**
 * 当前列表可视范围内可显示的 IndexPath
 */
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *showingIndexPaths;

/**
 * 当前列表上在显示的 Cell 与 IndexPath 的对应关系
 */
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UIListCell *> *visibleCells;

/**
 * 当前列表 Cell 的重用缓存池
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<UIListCell *> *> *reusePool;
@end

@interface UIListView ()

/**
 * 当前列表注册的 Cell Class 与重用标识符 ReuseIdentifier 的对应关系
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *registerClasses;

/**
 * 当前列表的重用标识符 ReuseIdentifier 与注册的 Cell Class 的对应关系
 */
@property (nonatomic, strong) NSMutableDictionary<id, NSString *> *registerReuseIdentifiers;
@end

@implementation UIListView {
    dispatch_queue_t reloadCalculationQueue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInt];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self didInt];
    }
    return self;
}

- (void)didInt {
    reloadCalculationQueue = dispatch_queue_create("com.listview.calculation", DISPATCH_QUEUE_CONCURRENT);
    self.delegate = self;
    self.indexPaths = [NSMutableArray array];
    self.rowRecords = [NSMutableArray array];
    self.rowMetasOfIndexPath = [NSMutableDictionary dictionary];
    self.showingIndexPaths = [NSMutableArray array];
    self.visibleCells = [NSMutableDictionary dictionary];
    self.reusePool = [NSMutableDictionary dictionary];
    self.registerClasses = [NSMutableDictionary dictionary];
    self.registerReuseIdentifiers = [NSMutableDictionary dictionary];
}

#pragma mark - Layout

- (void)setFrame:(CGRect)frame {
    CGRect precedingFrame = self.frame;
    BOOL valueChange = !CGSizeEqualToSize(frame.size, precedingFrame.size);
    
    [super setFrame:frame];
    if (valueChange) {
        [self _frameSizeDidChange:frame.size];
    }
}

- (void)setBounds:(CGRect)bounds {
    CGRect precedingBounds = self.bounds;
    BOOL valueChange = !CGSizeEqualToSize(bounds.size, precedingBounds.size);
    
    [super setBounds:bounds];
    if (valueChange) {
        [self _frameSizeDidChange:bounds.size];
    }
}

- (void)_frameSizeDidChange:(CGSize)size {
    for (UIListCell *cell in self.visibleCells.allValues) {
        CGRect frame = cell.frame;
        frame.size.width = size.width;
        cell.frame = frame;
    }
}

#pragma mark - Public

- (void)reloadData {
    /**
     * 清空之前的缓存数据
     */
    [self.indexPaths removeAllObjects];
    [self.rowRecords removeAllObjects];
    [self.rowMetasOfIndexPath removeAllObjects];
    [self.showingIndexPaths removeAllObjects];
    [self.visibleCells removeAllObjects];
    [self.reusePool removeAllObjects];
    
    dispatch_async(reloadCalculationQueue, ^{
        /**
         * 当前列表有多少个组
         */
        NSUInteger numberOfSections = 1;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInListView:)]) {
            numberOfSections = [self.dataSource numberOfSectionsInListView:self];
        }
        
        /**
         * 保存当前列表上Cell的总高度
         */
        CGFloat contentHeight = 0;
        
        for (int section = 0; section < numberOfSections; section++) {
            /**
             * 每组有多少个Cell
             */
            NSUInteger numberOfRowsInSection = 0;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(listView:numberOfRowsInSection:)]) {
                numberOfRowsInSection = [self.dataSource listView:self numberOfRowsInSection:section];
            }
            
            /**
             * 遍历当前组的所有Cell计算出在列表上的布局
             */
            if (numberOfRowsInSection > 0) {
                for (int row = 0; row < numberOfRowsInSection; row++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    CGFloat rowHeight = 0;
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(listView:heightForRowAtIndexPath:)]) {
                        rowHeight = [self.dataSource listView:self heightForRowAtIndexPath:indexPath];
                    }
                    
                    UIListRowMeta *rowMeta = [[UIListRowMeta alloc] init];
                    rowMeta.startY = contentHeight;
                    rowMeta.height = rowHeight;
                    
                    [self.indexPaths addObject:indexPath];
                    [self.rowRecords addObject:rowMeta];
                    [self.rowMetasOfIndexPath setObject:rowMeta forKey:indexPath];
                    
                    contentHeight += rowHeight;
                }
            }
        }
        
        /**
         * 获取当前可视范围内可显示的Cell的IndexPath集合
         * 根据IndexPath获取Cell并添加到当前列表上
         */
        [self _indexPathsForVisibleRows:^(NSArray<NSIndexPath *> *visibleIndexPaths, NSRange range) {
            [self.showingIndexPaths addObjectsFromArray:visibleIndexPaths];
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat contentWidth  = self.bounds.size.width;
                self.contentSize = CGSizeMake(contentWidth, contentHeight);
                
                for (NSIndexPath *indexPath in visibleIndexPaths) {
                    UIListCell *cell;
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(listView:cellForRowAtIndexPath:)]) {
                        cell = [self.dataSource listView:self cellForRowAtIndexPath:indexPath];
                    }
                    
                    UIListRowMeta *rowMeta = [self.rowMetasOfIndexPath objectForKey:indexPath];
                    
                    if (cell) {
                        [self addSubview:cell];
                        [cell setFrame:CGRectMake(0, rowMeta.startY, contentWidth, rowMeta.height)];
                        [self.visibleCells setObject:cell forKey:indexPath];
                    }
                }
                
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(listView:visibleCellCount:reuseCellCount:)]) {
                    [self.dataSource listView:self visibleCellCount:self.visibleCells.count reuseCellCount:self.reusePool.allValues.firstObject.count + self.reusePool.allValues.lastObject.count];
                }
            });
        }];
    });
}

- (UIListCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    NSMutableArray *cellReuseList = [self.reusePool objectForKey:identifier];
    if (!cellReuseList) {
        cellReuseList = [NSMutableArray array];
        [self.reusePool setObject:cellReuseList forKey:identifier];
    }
    
    if (cellReuseList.count) {
        UIListCell *cell = cellReuseList.firstObject;
        [cellReuseList removeObject:cell];
        return cell;
    }
    
    NSString *cellClassString = [self.registerClasses objectForKey:identifier];
    Class cellClass = NSClassFromString(cellClassString);
    UIListCell *cell = (UIListCell *)[[cellClass alloc] init];
    
    return cell;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.registerClasses setObject:NSStringFromClass(cellClass) forKey:identifier];
    [self.registerReuseIdentifiers setObject:identifier forKey:NSStringFromClass(cellClass)];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**
     * 列表滑动的时候计算当前可视范围内可显示的Cell的IndexPath集合
     */
    [self _indexPathsForVisibleRows:^(NSArray<NSIndexPath *> *indexPaths, NSRange range) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat contentWidth  = self.bounds.size.width;
            
            /**
             * 超出列表可是范围移出视图、加入重用队列
             * 计算已显示的与最新可显示的差集：代表已经超出范围的 IndexPath
             */
            NSMutableSet *outSet1 = [NSMutableSet setWithArray:self.showingIndexPaths];
            NSMutableSet *outSet2 = [NSMutableSet setWithArray:indexPaths];
            [outSet1 minusSet:outSet2];
            NSArray *outIndexPaths = outSet1.allObjects;
            for (NSIndexPath *idx in outIndexPaths) {
                UIListCell *cell = [self.visibleCells objectForKey:idx];
                [self.visibleCells removeObjectForKey:idx];
                
                Class cellClass = [cell class];
                NSString *cellIdentifier = [self.registerReuseIdentifiers objectForKey:NSStringFromClass(cellClass)];
                NSMutableArray *cellReuseList = [self.reusePool objectForKey:cellIdentifier];
                if (!cellReuseList) {
                    cellReuseList = [NSMutableArray array];
                    [self.reusePool setObject:cellReuseList forKey:cellIdentifier];
                }
                
                [cellReuseList addObject:cell];
                [cell removeFromSuperview];
            }
            
            /**
             * 获取新的可视范围内要显示的Cell、添加在列表上
             * 计算最新可显示与已显示的差集：代表需要新添加在列表上的 IndexPath
             */
            NSMutableSet *newstSet1 = [NSMutableSet setWithArray:indexPaths];
            NSMutableSet *newstSet2 = [NSMutableSet setWithArray:self.showingIndexPaths];
            [newstSet1 minusSet:newstSet2];
            
            for (NSIndexPath *indexPath in newstSet1.allObjects) {
                UIListCell *cell;
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(listView:cellForRowAtIndexPath:)]) {
                    cell = [self.dataSource listView:self cellForRowAtIndexPath:indexPath];
                }
                
                UIListRowMeta *rowMeta = [self.rowMetasOfIndexPath objectForKey:indexPath];
                
                [self addSubview:cell];
                [cell setFrame:CGRectMake(0, rowMeta.startY, contentWidth, rowMeta.height)];
                [self.visibleCells setObject:cell forKey:indexPath];
            }
            
            self.showingIndexPaths = [indexPaths mutableCopy];
            
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(listView:visibleCellCount:reuseCellCount:)]) {
                [self.dataSource listView:self visibleCellCount:self.visibleCells.count reuseCellCount:self.reusePool.allValues.firstObject.count + self.reusePool.allValues.lastObject.count];
            }
        });
    }];
}

#pragma mark - Helper

/// 根据可是范围的可视的开始和结束位置（ContentOffset）计算出可显示的 IndexPath 的范围
/// @param start 可视的开始位置
/// @param end 可视的结束位置
- (NSRange)_numberOfRowsWillShowInListView:(CGFloat)start end:(CGFloat)end {
    UIListRowMeta *startRow = [[UIListRowMeta alloc] init];
    startRow.startY = start;
    UIListRowMeta *endRow = [[UIListRowMeta alloc] init];
    endRow.startY = end;
    
    NSInteger rowCount = self.rowRecords.count;
    
    if (rowCount <= 0) {
        return NSMakeRange(0, 0);
    }
    
    NSInteger startIndex = [self.rowRecords indexOfObject:startRow inSortedRange:NSMakeRange(0, rowCount) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(UIListRowMeta *obj1, UIListRowMeta *obj2) {
        if (obj1.startY < obj2.startY) return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    
    if (startIndex > 0) startIndex--;
    
    NSInteger endIndex = [self.rowRecords indexOfObject:endRow inSortedRange:NSMakeRange(0, rowCount) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(UIListRowMeta *obj1, UIListRowMeta *obj2) {
        if (obj1.startY < obj2.startY) return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    
    if (endIndex > 0 && endIndex < rowCount - 1) endIndex++;
    
    return NSMakeRange(startIndex, endIndex - startIndex);
}

/// 获取当前可视范围内（ContentOffset）可以显示的 IndexPath
/// @param block 计算完成回调
- (void)_indexPathsForVisibleRows:(void (^)(NSArray<NSIndexPath *> *indexPaths, NSRange range))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint contentOffset     = self.contentOffset;
        UIEdgeInsets contentInset = self.contentInset;
        CGSize listSize           = self.bounds.size;
        
        dispatch_async(self->reloadCalculationQueue, ^{
            CGFloat visibleHeight = listSize.height - contentInset.bottom;
            CGFloat start,end;
            
            /**
             * contentOffsetY < 0 代表下拉
             * contentOffsetY > 0 代表上滑
             */
            if (contentOffset.y <= 0) {
                start = 0;
                end = visibleHeight - fabs(contentOffset.y);
            } else {
                start = contentOffset.y;
                end = start + visibleHeight;
            }
            
            NSRange willShowRowsRange = [self _numberOfRowsWillShowInListView:start end:end];
            NSArray<NSIndexPath *> *visibleIndexPaths = [self.indexPaths subarrayWithRange:willShowRowsRange];
            
            if (block) {
                block(visibleIndexPaths,willShowRowsRange);
            }
        });
    });
}
@end
