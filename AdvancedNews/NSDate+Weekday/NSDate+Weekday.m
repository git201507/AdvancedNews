//
//  NSDate+Weekday.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "NSDate+Weekday.h"

#define Sunday (@"日")
#define Monday (@"一")
#define Tuesday (@"二")
#define Wednesday (@"三")
#define Thursday (@"四")
#define Friday (@"五")
#define Saturday (@"六")

@implementation NSDate (Weekday)

+ (NSString *)weekday:(NSDate *)date formatPrifix:(NSString *)preStr
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSArray * arrWeek=[NSArray arrayWithObjects: [NSString stringWithFormat:@"%@%@", preStr, Sunday], [NSString stringWithFormat:@"%@%@", preStr, Monday], [NSString stringWithFormat:@"%@%@", preStr, Tuesday], [NSString stringWithFormat:@"%@%@", preStr, Wednesday],[NSString stringWithFormat:@"%@%@", preStr, Thursday],[NSString stringWithFormat:@"%@%@", preStr, Friday], [NSString stringWithFormat:@"%@%@", preStr, Saturday], nil];
    return [arrWeek objectAtIndex:[comps weekday] - 1];
}

+ (NSInteger)getWeekdayIndex:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday];
}

@end
