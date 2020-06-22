//
//  BasicWindowManger.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BasicWindowLevel)
{
    BasicWINDOWLEVEL_LEVEL1 = 0,//最低级别的层次
    BasicWINDOWLEVEL_LEVEL2,
    BasicWINDOWLEVEL_LEVEL3,
    BasicWINDOWLEVEL_LEVEL4,
    
    //END层不可用，如添加级别在END之上添加
    BasicWINDOWLEVEL_END,
};

@interface BasicWindowManger : NSObject
{
@private
    NSArray *_levelArray;
}

+ (BasicWindowManger *) Instance;

//添加view到Window上，根据级别，级别越高显示在最上面
- (BOOL)addViewToWindow:(UIView *)view level:(BasicWindowLevel)level;

- (UIViewController *)getCurTopController;

- (UIWindow *)getMainWindow;


@end
