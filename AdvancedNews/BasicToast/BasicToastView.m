//
//  BasicToastView.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicToastView.h"
#import "BasicWindowInterFace.h"
#import "BasicAccountLib.h"

#define NSSTOAST_WITH       (20)
#define NSSTOAST_HIGHT      (15)
#define NSSTOASTHIGHT_TOP   (80)
#define NSSTOASTMAXWITH     (220)

@implementation BasicToastView

- (void)dealloc
{
    
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow)
    {
        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.75f];
        self.showLabel.textColor = [UIColor whiteColor];
    }
}

- (void)initVal
{
    if (_fontNum == 0)
    {
        _fontNum = BASICTOASTFONT_DEF;
        self.showLabel.font = [UIFont systemFontOfSize:_fontNum];
    }
    if (_showTime == 0)
    {
        _showTime = BASICTOASTTIME_DEF;
    }
}

- (void)setShowDuringTime:(BasicToastTime)time
{
    _showTime = time;
}

- (void)setTextFount:(NSInteger)fount
{
    _fontNum = fount;
    self.showLabel.font = [UIFont systemFontOfSize:_fontNum];
}

- (void)setText:(NSString *)setText
{
    if (!_text)
    {
        _isFristShow = YES;
    }
    else
    {
        _isFristShow = NO;
    }
    if (setText)
    {
        _text = [[NSString alloc] initWithString:setText];
    }
}

-(void)dismissToast
{
    [self removeFromSuperview];
}

-(void)showAnimation
{
    self.alpha = 0.0f;
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    self.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)repeatAdimationDone
{
    [UIView beginAnimations:@"showRepeatDone" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    self.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)showRepeatAnimation
{
    
    [UIView beginAnimations:@"showRepeat" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(repeatAdimationDone)];
    [UIView setAnimationDuration:0.3];
    self.alpha = 0.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation
{
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    self.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)fillText:(NSString *)text
{
    CGSize size = [BasicAccountLib sizeWithStr:text font:[UIFont systemFontOfSize:_fontNum] constrainedToSize:CGSizeMake(NSSTOASTMAXWITH - NSSTOAST_WITH, MAXFLOAT)];
    
    CGRect rectFrame = self.frame;
    rectFrame.size.height = size.height + NSSTOAST_HIGHT;
    self.frame = rectFrame;
    
    CGRect rect = self.frame;
    rect.size.width = size.width + NSSTOAST_WITH;
    self.frame = rect;
    
    self.showLabel.text = text;
    
    UIWindow *win = [BasicWindowInterFace getMainWindow];
    CGPoint point = self.center;
    point.x = win.center.x;
    point.y = NSSTOASTHIGHT_TOP;
    self.center = point;
}

- (void)show
{
    [self initVal];
    
    if (_timer)
    {
        [_timer invalidate];
    }
    _timer = [NSTimer timerWithTimeInterval:_showTime target:self selector:@selector(hideAnimation) userInfo:nil repeats:NO];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    if (_isFristShow && _text)
    {
        [self fillText:_text];
        
        [BasicWindowInterFace addViewToWindow:self level:BasicWINDOWLEVEL_LEVEL4];
        [self showAnimation];
    }
    else
    {
        [self fillText:_text];
        [self showRepeatAnimation];
    }
    
}

#pragma mark - 代理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideAnimation];
}

@end
