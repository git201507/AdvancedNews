//
//  BasicConfigPath.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicConfigPath.h"
#import "BasicAccountLib.h"

#define CONFIGPATH (@"ConfigPath.plist")

@implementation BasicConfigPath

+ (NSString *)getConfigPathWithKey:(NSString *)key
{
    NSString *path = nil;
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:docFilePath];
    
    if (!dic)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigPath" ofType:@"plist"];
        dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    
    NSString *str = [dic valueForKey:key];
    if (!str)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigPath" ofType:@"plist"];
        dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        str = [dic valueForKey:key];
    }
    path = str;
    
    return path;
}

+ (BOOL)changConfigPathWithKey:(NSString *)key val:(NSString *)val
{
    BOOL rlt = NO;
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:docFilePath];
    [dic setValue:val forKey:key];
    
    rlt = [dic writeToFile:docFilePath atomically:YES];
    
    return rlt;
}

+ (NSArray *)getConfigPathKeyArray
{
    NSArray *array = nil;
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:docFilePath];
    
    if (dic)
    {
        array = [dic allKeys];
    }
    
    return array;
}

+ (BOOL)copyOrReplaceConfigFile
{
    BOOL rlt = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigPath" ofType:@"plist"];
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    rlt = [dic writeToFile:docFilePath atomically:YES];
    
    return rlt;
}
@end
