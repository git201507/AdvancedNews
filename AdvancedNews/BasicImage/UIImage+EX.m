//
//  UIImage+EX.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "UIImage+EX.h"

@implementation UIImage (EX)

+ (UIImage *)resizableImageWithAll:(UIImage *)originalImage
{
    UIEdgeInsets insets = UIEdgeInsetsMake((originalImage.size.width / 2) - 1, (originalImage.size.width / 2) - 1, (originalImage.size.width / 2) + 1, (originalImage.size.width / 2) + 1);
    UIImage *newImage = [originalImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return newImage;
}

@end