//
//  BasicConfigPath.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicConfigPath : NSObject

+ (NSString *)getConfigPathWithKey:(NSString *)key;

+ (NSArray *)getConfigPathKeyArray;

//改变config文件路径
+ (BOOL)changConfigPathWithKey:(NSString *)key val:(NSString *)val;

//从包中复制到doc目录下
+ (BOOL)copyOrReplaceConfigFile;

@end
