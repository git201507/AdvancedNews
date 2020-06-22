//
//  UserLogInView.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "UserLogInView.h"
#import "LoginManager.h"
#import "UIColor+Hex.h"
#import "BasicAccountLib.h"
#import "BasicToastInterFace.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicViewCellUPDownAdmin.h"
#import "BasicAccountLib.h"
#import "BasicDriver.h"
#import "BasicMessageInterFace.h"
#include "NUURL.h"

@interface UserLogInView ()
{
    NSString *_refreshToken;
    NSString *_accessToken;
}

@property (nonatomic, strong) UIActivityIndicatorView *act;
@end

@implementation UserLogInView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    [self initFace];
}

- (void)viewCellWillAppear
{
    [super viewCellWillAppear];
}

- (void)viewCellDidAppear
{
    [super viewCellDidAppear];
}

- (void)viewCellWillDisappear
{
    [super viewCellWillDisappear];
}

- (void)viewCellDidDisappear
{
    [super viewCellDidDisappear];
}

#pragma mark - 需要子类继承的


#pragma mark - 与XIB绑定事件
- (IBAction)registerNewUser:(id)sender
{
    [self endEditing:NO];
    BOOL isRight = [BasicAccountLib validateMobile:_username.text];
    if (!isRight)
    {
        [BasicToastInterFace showToast:@"用户名不正确"];
        return;
    }
    
    if([_password.text length] == 0)
    {
        [BasicToastInterFace showToast:@"密码不能为空"];
        return;
    }
    
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/3)];
        [self addSubview:_act];
    }
    [_act startAnimating];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:AppRegisterURL];
    
    //请求参数
    NSMutableDictionary *params = [@{@"telno":_username.text, @"password":@"1"} mutableCopy];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:_username.text, @"username", nil];
    
    
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [_act stopAnimating];
         NSLog(@"%@",respData);
         
         if (statusCode != 0)
         {
             _password.text = @"";
             return;
         }
         
         [BasicToastInterFace showToast:@"注册成功"];
         _password.text = @"";
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)back:(UIButton *)sender
{
    [self endEditing:NO];
    [self.viewCellManger popToLastViewCell:[BasicViewCellUPDownAdmin class]];
}

- (IBAction)login:(UIButton *)sender
{
    [self endEditing:NO];
    
    BOOL isRight = [BasicAccountLib validateMobile:_username.text];
    if (!isRight)
    {
        [BasicToastInterFace showToast:@"用户名不正确"];
        return;
    }
    
    if([_password.text length] == 0)
    {
        [BasicToastInterFace showToast:@"密码不能为空"];
        return;
    }
    
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/3)];
        [self addSubview:_act];
    }
    [_act startAnimating];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:AppLoginURL];
    
    //请求参数
    NSMutableDictionary *params = [@{@"username":_username.text} mutableCopy];
    
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [_act stopAnimating];
         NSLog(@"%@",respData);
         
         if (statusCode != 0)
         {
             return;
         }
         
         LogonUser *user = [[LogonUser alloc] init];
         
         if (![user setJsonDataWithDic:respData] || !user.data || (user.data.length == 0))
         {
             return;
         }
         
         UserProfile *userProfile = [[UserProfile alloc] init];
         
         userProfile.userName = _username.text;
         userProfile.password = _password.text;
         userProfile.token = user.data;
         
         NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
         if (standardUserDefaults)
         {
             [standardUserDefaults setObject:[userProfile getObjectData] forKey:@"LoginUserProfile"];
             [standardUserDefaults synchronize];
             
             [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
             [self back:nil];
             
             [BasicToastInterFace showToast:@"登录成功"];
         }
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}

#pragma mark - 自己的方法
- (void)initFace
{
    self.username.keyboardType = UIKeyboardTypeDecimalPad;
    self.username.returnKeyType = UIReturnKeyNext;
    self.password.keyboardType = UIKeyboardTypeASCIICapable;
    self.username.returnKeyType = UIReturnKeyDone;
    [self.username setValue:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    [self.username setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.password setValue:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    [_password setSecureTextEntry:YES];
    
    
    _username.layer.borderColor= [UIColor colorWithHexString:@"#ff9900"].CGColor;
    _username.layer.borderWidth= 1.0f;
    _username.layer.masksToBounds = YES;
    _username.layer.cornerRadius = 3.f;
    
    _password.layer.borderColor= [UIColor colorWithHexString:@"#ff9900"].CGColor;
    _password.layer.borderWidth= 1.0f;
    _password.layer.masksToBounds = YES;
    _password.layer.cornerRadius = 3.f;
    
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:46/255.0f green:194/255.0f blue:204/255.0f alpha:1]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}
#pragma mark - 消息方法

#pragma mark - 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        if ([textField isEqual:_username])
        {
            _username.restorationIdentifier = @"1";
            //将视图的Y坐标向上移动80个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = -80;
            self.mainViewBottomLayout.constant = 80;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
        else if ([textField isEqual:_password])
        {
            _password.restorationIdentifier = @"1";
            //将视图的Y坐标向上移动160个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = -160;
            self.mainViewBottomLayout.constant = 160;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        if ([textField isEqual:_username])
        {
            _username.restorationIdentifier = @"0";
            if ([_password.restorationIdentifier isEqualToString:@"1"])
            {
                return YES;
            }
            //将视图的Y坐标向上移动80个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = 0;
            self.mainViewBottomLayout.constant = 0;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
        else if ([textField isEqual:_password])
        {
            _password.restorationIdentifier = @"0";
            if ([_username.restorationIdentifier isEqualToString:@"1"])
            {
                return YES;
            }
            //将视图的Y坐标向下移动160个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = 0;
            self.mainViewBottomLayout.constant = 0;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
    }
    return YES;
}

#pragma mark task代理



@end
