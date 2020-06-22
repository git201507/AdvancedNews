//
//  NSString+JSON.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
//将NSString ，NSArray， NSDic 转成json字符串
+(NSString *) jsonStringWithObject:(id) object;
@end
