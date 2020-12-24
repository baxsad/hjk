//
//  MJPropertyKey.h
//  MJExtensionExample
//
//  Created by MJ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /**
     * 字典的key
     */
    MJPropertyKeyTypeDictionary = 0,
    
    /**
     * 数组的key
     */
    MJPropertyKeyTypeArray
} MJPropertyKeyType;

@interface MJPropertyKey : NSObject

/**
 * key的名字
 */
@property (copy,   nonatomic) NSString *name;

/**
 * key的种类，可能是@"10"，可能是@"age"
 */
@property (assign, nonatomic) MJPropertyKeyType type;

/**
 *  根据当前的key，也就是name，从object（字典或者数组）中取值
 */
- (id)valueInObject:(id)object;
@end
