//
//  UIWindow+NSSViewCell.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "UIWindow+NSSViewCell.h"
#import "BasicWindowInterFace.h"

@implementation UIWindow (BasicViewCell)

- (BasicViewCellManger *)addViewCellToManger:(BasicViewCell *)ViewCell animated:(Class)BasicViewCellAdminClass
{
    BasicViewCellManger *cellManger = nil;
    
    if (ViewCell)
    {
        cellManger = [[BasicViewCellManger alloc] init];
        cellManger.window = self;
        cellManger.frame = self.bounds;
        [BasicWindowInterFace addViewToWindow:cellManger level:BasicWINDOWLEVEL_LEVEL2];
        [cellManger pushViewCell:ViewCell animated:BasicViewCellAdminClass];
    }
    
    return cellManger;
}



@end
