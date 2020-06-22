//
//  NSDate+Weekday.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Weekday)

//preStr:(1)-"周"；
//       (2)-"星期"
+ (NSString *)weekday:(NSDate *)date formatPrifix:(NSString *)preStr;

//return:1-"星期日"
//       2-"星期一"
//       3-"星期二"
//       4-"星期三"
//       5-"星期四"
//       6-"星期五"
//       7-"星期六"
+ (NSInteger)getWeekdayIndex:(NSDate *)date;
@end
