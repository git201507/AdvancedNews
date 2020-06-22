//
//  BasicAccountDef.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicJsonKvcClass.h"

@interface MyAccountDetail : BasicJsonKvcClass

@property (nonatomic, assign) int availableAmount;//0
@property (nonatomic, assign) int couponAmount;//0
@property (nonatomic, assign) int financingAmount;//0
@property (nonatomic, assign) int freezeAmount;//0
@property (nonatomic, copy) NSString *ipsAccount;
@property (nonatomic, copy) NSString *memberLevel;//"level_3";
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int salaryAmount;//0
@property (nonatomic, assign) int totalAmount;//0
@property (nonatomic, assign) int totalIncomeAmount;//0
@property (nonatomic, assign) int vip;//0

@end

@interface MyAccountDetailReceiveInfo : BasicJsonKvcClass

@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) MyAccountDetail *data;
@property (nonatomic, strong) NSString *msg;

@end