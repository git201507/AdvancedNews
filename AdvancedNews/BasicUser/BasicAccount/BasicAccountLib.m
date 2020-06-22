//
//  BasicAccountLib.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicAccountLib.h"

#define PROJECTPATH (@"Project")
#define BASICDOCUMENT (@"BasicDocument")

@implementation BasicAccountLib

//获取账户目录
+ (NSString *)getAccountPath
{
    BOOL rlt = NO;
    
    NSString *docPath = [self getDocumentsPath];
    NSString *accountPath = [NSString stringWithFormat:@"%@/Account/", docPath];
    
    rlt = [self createFolder:accountPath];
    
    return accountPath;
}

//获取Document路径,由于可能会有共享文件夹的需求，所以更改docment路径
+ (NSString *)getDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *temp = [paths objectAtIndex:0];
    NSString *docDir = [NSString stringWithFormat:@"%@/%@/%@", temp, BASICDOCUMENT, PROJECTPATH];
    
    [self createFolder:docDir];
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:docDir]];
    
    return docDir;
}

//创建文件夹路径
+ (BOOL)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if (!(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        return NO;
    }
    
    return YES;
}

//将路径设置成不上传icould
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
    {
        return NO;
    }
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return success;
}

//删除目录
+ (BOOL)removeFolder:(NSString *)path
{
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (existed == YES)
    {
        NSError *error = nil;
        isDir = [fileManager removeItemAtPath:path error:&error];
    }
    
    return isDir;
}

+ (CGSize)sizeWithStr:(NSString *)str font:(UIFont *)fount  constrainedToSize:(CGSize)size
{
    CGSize rltSize = CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:fount, NSParagraphStyleAttributeName:paragraphStyle.copy};
    rltSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return rltSize;
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    NSString *numberMatch = @"^(13\\d|14[057]|15[^4,\\D]|17[013678]|18\\d)\\d{8}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberMatch];
    if ([regextestct evaluateWithObject:mobileNum] == YES && [mobileNum length] == 11)
    {
        return YES;
    }
    
    return NO;
}

@end
