//
//  BasicViewCellManger.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "BasicViewCellManger.h"
#import "BasicViewCellAdmin.h"

@interface ViewCellShapView : UIView

@end

@implementation ViewCellShapView

@end

@implementation BasicViewCellManger
@synthesize rootViewCell = _rootViewCell;

- (void)dealloc
{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

- (NSArray *)viewCells
{
    return [self subviews];
}

- (void)addSubview:(UIView *)view
{
    if ([view isKindOfClass:[BasicViewCell class]])
    {
        ((BasicViewCell *)view).viewCellManger = self;
        [super addSubview:view];
    }
}

- (BasicViewCell *)getLastView:(BasicViewCell *)viewCell
{
    BasicViewCell *lastView = nil;
    if (viewCell)
    {
        NSArray *array = [self subviews];
        NSUInteger index = [array indexOfObject:viewCell];
        
        if (index > 0)
        {
            lastView = [array objectAtIndex:index - 1];
        }
    }
    
    return lastView;
}

- (void)lastViewWillAppear:(BasicViewCell *)viewCell
{
    if (viewCell)
    {
        BasicViewCell *cell = [self getLastView:viewCell];
        
        if (cell)
        {
            [cell viewCellWillAppear];
        }
    }
    
}

- (void)lastViewDidAppear:(BasicViewCell *)viewCell
{
    if (viewCell)
    {
        BasicViewCell *cell = [self getLastView:viewCell];
        
        if (cell)
        {
            [cell viewCellDidAppear];
        }
    }
}

- (void)lastViewWillDisAppear:(BasicViewCell *)viewCell
{
    if (viewCell)
    {
        BasicViewCell *cell = [self getLastView:viewCell];
        
        if (cell)
        {
            [cell viewCellWillDisappear];
        }
    }
}

- (void)lastViewDidDisAppear:(BasicViewCell *)viewCell
{
    if (viewCell)
    {
        BasicViewCell *cell = [self getLastView:viewCell];
        
        if (cell)
        {
            [cell viewCellDidDisappear];
        }
    }
}

- (void)doRemoveView:(BasicViewCell *)viewCell
{
    [viewCell viewCellDidDisappear];
    [self lastViewDidAppear:viewCell];
    [viewCell removeFromSuperview];
    
    if ([[self subviews] count] == 0)
    {
        [self removeFromSuperview];
    }
}

- (void)animationDidStop:(BasicViewCell *)viewCell
{
    [self doRemoveView:viewCell];
}

- (void)animationPushDidStop:(BasicViewCell *)viewCell
{
    [viewCell viewCellDidAppear];
    [self lastViewDidDisAppear:viewCell];
}

- (void)pushViewCell:(BasicViewCell *)viewCell animated:(Class)BasicViewCellAdminClass
{
    if (viewCell)
    {
        if ([[self subviews] count] == 0)
        {
            self.rootViewCell = viewCell;
        }
        
        viewCell.frame = self.frame;
        
        [self addSubview:viewCell];
        [viewCell viewCellWillAppear];
        [self lastViewWillDisAppear:viewCell];
        
        if (BasicViewCellAdminClass)
        {
            BasicViewCellAdmin *adminObj = [[BasicViewCellAdminClass alloc] init];
            [adminObj pushAdmin:self pushViewCell:viewCell doneAdmin:@selector(animationPushDidStop:)];
        }
        else
        {
            [viewCell viewCellDidAppear];
            [self lastViewDidDisAppear:viewCell];
        }
    }
}

- (void)popToViewCell:(BasicViewCell *)viewCell animated:(Class)BasicViewCellAdminClass
{
    if (viewCell && [[self subviews] count] > 0)
    {
        BasicViewCell *lastView = [[self subviews] lastObject];;
        BOOL isIn = NO;
        for (int i = [[self subviews] count] - 1; i >= 0; i--)
        {
            BasicViewCell *view = [[self subviews] objectAtIndex:i];
            
            if (viewCell == view)
            {
                isIn = YES;
                break;
            }
        }
        
        if (lastView && isIn)
        {
            while ([[self subviews] count] > 0)
            {
                BasicViewCell *view = [[self subviews] lastObject];
                
                if (view != viewCell)
                {
                    [view removeFromSuperview];
                }
                else
                {
                    break;
                }
            }
            
            //动画
            if (BasicViewCellAdminClass)
            {
                [self addSubview:lastView];
                [lastView viewCellWillDisappear];
                [self lastViewWillAppear:lastView];
                BasicViewCellAdmin *adminObj = [[BasicViewCellAdminClass alloc] init];
                [adminObj popAdmin:self pushViewCell:lastView doneAdmin:@selector(animationDidStop:)];
            }
            else
            {
                BasicViewCell *view = [[self subviews] lastObject];
                [lastView viewCellDidDisappear];
                [view viewCellDidAppear];
            }
        }
        
    }
}

- (void)popToLastViewCell:(Class)BasicViewCellAdminClass
{
    if ([[self subviews] count] > 0)
    {
        BasicViewCell *view = [[self subviews] lastObject];
        [view viewCellWillDisappear];
        [self lastViewWillAppear:view];
        //动画
        if (BasicViewCellAdminClass)
        {
            BasicViewCellAdmin *adminObj = [[BasicViewCellAdminClass alloc] init];
            [adminObj popAdmin:self pushViewCell:view doneAdmin:@selector(animationDidStop:)];
        }
        else
        {
            [self doRemoveView:view];
        }
        
    }
}

- (void)popToRootViewCell:(Class)BasicViewCellAdminClass
{
    if ([[self subviews] count] <= 1)
    {
        return;
    }
    
    BasicViewCell *viewCell = [[self subviews] lastObject];
    
    while ([[self subviews] count] > 1)
    {
        BasicViewCell *view = [[self subviews] lastObject];
        
        [view removeFromSuperview];
    }
    
    if ([[self subviews] count] == 1)
    {
        //动画
        if (BasicViewCellAdminClass)
        {
            [self addSubview:viewCell];
            
            [viewCell viewCellWillDisappear];
            [self lastViewWillAppear:viewCell];
            BasicViewCellAdmin *adminObj = [[BasicViewCellAdminClass alloc] init];
            [adminObj popAdmin:self pushViewCell:viewCell doneAdmin:@selector(animationDidStop:)];
        }
        else
        {
            BasicViewCell *view = [[self subviews] lastObject];
            [viewCell viewCellDidDisappear];
            [view viewCellDidAppear];
        }
    }
}

- (void)setViewCell:(NSArray *)viewCellArray animated:(Class)BasicViewCellAdminClass
{
    BasicViewCell *viewCell = [[self subviews] lastObject];
    
    while ([[self subviews] count] > 0)
    {
        BasicViewCell *view = [[self subviews] lastObject];
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [viewCellArray count]; i++)
    {
        BasicViewCell *view = [viewCellArray objectAtIndex:i];
        if (view)
        {
            view.frame = self.frame;
            [self addSubview:view];
        }
    }
    [self addSubview:viewCell];
    
    [self popToLastViewCell:BasicViewCellAdminClass];
}

- (void)popToOriginal:(Class)BasicViewCellAdminClass
{
    if ([[self subviews] count] > 0)
    {
        BasicViewCell *view = [[self subviews] lastObject];
        
        while ([[self subviews] count] > 0)
        {
            BasicViewCell *view = [[self subviews] lastObject];
            
            [view removeFromSuperview];
        }
        
        [self addSubview:view];
        
        [self popToLastViewCell:BasicViewCellAdminClass];
    }
}

//从window迁移到BasicViewCell的迁移到ViewController
- (void)pushWindowViewCellToController:(UIViewController *)viewController admin:(BOOL)admin
{
    UIWindow *window = self.window;
    UINavigationController *naviController = (UINavigationController *)window.rootViewController;
    
    UIView *view = [[self.viewCells lastObject] snapshotViewAfterScreenUpdates:NO];
    
    ViewCellShapView *shapView = [[ViewCellShapView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    [shapView addSubview:view];
    shapView.userInteractionEnabled = YES;
    
    [naviController.topViewController.view addSubview:shapView];
    
    self.hidden = YES;
    
    [naviController pushViewController:viewController animated:admin];
    
}

- (void)popControllerToLastWindowViewCell:(BOOL)admin
{
    UIWindow *window = self.window;
    UINavigationController *naviController = (UINavigationController *)window.rootViewController;
    
    naviController.delegate = self;
    
    [naviController popViewControllerAnimated:admin];
    
}

- (void)removeViewCellShapView:(UIViewController *)viewCon
{
    NSArray *viewArray = viewCon.view.subviews;
    for (int i = 0; i < [viewArray count]; i++)
    {
        UIView * view = [viewArray objectAtIndex:i];
        if ([view isKindOfClass:[ViewCellShapView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.isHidden)
    {
        UIWindow *window = self.window;
        UINavigationController *naviController = (UINavigationController *)window.rootViewController;
        
        naviController.delegate = nil;
        
        self.hidden = NO;
        
        [self removeViewCellShapView:naviController.topViewController];
    }
}


@end
