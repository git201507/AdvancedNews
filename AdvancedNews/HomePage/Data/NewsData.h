//
//  NewsData.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicJsonKvcClass.h"

@interface MessageBody : BasicJsonKvcClass

@property (nonatomic, strong) NSNumber *code;//id
@property (nonatomic, copy) NSString *message;

@end

@interface HotNews : BasicJsonKvcClass

@property (nonatomic, strong) NSString *uid;//id
@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, copy) NSString *title;   // 医保机构编码
@property (nonatomic, strong) NSString *newsno;
@property (nonatomic, copy) NSString *newsPaper;
@property (nonatomic, assign) long long createDatetime;

@end

@interface HotNewsReceiveInfo : BasicJsonKvcClass

@property (nonatomic, strong) MessageBody *status;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface CurrentDateReceiveInfo : BasicJsonKvcClass

@property (nonatomic, strong) MessageBody *status;
@property (nonatomic, strong) NSString *data;

@end

@interface NewsPaper : BasicJsonKvcClass

@property (nonatomic, strong) NSNumber *uid;//id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;   // 医保机构编码
@property (nonatomic, copy) NSString *publictime;

@end

@interface NewsPaperReceiveInfo : BasicJsonKvcClass

@property (nonatomic, strong) MessageBody *status;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface NewsRecord : BasicJsonKvcClass

@property (nonatomic, strong) NSString *uid;//id
@property (nonatomic, strong) NSString *newspaper;//报纸id
@property (nonatomic, copy) NSString *newsno;//"20160101"
@property (nonatomic, copy) NSString *newspage;//第01版
@property (nonatomic, copy) NSString *newstitle;//第01版:头版
@property (nonatomic, assign) long long createDatetime;
@property (nonatomic, strong) NSNumber *type;//"1"/"0"
@property (nonatomic, copy) NSString *order;//1
@property (nonatomic, copy) NSString *commentValue;//评论员文章

@end

@interface NewsRecordReceiveInfo : BasicJsonKvcClass

@property(nonatomic, strong) MessageBody *status;
@property(nonatomic, strong) NSMutableArray *data;

@end
