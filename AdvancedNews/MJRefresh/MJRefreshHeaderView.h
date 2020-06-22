//
//  MJRefreshHeaderView.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//  下拉刷新

#import "MJRefreshBaseView.h"

@interface MJRefreshHeaderView : MJRefreshBaseView

@property (nonatomic, copy) NSString *dateKey;
+ (instancetype)header;

@end