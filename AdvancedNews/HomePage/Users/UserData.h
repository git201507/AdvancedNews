//
//  UserData
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicJsonKvcClass.h"
#import "NewsData.h"


#define NSSUSERACCOUNTCHANGEDMESSAGE_MainThread (@"NSSUserAccountChangedMessage")  //账户改变发送的消息

@interface UserProfile : BasicJsonKvcClass

@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *token;

@end

@interface RegistUser : BasicJsonKvcClass

@property(nonatomic, strong) NSString *telno;
@property(nonatomic, strong) NSString *password;
//@property(nonatomic, strong) NSString *username;

@end

@interface LogonUser : BasicJsonKvcClass

@property(nonatomic, strong) MessageBody *status;
@property(nonatomic, strong) NSString *data;

@end

@interface LogonObject : BasicJsonKvcClass

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;

@end