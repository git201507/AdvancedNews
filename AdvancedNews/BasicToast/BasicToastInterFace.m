//
//  BasicToastInterFace.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicToastInterFace.h"
#import "BasicToastManger.h"

@implementation BasicToastInterFace

+ (void)showToast:(NSString *)text
{
    [[BasicToastManger Instance] showToast:text];
}

+ (void)showToast:(NSString *)text showTime:(BasicToastTime)time
{
    [[BasicToastManger Instance] showToast:text showTime:time];
}

+ (void)showToast:(NSString *)text font:(BasicToastFont)font
{
    [[BasicToastManger Instance] showToast:text font:font];
}

+ (void)showToast:(NSString *)text showTime:(BasicToastTime)time font:(BasicToastFont)font
{
    [[BasicToastManger Instance] showToast:text showTime:time font:font];
}

@end
