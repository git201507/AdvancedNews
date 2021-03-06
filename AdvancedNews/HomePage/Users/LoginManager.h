//
//  LoginManager.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "UserLogInView.h"

@interface LoginManager : NSObject
{
    UserLogInView *_loginView;
}

+ (LoginManager *)instance;

- (BOOL)checkLoginState;

- (void)doLogin;
- (void)doLogoff;

@end
