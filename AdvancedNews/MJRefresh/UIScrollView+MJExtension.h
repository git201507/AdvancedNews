//
//  UIScrollView+Extension.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MJExtension)
@property (assign, nonatomic) CGFloat mj_contentInsetTop;
@property (assign, nonatomic) CGFloat mj_contentInsetBottom;
@property (assign, nonatomic) CGFloat mj_contentInsetLeft;
@property (assign, nonatomic) CGFloat mj_contentInsetRight;

@property (assign, nonatomic) CGFloat mj_contentOffsetX;
@property (assign, nonatomic) CGFloat mj_contentOffsetY;

@property (assign, nonatomic) CGFloat mj_contentSizeWidth;
@property (assign, nonatomic) CGFloat mj_contentSizeHeight;
@end
