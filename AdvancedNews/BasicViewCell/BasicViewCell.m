//
//  BasicViewCell.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicViewCell.h"

@implementation BasicViewCell
@synthesize viewCellManger = _viewCellManger;

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        if (!_isFristAdd)
        {
            _isFristAdd = YES;
            [self viewCellDidLoad];
        }
    }
}

- (void)dealloc
{
    
}

+ (BasicViewCell*)Instance
{
    static BasicViewCell *obj = nil;
    @synchronized([BasicViewCell class])
    {
        if (obj == nil)
        {
            obj = [[BasicViewCell alloc] init];
        }
        
    }
    return obj;
}

- (void)viewCellDidLoad
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    if (array && [array count] > 0)
    {
        for (NSInteger i = 0; i < [array count]; i++)
        {
            id <BasicViewCellTimingProtocol> delegate = [array objectAtIndex:i];
            
            if (delegate && [delegate respondsToSelector:@selector(timingViewCellDidLoad:)])
            {
                [delegate timingViewCellDidLoad:self];
            }
        }
        
    }
}

- (void)viewCellWillAppear
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    if (array && [array count] > 0)
    {
        for (NSInteger i = 0; i < [array count]; i++)
        {
            id <BasicViewCellTimingProtocol> delegate = [array objectAtIndex:i];
            
            if (delegate && [delegate respondsToSelector:@selector(timingViewCellWillAppear:)])
            {
                [delegate timingViewCellWillAppear:self];
            }
        }
        
    }
}

- (void)viewCellWillDisappear
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    if (array && [array count] > 0)
    {
        for (NSInteger i = 0; i < [array count]; i++)
        {
            id <BasicViewCellTimingProtocol> delegate = [array objectAtIndex:i];
            
            if (delegate && [delegate respondsToSelector:@selector(timingViewCellWillDisappear:)])
            {
                [delegate timingViewCellWillDisappear:self];
            }
        }
        
    }
}

- (void)viewCellDidAppear
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    if (array && [array count] > 0)
    {
        for (NSInteger i = 0; i < [array count]; i++)
        {
            id <BasicViewCellTimingProtocol> delegate = [array objectAtIndex:i];
            
            if (delegate && [delegate respondsToSelector:@selector(timingViewCellDidAppear:)])
            {
                [delegate timingViewCellDidAppear:self];
            }
        }
        
    }
}

- (void)viewCellDidDisappear
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    if (array && [array count] > 0)
    {
        for (NSInteger i = 0; i < [array count]; i++)
        {
            id <BasicViewCellTimingProtocol> delegate = [array objectAtIndex:i];
            
            if (delegate && [delegate respondsToSelector:@selector(timingViewCellDidDisappear:)])
            {
                [delegate timingViewCellDidDisappear:self];
            }
        }
        
    }
}

#pragma mark - 自己方法
- (NSMutableArray *)getRegistArray
{
    if (!_registArray)
    {
        _registArray = [[NSMutableArray alloc] init];
    }
    return _registArray;
}

+ (void)registViewCellTiming:(id <BasicViewCellTimingProtocol>)delegate
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    @try
    {
        [array addObject:delegate];
    }
    @catch (NSException *exception)
    {
        
    }
}

+ (void)logoutViewCellTiming:(id <BasicViewCellTimingProtocol>)delegate
{
    NSMutableArray *array = [[BasicViewCell Instance] getRegistArray];
    @try
    {
        [array removeObject:delegate];
    }
    @catch (NSException *exception)
    {
        
    }
}

@end
