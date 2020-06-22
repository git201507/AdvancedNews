//
//  BasicMessageInterFace.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicMessageInterFace.h"
#import "BasicMessageCenter.h"

@implementation BasicMessageInterFace

+ (void)fireMessageOnMainThread:(NSString *)messageId anexObj:(id)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [BasicMessageCenter fireMessage:messageId anexObj:obj];
    });
}

+ (void)fireMessageOnCurrentThread:(NSString *)messageId anexObj:(id)obj
{
    [BasicMessageCenter fireMessage:messageId anexObj:obj];
}

+ (void)subMessage:(id)observer selector:(SEL)aSelector MessageID:(NSString *)messageId
{
    [BasicMessageCenter subMessage:observer selector:aSelector name:messageId];
}

+ (void)unSubMessage:(id)observer
{
    [BasicMessageCenter unSubMessage:observer];
}

@end
