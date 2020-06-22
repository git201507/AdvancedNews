//
//  BasicToastManger.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicToastDef.h"
@interface BasicToastManger : NSObject
{
    
}


+ (BasicToastManger*)Instance;

- (void)showToast:(NSString *)text;
- (void)showToast:(NSString *)text showTime:(BasicToastTime)time;
- (void)showToast:(NSString *)text font:(BasicToastFont)font;
- (void)showToast:(NSString *)text showTime:(BasicToastTime)time font:(BasicToastFont)font;

@end
