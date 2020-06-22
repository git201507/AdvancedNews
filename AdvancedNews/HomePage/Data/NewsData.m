//
//  NewsData.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "NewsData.h"

@implementation HotNews

- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return  str;
}

@end

@implementation HotNewsReceiveInfo

- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"data"])
    {
        str = @"HotNews";
    }
    return  str;
}

@end

@implementation CurrentDateReceiveInfo


@end


@implementation NewsPaper
- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return  str;
}

@end

@implementation NewsPaperReceiveInfo

- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"data"])
    {
        str = @"NewsPaper";
    }
    return  str;
}

@end

@implementation NewsRecord
- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return  str;
}

@end

@implementation NewsRecordReceiveInfo

- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"data"])
    {
        str = @"NewsRecord";
    }
    return  str;
}

@end
