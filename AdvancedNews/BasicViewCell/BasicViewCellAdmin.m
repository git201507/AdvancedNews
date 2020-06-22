//
//  BasicViewCellAdmin.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicViewCellAdmin.h"

@implementation BasicViewCellAdmin

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"BasicViewCellAdminPush"])
    {
        if (_viewCellManger && _pushSEL)
        {
            [_viewCellManger performSelectorOnMainThread:_pushSEL withObject:_viewCell waitUntilDone:NO];
        }
    }
    else
    {
        if (_viewCellManger && _popSEL)
        {
            [_viewCellManger performSelectorOnMainThread:_popSEL withObject:_viewCell waitUntilDone:NO];
        }
    }
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (void)pushAdmin:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell doneAdmin:(SEL)adminSEL
{
    _viewCell = pushViewCell;
    _viewCellManger = ViewCellManger;
    _pushSEL = adminSEL;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self animationPushWillStart:ViewCellManger pushViewCell:pushViewCell];
}

- (void)popAdmin:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell doneAdmin:(SEL)adminSEL
{
    _viewCell = pushViewCell;
    _viewCellManger = ViewCellManger;
    _popSEL = adminSEL;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self animationPopWillStart:ViewCellManger popViewCell:pushViewCell];
    
}

- (void)animationPushWillStart:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell
{
    CGRect rect = pushViewCell.frame;
    rect.origin.x = ViewCellManger.frame.size.width;
    
    pushViewCell.frame = rect;
    
    [UIView beginAnimations:@"BasicViewCellAdminPush" context:nil];
    
    [UIView setAnimationDuration:BASICVIEWCELLADMINTIME];//动画执行时间
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画的执行速度
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    pushViewCell.frame = ViewCellManger.bounds;
    [UIView commitAnimations];
    
}

- (void)animationPopWillStart:(BasicViewCellManger *)ViewCellManger popViewCell:(BasicViewCell *)popViewCell
{
    [UIView beginAnimations:@"BasicViewCellAdminPOP" context:nil];
    
    [UIView setAnimationDuration:BASICVIEWCELLADMINTIME];//动画执行时间
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画的执行速度
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    CGRect rect = popViewCell.frame;
    rect.origin.x = ViewCellManger.frame.size.width;
    popViewCell.frame = rect;
    [UIView commitAnimations];
    
}
@end
