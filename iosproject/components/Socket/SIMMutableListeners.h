//
//  SIMMutableListeners.h
//  iosproject
//
//  Created by hlcisy on 2020/9/11.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMMutableListeners : NSObject
+ (instancetype)weakListeners;
+ (instancetype)strongListeners;
@property (nonatomic, strong, readonly) NSPointerArray *listeners;
- (void)addListener:(id)listener;
- (BOOL)removeListener:(id)listener;
- (void)removeAllListeners;
- (BOOL)containsListener:(id)listener;
@end

NS_ASSUME_NONNULL_END
