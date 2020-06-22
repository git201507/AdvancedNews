//
//  BasicEncryPtionAES.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicEncryPtionAES : NSObject

//加密,key16位，24位或者32位
+ (NSData *)AESEncryptWithKey:(NSString *)key sourceData:(NSData *)data;
//解密,key16位，24位或者32位
+ (NSData *)AESDecryptWithKey:(NSString *)key sourceData:(NSData *)data;

@end
