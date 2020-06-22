//
//  BasicViewCell.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUBaseData.h"

@protocol BasicViewCellTimingProtocol <NSObject>
@optional
- (void)timingViewCellDidLoad:(UIView *)view;
- (void)timingViewCellWillAppear:(UIView *)view;
- (void)timingViewCellDidAppear:(UIView *)view;
- (void)timingViewCellWillDisappear:(UIView *)view;
- (void)timingViewCellDidDisappear:(UIView *)view;

@end


@class BasicViewCellManger;
@interface BasicViewCell : UIControl
{
@private
    __weak BasicViewCellManger *_viewCellManger;
    BOOL _isFristAdd;
    NSMutableArray *_registArray;
}

@property (nonatomic, weak) BasicViewCellManger *viewCellManger;

- (void)viewCellDidLoad;
- (void)viewCellWillAppear;

- (void)viewCellDidAppear;

- (void)viewCellWillDisappear;
- (void)viewCellDidDisappear;

//注册viewCell生命时机代理,主线程调用
+ (void)registViewCellTiming:(id <BasicViewCellTimingProtocol>)delegate;
+ (void)logoutViewCellTiming:(id <BasicViewCellTimingProtocol>)delegate;

@end
