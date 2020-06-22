//
//  BasicDriver.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicDriver.h"
#import <UIKit/UIKit.h>
#import "BasicMessageCenter.h"
#import  <CoreTelephony/CTCarrier.h>
#import  <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface BasicDriver ()


@property (nonatomic, strong) CTCarrier *carrier;

@end

@implementation BasicDriver

+ (BasicDriver*)Instance
{
    static BasicDriver *obj = nil;
    @synchronized([BasicDriver class])
    {
        if (obj == nil)
        {
            obj = [[BasicDriver alloc] init];
        }
        
    }
    return obj;
}

- (instancetype)init
{
    id obj = [super init];
    
    if (obj)
    {
        [self getProprietorInfo];
    }
    
    return obj;
}

- (void)driverStart
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoradChange:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSValue *val = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyRect = CGRectZero;
    [val getValue:&keyRect];
    
    _curKeyBoradRect = keyRect;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [BasicMessageCenter fireMessage:NSSFOUNDATIONKEYBORADCHANGE_MAINTREAD anexObj:nil];
    });
}

- (CGRect)getkeyBoradRect
{
    return _curKeyBoradRect;
}

//获取运营商
- (void)getProprietorInfo
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrierInfo = info.subscriberCellularProvider;
    
    self.carrier = carrierInfo;
    
    info.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier){
        
        [BasicDriver Instance].carrier = carrier;
    };
}


+ (CGRect)getCurKeyBoradRect
{
    return [[BasicDriver Instance] getkeyBoradRect];
}

+ (PhoneScreen)getPhoneScreenType
{
    PhoneScreen type = PHONESCREEN_4;
    if (iPhone5)
    {
        type = PHONESCREEN_5;
    }
    else if (iPhone6)
    {
        type = PHONESCREEN_6;
    }
    else if (iPhone6Plus)
    {
        type = PHONESCREEN_6Pluse;
    }
    
    return type;
}

+ (PhoneSysVersion)getPhoneSysVersion
{
    PhoneSysVersion rlt = PHONESYSVERSIONBELOW_IOS7;
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    int val = (int)version;
    if (val >= 8)
    {
        rlt = PHONESYSVERSIONOVER_IOS8;
    }
    else if (val >= 7)
    {
        rlt = PHONESYSVERSIONOVER_IOS7;
    }
    
    return rlt;
}

+ (NSString *)getDriveMachine
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

+ (NSString *)getOSInfo
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getProprietorName
{
    return [BasicDriver Instance].carrier.carrierName;
}

+ (NSString *)getPrioruetirCode
{
    return [BasicDriver Instance].carrier.mobileNetworkCode;
}

+ (void)telCall:(NSString *)phoneNum
{
    if (phoneNum && [phoneNum length] > 0)
    {
        NSString *str = [NSString stringWithFormat:@"tel://%@", phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://12333"]];
    }
    
}
@end
