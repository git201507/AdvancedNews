//
//  BasicWindowInterFace.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicWindowInterFace.h"

@implementation BasicWindowInterFace

+ (BOOL)addViewToWindow:(UIView *)view level:(BasicWindowLevel)level
{
    return [[BasicWindowManger Instance] addViewToWindow:view level:level];
}

//获取当前显示的viewcon
+ (UIViewController *)getCurTopController
{
    return [[BasicWindowManger Instance] getCurTopController];
}
//获取当前主win
+ (UIWindow *)getMainWindow
{
    return [[BasicWindowManger Instance] getMainWindow];
}

@end
