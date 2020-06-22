//
//  BasicWindowInterFace.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicWindowManger.h"

@interface BasicWindowInterFace : NSObject

//添加view到Window上，根据级别，级别越高显示在最上面
+ (BOOL)addViewToWindow:(UIView *)view level:(BasicWindowLevel)level;

//获取当前显示的viewcon
+ (UIViewController *)getCurTopController;
//获取当前主win
+ (UIWindow *)getMainWindow;

@end
