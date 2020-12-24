//
//  NSString+HJKArray.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HJKArray)

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，如果多个空格，则每个空格也会当成一个 item
@property (nullable, readonly, copy) NSArray<NSString *> *hjk_toArray;

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，但会自动过滤掉空白字符
@property (nullable, readonly, copy) NSArray<NSString *> *hjk_toTrimmedArray;
@end

NS_ASSUME_NONNULL_END
