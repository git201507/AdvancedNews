//
//  DropDownListView.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"

#define SECTION_BTN_TAG_BEGIN   1000
#define SECTION_IV_TAG_BEGIN    3000
@interface DropDownListView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentExtendSection;     //当前展开的section ，默认－1时，表示都没有展开
}

@property (nonatomic, assign) id<DropDownChooseDelegate> dropDownDelegate;
@property (nonatomic, assign) id<DropDownChooseDataSource> dropDownDataSource;

@property (nonatomic, strong) UIView *mSuperView;
@property (nonatomic, strong) UIView *mTableBaseView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIColor *colorForCell;

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate;
- (void)setTitle:(NSString *)title inSection:(NSInteger) section;
- (void)setCellColor:(UIColor *)backgroundColor;
- (void)setTitleColor:(UIColor *)color inSection:(NSInteger) section;
- (BOOL)isShow;
- (void)hideExtendedChooseView;
- (void)sectionBtnTouch:(UIButton *)btn;
- (void)sectionBtnTouch:(UIButton *)btn displayView:(UIView *)objView;

@end
