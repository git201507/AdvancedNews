//
//  BasicAccount.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicAccount : NSObject
{
@private
    NSString *_accountName;//账户ID
    NSString *_accounPath;//账户路径
    NSString *_userPath;
    
}
@property (nonatomic, readonly) NSString *accountName;

//唤醒账户
- (BOOL)awakenAccountWithName:(NSString *)name;
//保存账户密码
- (BOOL)savePassWordWithName:(NSString *)accountName passWord:(NSString *)passWord;
//存储账户名
- (BOOL)saveUserNameWithAccountName:(NSString *)accountName userName:(NSString *)userName;
//储存token
- (BOOL)saveTokenWithAccountName:(NSString *)accountName token:(NSString *)token;
//储存附加信息
- (BOOL)saveAdditionalInfoWithAccountName:(NSString *)accountName additionalDic:(NSDictionary *)addInfo;
//关闭，注销账户
- (void)closeAccount;
//删除账户
- (void)deleteAccount;
//获取密码
- (NSString *)getPassWord;
//获取账号户名
- (NSString *)getUserName;
//获取token
- (NSString *)getTokenStr;
//获取附加信息
- (NSDictionary *)getAdditionalInfo;

//设置保存设置内容
- (BOOL)setSettingInfoWithKey:(NSString *)key val:(id)val;
//获取保存设置内容
- (instancetype)getSettingInfoWithKey:(NSString *)key;

//设置用户隐秘信息
- (BOOL)saveUserSecretInfoName:(NSString *)jsonStr key:(NSString *)key;
//获取用户隐秘信息
- (NSString *)getUserSecretInfoName:(NSString *)key;

//存储用户非隐秘信息，不加密
- (BOOL)setPublicUserInfo:(NSString *)jsonStr key:(NSString *)key;
//获取用户非隐秘信息
- (NSString *)getPublicUserInfo:(NSString *)key;


@end
