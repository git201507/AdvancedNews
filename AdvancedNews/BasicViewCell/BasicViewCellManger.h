//
//  BasicViewCellManger.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicViewCellManger : BasicViewCell <UINavigationControllerDelegate>
{
@private
    __weak BasicViewCell *_rootViewCell;
}
@property (nonatomic, strong) NSArray *viewCells;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, weak) UIView *pushView;
@property (nonatomic, weak) BasicViewCell *rootViewCell;


- (void)pushViewCell:(BasicViewCell *)viewCell animated:(Class)BasicViewCellAdminClass;
- (void)popToViewCell:(BasicViewCell *)viewCell animated:(Class)BasicViewCellAdminClass;
- (void)popToLastViewCell:(Class)BasicViewCellAdminClass;
- (void)setViewCell:(NSArray *)viewCellArray animated:(Class)BasicViewCellAdminClass;
- (void)popToRootViewCell:(Class)BasicViewCellAdminClass;
//直接返回controll或者window
- (void)popToOriginal:(Class)BasicViewCellAdminClass;

//移除shapView
- (void)removeViewCellShapView:(UIViewController *)viewCon;
//从window迁移到BasicViewCell的迁移到ViewController
- (void)pushWindowViewCellToController:(UIViewController *)viewController admin:(BOOL)admin;
- (void)popControllerToLastWindowViewCell:(BOOL)admin;

@end
