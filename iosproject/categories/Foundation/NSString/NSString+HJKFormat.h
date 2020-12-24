//
//  NSString+HJKFormat.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HJKFormat)

/// 把当前文本的第一个字符改为大写，其他的字符保持不变
/// 例如 backgroundView.hjk_capitalizedString -> BackgroundView（系统的 capitalizedString 会变成 Backgroundview）
@property (nullable, readonly, copy) NSString *hjk_capitalizedString;

/// 返回一个符合 query value 要求的编码后的字符串，例如&、#、=等字符均会被变为 %xxx 的编码
/// @see `NSCharacterSet (HJK) hjk_URLUserInputQueryAllowedCharacterSet`
@property (nullable, readonly, copy) NSString *hjk_stringByEncodingUserInputQuery;

/// 用正则表达式匹配的方式去除字符串里一些特殊字符，避免UI上的展示问题
/// @link http://www.croton.su/en/uniblock/Diacriticals.html @/link
@property (nullable, readonly, copy) NSString *hjk_removeMagicalChar;
@end

NS_ASSUME_NONNULL_END
