//
//  NUURL.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#ifndef NUURL_h
#define NUURL_h

#define Network_NotReachable        (@"网络正在开小差，请先连接网络！")
#define Network_Instability         (@"网络不稳定，请稍候再试！")
#define Network_LoninExpired        (@"登录已过期，请重新登录！")
#define Network_URLNotFound         (@"没有找到URL地址对应的接口！")
#define Network_URLSpeelError       (@"URL地址拼写错误！")
#define Network_OtherError          (@"其他的网络问题！")
#define Network_UnknownError        (@"未知的网络问题！")

#pragma mark - 报纸新闻
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//获取我的收藏列表
#define GetFavorListURL(token) ([NSString stringWithFormat:@"viewnew/getcollection.do?xx-token=%@", token])

//获取系统当前日期
#define GetSystemDateURL (@"viewnew/getCurrDate.do")

//获取头版头条
#define GetNewsHeadURL(date) ([NSString stringWithFormat:@"viewnew/getNewsHead.do?newsno=%@", date])

//获取所有报纸
#define GetAllNewsPaperURL (@"viewnew/getNewsPaper.do")

//增加收藏
#define AddFavorURL(paper, token) ([NSString stringWithFormat:@"viewnew/collection.do?id=%@&xx-token=%@", paper, token])

//获取报纸内容
#define GetNewsContentURL(uid) ([NSString stringWithFormat:@"viewnew/getNewContent.do?id=%@", uid])

//获取报纸新闻列表
#define GetNewsListURL(date, paperid) ([NSString stringWithFormat:@"viewnew/getnews.do?newsno=%@&newspaper=%d", date, paperid])

//登录
#define AppLoginURL (@"viewnew/appLogin.do")

//注册
#define AppRegisterURL (@"viewnew/register.do")

#define TipDocumentURL (@"viewnew/getHelp.do")

////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#endif /* NUURL_h */





