//
//  BasicToastView.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicToastDef.h"

@interface BasicToastView : UIView
{
@private
    NSString *_text;
    NSInteger _fontNum;
    BasicToastTime _showTime;
    BOOL _isFristShow;
    NSTimer *_timer;
}
@property (nonatomic, strong) IBOutlet UILabel *showLabel;

- (void)setText:(NSString *)setText;
- (void)setShowDuringTime:(BasicToastTime)time;
- (void)setTextFount:(NSInteger)fount;
- (void)show;

@end
