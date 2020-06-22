//
//  UIWindow+NSSViewCell.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewCellManger.h"

@interface UIWindow (NSSViewCell)

- (BasicViewCellManger *)addViewCellToManger:(BasicViewCell *)ViewCell animated:(Class)NSSViewCellAdminClass;

@end
