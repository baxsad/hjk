//
//  ESUIWeakObjectContainer.h
//  iosproject
//
//  Created by hlcisy on 2020/11/4.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESUIWeakObjectContainer : NSProxy
- (instancetype)initWithObject:(id)object;
- (instancetype)init;
+ (instancetype)containerWithObject:(id)object;
@property (nullable, nonatomic, weak) id object;
@end

NS_ASSUME_NONNULL_END
