//
//  UITableView+Cell.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITableView (Cell)
@property(nonatomic, strong) UINib *nib;
- (UITableViewCell *)makeCellByIdentifier: (NSString *)identifier;
- (UITableViewCell *)makeCellByNibName: (NSString *)nibName identifier:(NSString *) identifier;
@end
