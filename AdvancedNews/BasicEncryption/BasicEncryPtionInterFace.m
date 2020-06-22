//
//  BasicEncryPtionInterFace.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicEncryPtionInterFace.h"
#import "BasicEncryPtionAES.h"
#import "BasicFileMD5Check.h"

@implementation BasicEncryPtionInterFace

//加密,key16位，24位或者32位
+ (NSData *)AESEncryptWithKey:(NSString *)key sourceData:(NSData *)data
{
    return [BasicEncryPtionAES AESEncryptWithKey:key sourceData:data];
}
//解密,key16位，24位或者32位
+ (NSData *)AESDecryptWithKey:(NSString *)key sourceData:(NSData *)data;
{
    return [BasicEncryPtionAES AESDecryptWithKey:key sourceData:data];
}
+ (NSString *)getFileMD5WithPath:(NSString*)path
{
    return [BasicFileMD5Check getFileMD5WithPath:path];
}

+ (NSString *)md5With16:(NSString *)str
{
    return [BasicFileMD5Check md5With16:str];
}

+ (NSString *)md5With64:(NSString *)str
{
    return [BasicFileMD5Check md5With64:str];
}

@end
