//
//  BasicAccountLib.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BasicAccountLib : NSObject

//获取账户目录,如果没有创建则创建该目录
+ (NSString *)getAccountPath;

//获取Document路径,由于可能会有共享文件夹的需求，所以更改docment路径
+ (NSString *)getDocumentsPath;

//将路径设置成不上传icould
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

//创建文件夹路径
+ (BOOL)createFolder:(NSString *)createDir;

//删除目录
+ (BOOL)removeFolder:(NSString *)path;

+ (CGSize)sizeWithStr:(NSString *)str font:(UIFont *)fount constrainedToSize:(CGSize)size;

+ (BOOL)validateMobile:(NSString *)mobileNum;
@end
