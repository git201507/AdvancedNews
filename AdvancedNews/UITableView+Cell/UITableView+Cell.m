//
//  UITableView+Cell.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "UITableView+Cell.h"

@implementation UITableView (Cell)

static char strNibKey = 'n';
- (UINib *)nib
{
    return objc_getAssociatedObject(self, &strNibKey);
}
- (void)setNib:(UINib *)nib
{
    objc_setAssociatedObject(self, &strNibKey, nib, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewCell *)makeCellByIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (UITableViewCell *)makeCellByNibName: (NSString *)nibName identifier:(NSString *) identifier
{
    if (!self.nib)
    {
        [self setNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]]];
        [self registerNib:self.nib forCellReuseIdentifier:identifier];
    }
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

@end
