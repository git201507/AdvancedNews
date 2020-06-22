//
//  MoreHotViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "MoreHotViewController.h"
#import "NewsData.h"
#import "BasicToastInterFace.h"
#import "NSDate+Weekday.h"
#import "UITableView+Cell.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "NUURL.h"

@interface MoreHotViewController ()
{
    HotNewsReceiveInfo *_hotNewsReceiveInfo;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *currentDateBtn;
@property (nonatomic, weak) IBOutlet UILabel *curDateLabel;

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerStart;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, strong) UIActivityIndicatorView *act;

@property (nonatomic, copy) NSString *curDate;

@end

@implementation MoreHotViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pickerStart.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [_pickerView setHidden:YES];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        _curDate = (NSString *)[standardUserDefaults objectForKey:@"CurrentDate"];
    }
    
    if (!_curDate)
    {
        [BasicToastInterFace showToast:@"无法获取系统日期"];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *seeDate = [dateFormatter dateFromString:_curDate];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _curDateLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: seeDate], [NSDate weekday:seeDate formatPrifix:@"周"]];
    
    //获取头版头条
    [self getHotNews];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toNewsDetail"])
    {
        id dest  = segue.destinationViewController;
        if (sender)
        {
            HotNews *hotNews = (HotNews *) sender;
            
            NewsRecord *newsRecord = [[NewsRecord alloc] init];
            newsRecord.uid = hotNews.newsId;
            newsRecord.newspaper = hotNews.newsPaper;
            newsRecord.newsno = hotNews.newsno;
            newsRecord.newstitle = hotNews.title;
            newsRecord.createDatetime = hotNews.createDatetime;
            
            [dest setValue:newsRecord forKey:@"newsRecord"];
            [dest setValue:hotNews.newsPaper forKey:@"newsPaperName"];
        }
    }
}

#pragma mark - 需要子类继承的
#pragma mark - 与XIB绑定事件
- (IBAction)showDatePickerView:(id)sender
{
    
    if ([_pickerView isHidden])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.dateFormat = @"yyyyMMdd";
        NSDate *seeDate = [dateFormatter dateFromString:_curDate];
        
        //
        [_pickerStart setDate:seeDate];
        [_pickerView setHidden:YES];
        //
    }
    
    [_pickerView setHidden:![_pickerView isHidden]];
    
}

- (IBAction)selectDate:(id)sender
{
    [_pickerView setHidden:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    _curDate = [dateFormatter stringFromDate:_pickerStart.date];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _curDateLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: _pickerStart.date], [NSDate weekday:_pickerStart.date formatPrifix:@"周"]];
    
    
    [self getHotNews];
}

- (IBAction)lastHot:(id)sender
{
    [_pickerView setHidden:YES];
    
    if (!_curDate)
    {
        [BasicToastInterFace showToast:@"无法获取系统日期"];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *seeDate = [dateFormatter dateFromString:_curDate];
    NSDate *lastDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:seeDate];
    _curDate = [dateFormatter stringFromDate:lastDate];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _curDateLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: lastDate], [NSDate weekday:lastDate formatPrifix:@"周"]];
    
    [self getHotNews];
}

- (IBAction)nextHot:(id)sender
{
    [_pickerView setHidden:YES];
    
    if (!_curDate)
    {
        [BasicToastInterFace showToast:@"无法获取系统日期"];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *seeDate = [dateFormatter dateFromString:_curDate];
    NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:seeDate];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSString *dateStr = (NSString *)[standardUserDefaults objectForKey:@"CurrentDate"];
        if ([dateStr intValue] < [[dateFormatter stringFromDate:nextDate] intValue])
        {
            [BasicToastInterFace showToast:@"日期不能大于今天"];
            return;
        }
    }
    _curDate = [dateFormatter stringFromDate:nextDate];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _curDateLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: nextDate], [NSDate weekday:nextDate formatPrifix:@"周"]];
    
    [self getHotNews];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自己的方法
- (void)getHotNews
{
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:GetNewsHeadURL(_curDate)];
    
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:nil
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [_act stopAnimating];
         NSLog(@"%@",respData);
         
         if (statusCode != 0)
         {
             _hotNewsReceiveInfo = [[HotNewsReceiveInfo alloc] init];
             _hotNewsReceiveInfo.data = [[NSMutableArray alloc] initWithCapacity:0];
             [_tableView reloadData];
             
             return;
         }
         
         _hotNewsReceiveInfo = [[HotNewsReceiveInfo alloc] init];
         if (![_hotNewsReceiveInfo setJsonDataWithDic:respData] || !_hotNewsReceiveInfo.data)
         {
             if (_hotNewsReceiveInfo.data)
             {
                 [_hotNewsReceiveInfo.data removeAllObjects];
             }
             else
             {
                 _hotNewsReceiveInfo.data = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [_tableView reloadData];
             return;
         }
         
         if ([_hotNewsReceiveInfo.data count] == 0)
         {
             [BasicToastInterFace showToast:@"没有任何记录！"];
         }
         
         [_tableView reloadData];
         
         
         
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}
#pragma mark - 消息方法

#pragma mark - 代理方法

#pragma mark - Tableview datasource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_hotNewsReceiveInfo.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"MoreHotNewsCell"];
    //    [cell.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    HotNews *hotNews = [_hotNewsReceiveInfo.data objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    UILabel *paperLabel = (UILabel *)[cell viewWithTag:20];
    
    titleLabel.text = hotNews.title;   //  日期
    paperLabel.text = hotNews.newsPaper;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    HotNews *hotNews = [_hotNewsReceiveInfo.data objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"toNewsDetail" sender:hotNews];
}

@end
