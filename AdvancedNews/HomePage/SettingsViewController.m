//
//  SettingsViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "SettingsViewController.h"
#import "DropDownListView.h"
#import "NUBaseData.h"

@interface SettingsViewController ()
{
    DropDownListView * _menuList;
    NSMutableArray *_chooseArray;
}
@property (nonatomic, weak) IBOutlet UISegmentedControl *readSeg;
@property (nonatomic, weak) IBOutlet UISegmentedControl *wifiSeg;

@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
@property (nonatomic, weak) IBOutlet UIImageView *normalImage;
@property (nonatomic, weak) IBOutlet UIImageView *smallImage;

@end

@implementation SettingsViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNumber *defaultReadMode = nil;
    NSNumber *defaultFontSize = nil;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        if(![standardUserDefaults objectForKey:@"NightMode"])
        {
            [standardUserDefaults setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"NightMode"];
            
            [standardUserDefaults synchronize];
        }
        defaultReadMode = (NSNumber *)[standardUserDefaults objectForKey:@"NightMode"];
        
        if(![standardUserDefaults objectForKey:@"DefaultFontSize"])
        {
            [standardUserDefaults setObject:[[NSNumber alloc] initWithFloat:NORMALFONTSIZE] forKey:@"DefaultFontSize"];
            [standardUserDefaults synchronize];
        }
        
        defaultFontSize = (NSNumber *)[standardUserDefaults objectForKey:@"DefaultFontSize"];
    }
    
    
    _readSeg.selectedSegmentIndex = [defaultReadMode boolValue] ? 1 : 0;
    [_readSeg addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
    
    _bigImage.image = [UIImage imageNamed:@"ico_mr"];
    _normalImage.image = [UIImage imageNamed:@"ico_mr"];
    _smallImage.image = [UIImage imageNamed:@"ico_mr"];
    
    switch ([defaultFontSize intValue])
    {
        case (int)MINFONTSIZE:
        {
            _smallImage.image = [UIImage imageNamed:@"ico_mr_d"];
            break;
        }
        case (int)NORMALFONTSIZE:
        {
            _normalImage.image = [UIImage imageNamed:@"ico_mr_d"];
            break;
        }
        case (int)MAXFONTSIZE:
        {
            _bigImage.image = [UIImage imageNamed:@"ico_mr_d"];
            break;
        }
        default:
            break;
    }
    
    
    //初始化排序下拉列表的数据源
    NSArray *entityArray = [[NSArray alloc]initWithObjects:@"人民日报", @"光明日报", @"经济日报", @"新华每日电讯", @"辽宁日报", @"抚顺日报", @"求是杂志", nil];
    _chooseArray = [[NSMutableArray alloc] initWithObjects:entityArray, nil];
    
    //添加排序下拉列表
    _menuList = [[DropDownListView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 150, 78, 100, 40) dataSource:self delegate:self];
    
    _menuList.mSuperView = self.view;
    //[self.view addSubview:_menuList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 重写或继承base中的方法


#pragma mark - 需要子类继承的
#pragma mark - 与XIB绑定事件
-(IBAction)segmentPressed:(UISegmentedControl *)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (_readSeg == sender)
    {
        switch (_readSeg.selectedSegmentIndex) {
            case 0:
            {
                if (standardUserDefaults)
                {
                    [standardUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"NightMode"];
                    [standardUserDefaults synchronize];
                }
                break;
            }
            case 1:
            {
                if (standardUserDefaults)
                {
                    [standardUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"NightMode"];
                    [standardUserDefaults synchronize];
                }
                break;
            }
                
            default:
                break;
        }
    }
}

-(IBAction)chooseFont:(UIButton *)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    
    _bigImage.image = [UIImage imageNamed:@"ico_mr"];
    _normalImage.image = [UIImage imageNamed:@"ico_mr"];
    _smallImage.image = [UIImage imageNamed:@"ico_mr"];
    
    switch (sender.tag)
    {
        case 10:
        {
            if (standardUserDefaults)
            {
                [standardUserDefaults setObject:[NSNumber numberWithFloat:MINFONTSIZE] forKey:@"DefaultFontSize"];
            }
            _smallImage.image = [UIImage imageNamed:@"ico_mr_d"];
            
            break;
        }
        case 20:
        {
            if (standardUserDefaults)
            {
                [standardUserDefaults setObject:[NSNumber numberWithFloat:NORMALFONTSIZE] forKey:@"DefaultFontSize"];
            }
            _normalImage.image = [UIImage imageNamed:@"ico_mr_d"];
            break;
        }
        case 30:
        {
            if (standardUserDefaults)
            {
                [standardUserDefaults setObject:[NSNumber numberWithFloat:MAXFONTSIZE] forKey:@"DefaultFontSize"];
            }
            _bigImage.image = [UIImage imageNamed:@"ico_mr_d"];
            break;
        }
        default:
            break;
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 自己的方法

#pragma mark - 消息方法

#pragma mark - 代理方法

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    if (index == 1)
    {
        //        [self performSegueWithIdentifier:@"showNewsPaper" sender:nil];
    }
}

#pragma mark -- dropdownList DataSource

-(NSInteger)numberOfSections
{
    return [_chooseArray count];
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_chooseArray objectAtIndex:section];
    return [array count];
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    NSArray *array = [_chooseArray objectAtIndex:section];
    return [array objectAtIndex:index];
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

-(UIColor *)defaultTitleColor
{
    return [UIColor colorWithRed:1/255.0f green:165/255.0f blue:176/255.0f alpha:1];
}

-(UIFont *)defaultTitleFont
{
    return [UIFont systemFontOfSize:14.0f];
}

@end
