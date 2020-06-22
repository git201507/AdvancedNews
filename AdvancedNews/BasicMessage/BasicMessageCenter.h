//
//  BasicMessageCenter.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BasicMessageCenter : NSObject

+ (void)fireMessage:(NSString *)messageId anexObj:(id)obj;

+ (void)subMessage:(id)observer selector:(SEL)aSelector name:(NSString *)aName;

+ (void)unSubMessage:(id)observer;

@end
