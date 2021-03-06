//
//  NSString+ESUITrims.h
//  iosproject
//
//  Created by hlcisy on 2020/11/2.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ESUITrims)

/// 去掉头尾的空白字符
@property (readonly, copy) NSString *esui_trim;

/// 去掉整段文字内的所有空白字符（包括换行符）
@property (readonly, copy) NSString *esui_trimAllWhiteSpace;

/// 将文字中的换行符替换为空格
@property (readonly, copy) NSString *esui_trimLineBreakCharacter;
@end

NS_ASSUME_NONNULL_END
