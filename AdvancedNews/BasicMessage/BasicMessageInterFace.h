//
//  BasicMessageInterFace.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMessageInterFace : NSObject

//在主线程发送消息，异步接收也在主线程(常用)
+ (void)fireMessageOnMainThread:(NSString *)messageId anexObj:(id)obj;

//在当前线程发送，同步接收也在当前线程
+ (void)fireMessageOnCurrentThread:(NSString *)messageId anexObj:(id)obj;

//绑定消息
+ (void)subMessage:(id)observer selector:(SEL)aSelector MessageID:(NSString *)messageId;

//解除绑定
+ (void)unSubMessage:(id)observer;

@end
