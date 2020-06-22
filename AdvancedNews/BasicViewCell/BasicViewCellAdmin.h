//
//  BasicViewCellAdmin.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicViewCellManger.h"

#define BASICVIEWCELLADMINTIME  (0.2)

@interface BasicViewCellAdmin : NSObject
{
    __weak BasicViewCell *_viewCell;
    __weak BasicViewCellManger *_viewCellManger;
    SEL _pushSEL;
    SEL _popSEL;
}


- (void)pushAdmin:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell doneAdmin:(SEL)adminSEL;
- (void)popAdmin:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell doneAdmin:(SEL)adminSEL;
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

// 动画, 需要不同动画重写这些函数
- (void)animationPushWillStart:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell;
- (void)animationPopWillStart:(BasicViewCellManger *)ViewCellManger popViewCell:(BasicViewCell *)popViewCell;


@end
