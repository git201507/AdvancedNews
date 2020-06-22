//
//  BasicEncryPtionInterFace.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicEncryPtionInterFace : NSObject

//加密,key16位，24位或者32位
+ (NSData *)AESEncryptWithKey:(NSString *)key sourceData:(NSData *)data;
//解密,key16位，24位或者32位
+ (NSData *)AESDecryptWithKey:(NSString *)key sourceData:(NSData *)data;
//MD5校验
+ (NSString *)getFileMD5WithPath:(NSString*)path;

//获取md5字符串
+ (NSString *)md5With16:(NSString *)str;

+ (NSString *)md5With64:(NSString *)str;

@end
