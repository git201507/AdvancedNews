//
//  BasicAccount.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicAccount.h"
#import "BasicAccountLib.h"
#import "BasicEncryPtionAES.h"
#import "BasicEncryPtionInterFace.h"

//文件的名
#define PERSONINF   (@"PersonInfo")
#define SETTING     (@"Setting")
#define USERSECRET (@"UserSecretInfo") //用户隐秘信息
#define USERPUBLIC (@"UserPublicInfo") //用户非隐秘信息

//PERSONINF中的两个key
#define USERINFOKEY (@"UserInfoKey")
#define ACCOUNTKEY  (@"AccountInfoKey")


//ACCOUNTKEY中的key
#define ACCOUNTNAMEKEY  (@"AccountName")//账户ID
#define ACCOUNTUSERNAMEKEY  (@"AccountUserName")//用户名
#define ACCOUNTTOKENKEY  (@"AccountToken")//token
#define ACCOUNTADDITIONALINFOKEY  (@"AccountAdditionalInfo")//AdditionalInfo
#define ACCOUNTPASSWORDKEY  (@"AccountPassWord")


#define AESPASSWORDKEY (@"TQWEKKLJCAONYLIS")

@implementation BasicAccount
@synthesize accountName = _accountName;

-(void)dealloc
{
    
}

- (NSString *)getUserPath
{
    BOOL rlt = NO;
    if (!_accounPath)
    {
        _accounPath = [BasicAccountLib getAccountPath];
    }
    
    NSString *userPath = [NSString stringWithFormat:@"%@%@/User", _accounPath, _accountName];
    
    rlt = [BasicAccountLib createFolder:userPath];
    
    return userPath;
}

- (BOOL)modifyPersonInfoFile:(NSDictionary *)dic
{
    BOOL rlt = NO;
    NSString *userPath = _userPath;
    
    if (userPath && dic)
    {
        NSString *personPath = [NSString stringWithFormat:@"%@/%@", userPath, PERSONINF];
        rlt = [dic writeToFile:personPath atomically:YES];
    }
    
    return rlt;
}

- (BOOL)modifyPersonSecretInfoFile:(NSDictionary *)dic
{
    BOOL rlt = NO;
    NSString *userPath = _userPath;
    
    if (userPath && dic)
    {
        NSString *personPath = [NSString stringWithFormat:@"%@/%@", userPath, USERSECRET];
        rlt = [dic writeToFile:personPath atomically:YES];
    }
    
    return rlt;
}

- (BOOL)modifyPersonPublicInfoFile:(NSDictionary *)dic
{
    BOOL rlt = NO;
    NSString *userPath = _userPath;
    
    if (userPath && dic)
    {
        NSString *personPath = [NSString stringWithFormat:@"%@/%@", userPath, USERPUBLIC];
        rlt = [dic writeToFile:personPath atomically:YES];
    }
    
    return rlt;
}

- (BOOL)modifySettingInfoFile:(NSDictionary *)dic
{
    BOOL rlt = NO;
    NSString *userPath = _userPath;
    
    if (userPath && dic)
    {
        NSString *settingPath = [NSString stringWithFormat:@"%@/%@", userPath, SETTING];
        rlt = [dic writeToFile:settingPath atomically:YES];
    }
    
    return rlt;
}

- (NSDictionary *)getPersonInfoFileInfo
{
    NSDictionary *dic = nil;
    NSString *userPath = _userPath;
    
    if (userPath)
    {
        NSString *personPath = [NSString stringWithFormat:@"%@/%@", userPath, PERSONINF];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:personPath];
    }
    
    return dic;
}

- (NSDictionary *)getPersonSecretInfoFileInfo
{
    NSDictionary *dic = nil;
    NSString *userPath = _userPath;
    
    if (userPath)
    {
        NSString *personPath = [NSString stringWithFormat:@"%@/%@", userPath, USERSECRET];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:personPath];
    }
    
    return dic;
}

- (NSDictionary *)getPersonPublicInfoFileInfo
{
    NSDictionary *dic = nil;
    NSString *userPath = _userPath;
    
    if (userPath)
    {
        NSString *personPath = [NSString stringWithFormat:@"%@/%@", userPath, USERPUBLIC];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:personPath];
    }
    
    return dic;
}

- (NSDictionary *)getSettingInfo
{
    NSDictionary *dic = nil;
    NSString *userPath = _userPath;
    
    if (userPath)
    {
        NSString *settingPath = [NSString stringWithFormat:@"%@/%@", userPath, SETTING];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:settingPath];
    }
    
    return dic;
}

- (BOOL)setSettingInfoWithKey:(NSString *)key val:(id)val
{
    NSDictionary * dic = [self getSettingInfo];
    
    NSMutableDictionary *saveDic = nil;
    if (dic)
    {
        saveDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [saveDic setValue:val forKey:key];
    }
    else
    {
        saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:val, key, nil];
    }
    
    BOOL rlt = [self modifySettingInfoFile:saveDic];
    
    return rlt;
}

- (instancetype)getSettingInfoWithKey:(NSString *)key
{
    NSDictionary * dic = [self getSettingInfo];
    
    id val = [dic valueForKey:key];
    
    return val;
}

- (BOOL)savePassWordWithName:(NSString *)accountName passWord:(NSString *)passWord
{
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    NSMutableDictionary *personDic = nil;
    NSData *passWordData = [passWord dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [BasicEncryPtionInterFace AESEncryptWithKey:AESPASSWORDKEY sourceData:passWordData];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:accountName, ACCOUNTNAMEKEY, encryData, ACCOUNTPASSWORDKEY, nil];
    if (infoDic)
    {
        personDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        NSMutableDictionary *addDic = [infoDic valueForKey:ACCOUNTKEY];
        if (addDic)
        {
            for (int i = 0; i < [[dic allKeys] count]; i++)
            {
                NSString *key = [[dic allKeys] objectAtIndex:i];
                [addDic setObject:[dic valueForKey:key] forKey:key];
            }
            [personDic setObject:addDic forKey:ACCOUNTKEY];
        }
        else
        {
            [personDic setObject:dic forKey:ACCOUNTKEY];
        }
        
    }
    else
    {
        personDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic, ACCOUNTKEY, nil];
    }
    
    BOOL rlt = [self modifyPersonInfoFile:personDic];
    
    return rlt;
}

- (BOOL)saveUserNameWithAccountName:(NSString *)accountName userName:(NSString *)userName
{
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    NSMutableDictionary *personDic = nil;
    NSData *userNameData = [userName dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [BasicEncryPtionInterFace AESEncryptWithKey:AESPASSWORDKEY sourceData:userNameData];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:accountName, ACCOUNTNAMEKEY, encryData, ACCOUNTUSERNAMEKEY, nil];
    if (infoDic)
    {
        personDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        NSMutableDictionary *addDic = [infoDic valueForKey:ACCOUNTKEY];
        if (addDic)
        {
            for (int i = 0; i < [[dic allKeys] count]; i++)
            {
                NSString *key = [[dic allKeys] objectAtIndex:i];
                [addDic setObject:[dic valueForKey:key] forKey:key];
            }
            [personDic setObject:addDic forKey:ACCOUNTKEY];
        }
        else
        {
            [personDic setObject:dic forKey:ACCOUNTKEY];
        }
    }
    else
    {
        personDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic, ACCOUNTKEY, nil];
    }
    
    BOOL rlt = [self modifyPersonInfoFile:personDic];
    
    return rlt;
}

- (BOOL)saveTokenWithAccountName:(NSString *)accountName token:(NSString *)token
{
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    NSMutableDictionary *personDic = nil;
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [BasicEncryPtionInterFace AESEncryptWithKey:AESPASSWORDKEY sourceData:tokenData];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:accountName, ACCOUNTNAMEKEY, encryData, ACCOUNTTOKENKEY, nil];
    if (infoDic)
    {
        personDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        NSMutableDictionary *addDic = [infoDic valueForKey:ACCOUNTKEY];
        if (addDic)
        {
            for (int i = 0; i < [[dic allKeys] count]; i++)
            {
                NSString *key = [[dic allKeys] objectAtIndex:i];
                [addDic setObject:[dic valueForKey:key] forKey:key];
            }
            [personDic setObject:addDic forKey:ACCOUNTKEY];
        }
        else
        {
            [personDic setObject:dic forKey:ACCOUNTKEY];
        }
    }
    else
    {
        personDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic, ACCOUNTKEY, nil];
    }
    
    BOOL rlt = [self modifyPersonInfoFile:personDic];
    
    return rlt;
}

//储存附加信息
- (BOOL)saveAdditionalInfoWithAccountName:(NSString *)accountName additionalDic:(NSDictionary *)addInfo
{
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    NSMutableDictionary *personDic = nil;
    NSData *addData = [NSJSONSerialization dataWithJSONObject:addInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *encryData = [BasicEncryPtionInterFace AESEncryptWithKey:AESPASSWORDKEY sourceData:addData];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:accountName, ACCOUNTNAMEKEY, encryData, ACCOUNTADDITIONALINFOKEY, nil];
    if (infoDic)
    {
        personDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        NSMutableDictionary *addDic = [infoDic valueForKey:ACCOUNTKEY];
        if (addDic)
        {
            for (int i = 0; i < [[dic allKeys] count]; i++)
            {
                NSString *key = [[dic allKeys] objectAtIndex:i];
                [addDic setObject:[dic valueForKey:key] forKey:key];
            }
            [personDic setObject:addDic forKey:ACCOUNTKEY];
        }
        else
        {
            [personDic setObject:dic forKey:ACCOUNTKEY];
        }
    }
    else
    {
        personDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic, ACCOUNTKEY, nil];
    }
    
    BOOL rlt = [self modifyPersonInfoFile:personDic];
    
    return rlt;
}

- (NSString *)getPassWord
{
    NSString *passWordStr = nil;
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    if (infoDic)
    {
        NSDictionary * dic = [infoDic valueForKey:ACCOUNTKEY];
        NSData *passWordData = [dic valueForKey:ACCOUNTPASSWORDKEY];
        NSData *dencryData = [BasicEncryPtionInterFace AESDecryptWithKey:AESPASSWORDKEY sourceData:passWordData];
        passWordStr = [[NSString alloc] initWithData:dencryData encoding:NSUTF8StringEncoding];
    }
    
    return passWordStr;
}

- (NSString *)getUserName
{
    NSString *userNameStr = nil;
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    if (infoDic)
    {
        NSDictionary * dic = [infoDic valueForKey:ACCOUNTKEY];
        NSData *userNameData = [dic valueForKey:ACCOUNTUSERNAMEKEY];
        NSData *dencryData = [BasicEncryPtionInterFace AESDecryptWithKey:AESPASSWORDKEY sourceData:userNameData];
        userNameStr = [[NSString alloc] initWithData:dencryData encoding:NSUTF8StringEncoding];
    }
    
    return userNameStr;
}

- (NSString *)getTokenStr
{
    NSString *tokenStr = nil;
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    if (infoDic)
    {
        NSDictionary * dic = [infoDic valueForKey:ACCOUNTKEY];
        NSData *tokenData = [dic valueForKey:ACCOUNTTOKENKEY];
        NSData *dencryData = [BasicEncryPtionInterFace AESDecryptWithKey:AESPASSWORDKEY sourceData:tokenData];
        tokenStr = [[NSString alloc] initWithData:dencryData encoding:NSUTF8StringEncoding];
    }
    
    return tokenStr;
}

- (NSDictionary *)getAdditionalInfo
{
    NSDictionary *addInfo = nil;
    NSDictionary *infoDic = [self getPersonInfoFileInfo];
    
    if (infoDic)
    {
        NSDictionary * dic = [infoDic valueForKey:ACCOUNTKEY];
        NSData *dicData = [dic valueForKey:ACCOUNTADDITIONALINFOKEY];
        NSData *dencryData = [BasicEncryPtionInterFace AESDecryptWithKey:AESPASSWORDKEY sourceData:dicData];
        addInfo = [NSJSONSerialization JSONObjectWithData:dencryData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return addInfo;
}

//设置用户隐秘信息
- (BOOL)saveUserSecretInfoName:(NSString *)jsonStr key:(NSString *)key
{
    NSDictionary *infoDic = [self getPersonSecretInfoFileInfo];
    
    NSMutableDictionary *personDic = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryData = [BasicEncryPtionInterFace AESEncryptWithKey:AESPASSWORDKEY sourceData:jsonData];
    if (infoDic)
    {
        personDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        [personDic setObject:encryData forKey:key];
    }
    else
    {
        personDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:encryData, key, nil];
    }
    
    BOOL rlt = [self modifyPersonSecretInfoFile:personDic];
    
    return rlt;
}
//获取用户隐秘信息
- (NSString *)getUserSecretInfoName:(NSString *)key
{
    NSString *rltStr = nil;
    NSDictionary *infoDic = [self getPersonSecretInfoFileInfo];
    
    if (infoDic)
    {
        NSData *rltData = [infoDic valueForKey:key];
        NSData *dencryData = [BasicEncryPtionInterFace AESDecryptWithKey:AESPASSWORDKEY sourceData:rltData];
        rltStr = [[NSString alloc] initWithData:dencryData encoding:NSUTF8StringEncoding];
    }
    
    return rltStr;
}

//存储用户非隐秘信息，不加密
- (BOOL)setPublicUserInfo:(NSString *)jsonStr key:(NSString *)key
{
    NSDictionary * dic = [self getPersonPublicInfoFileInfo];
    
    NSMutableDictionary *saveDic = nil;
    if (dic)
    {
        saveDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [saveDic setValue:jsonStr forKey:key];
    }
    else
    {
        saveDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonStr, key, nil];
    }
    
    BOOL rlt = [self modifyPersonPublicInfoFile:saveDic];
    
    return rlt;
}

//获取用户非隐秘信息
- (NSString *)getPublicUserInfo:(NSString *)key
{
    NSDictionary * dic = [self getPersonPublicInfoFileInfo];
    
    id val = [dic valueForKey:key];
    
    return val;
}

- (BOOL)awakenAccountWithName:(NSString *)name
{
    BOOL rlt = YES;
    
    _accountName = name;
    
    if (!_accounPath)
    {
        _accounPath = [BasicAccountLib getAccountPath];
    }
    
    if (!_userPath)
    {
        _userPath = [self getUserPath];
    }
    
    
    return rlt;
}

- (void)closeAccount
{
    
}

- (void)deleteAccount
{
    [BasicAccountLib removeFolder:_userPath];
}

#pragma mark - 获取往账户里存的相关类



@end
