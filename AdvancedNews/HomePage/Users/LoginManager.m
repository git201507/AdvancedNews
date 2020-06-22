//
//  LoginManager.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//
#import "LoginManager.h"
#import "BasicViewCellUPDownAdmin.h"
#import "UIWindow+NSSViewCell.h"
#import "BasicMessageInterFace.h"
#import "BasicToastInterFace.h"

@interface LoginManager ()
{
    
}
@end

@implementation LoginManager

+ (LoginManager *)instance
{
    static LoginManager *obj = nil;
    @synchronized([LoginManager class])
    {
        if (obj == nil)
        {
            obj = [[LoginManager alloc] init];
        }
    }
    return obj;
}

- (BOOL)checkLoginState
{
    UserProfile *currentUser = [[UserProfile alloc] init];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSDictionary *dicData = (NSDictionary *)[standardUserDefaults objectForKey:@"LoginUserProfile"];
        
        if (!dicData)
        {
            return NO;
        }
        
        if(![currentUser setJsonDataWithDic:dicData])
        {
            return NO;
        }
        
        if (!currentUser.token || [currentUser.token length] == 0)
        {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)doLogin
{
    if (!_loginView)
    {
        _loginView = [[[NSBundle mainBundle] loadNibNamed:@"UserLogin" owner:self options:nil] lastObject];
    }
    
    _loginView.password.text = @"";
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addViewCellToManger:_loginView animated:[BasicViewCellUPDownAdmin class]];
}

- (void)doLogoff
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        UserProfile *currentUser = [[UserProfile alloc] init];
        
        currentUser.userName = @"public";
        currentUser.password = @"";
        currentUser.token = @"";
        
        NSDictionary *dicData = [currentUser getObjectData];
        
        [standardUserDefaults setObject:dicData forKey:@"LoginUserProfile"];
        [standardUserDefaults synchronize];
        
        [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
        
        [BasicToastInterFace showToast:@"退出登录成功"];
    }
}

@end
