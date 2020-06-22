//
//  BasicEncryPtionAES.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicEncryPtionAES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation BasicEncryPtionAES

+ (NSData *)AESEncryptWithKey:(NSString *)key sourceData:(NSData *)data
{
    NSInteger aesType = kCCKeySizeAES256;
    
    if ([key length] == 24)
    {
        aesType = kCCKeySizeAES192;
    }
    else if ([key length] == 16)
    {
        aesType = kCCKeySizeAES128;
    }
    
    char keyPtr[aesType+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, aesType,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    NSData *rltData = nil;
    if (cryptStatus == kCCSuccess)
    {
        rltData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return rltData;
}

+ (NSData *)AESDecryptWithKey:(NSString *)key sourceData:(NSData *)data
{
    NSInteger aesType = kCCKeySizeAES256;
    
    if ([key length] == 24)
    {
        aesType = kCCKeySizeAES192;
    }
    else if ([key length] == 16)
    {
        aesType = kCCKeySizeAES128;
    }
    
    char keyPtr[aesType+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, aesType,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    NSData *rltData = nil;
    if (cryptStatus == kCCSuccess)
    {
        rltData = [NSData dataWithBytes:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return rltData;
}


@end
