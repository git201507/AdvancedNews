//
//  BasicMessageCenter.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicMessageCenter.h"

@implementation BasicMessageCenter

+ (void)fireMessage:(NSString *)messageId anexObj:(id)obj
{
    [[NSNotificationCenter defaultCenter] postNotificationName:messageId object:obj];
}

+ (void)subMessage:(id)observer selector:(SEL)aSelector name:(NSString *)aName
{
    [[NSNotificationCenter defaultCenter]  addObserver:observer selector:aSelector name:aName object:nil];
}

+ (void)unSubMessage:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
