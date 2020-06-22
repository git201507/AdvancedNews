//
//  NewsRecordViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "NewsRecordViewController.h"
#import "NewsData.h"
#import "LoginManager.h"
#import "BasicMessageInterFace.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "NUURL.h"
#import "DropDownListView.h"
#import "NSDate+Weekday.h"
#import "UITableView+Cell.h"

#define MinLastDate @"20160715"

@interface NewsRecordViewController ()
{
    DropDownListView * _menuList;
    NSMutableArray *_chooseArray;
    
    NewsRecordReceiveInfo *_newsRecordReceiveInfo;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *menuBtn;
@property (nonatomic, weak) IBOutlet UIButton *changeDateBtn;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UILabel *curDateLabel;


@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerStart;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;


@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (nonatomic, strong) NewsPaper *curNewsPaper;
@property (nonatomic, strong) NewsPaperReceiveInfo *newsPaperReceiveInfo;
@property (nonatomic, assign) int newspaperCount;

@property (nonatomic, copy) NSString *curDate;
@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation NewsRecordViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    _pickerStart.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [_pickerView setHidden:YES];
    
    
    _titleLabel.text = [NSString stringWithFormat:@"%@%@", _curNewsPaper.name, _curNewsPaper.publictime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *seeDate = [dateFormatter dateFromString:_curDate];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _curDateLabel.text = [_titleLabel.text containsString:@"求是杂志"] ? [NSString stringWithFormat:@"第%@期", [self getOrderByDate:_curDate]] : [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: seeDate], [NSDate weekday:seeDate formatPrifix:@"周"]];
    
    NSLog(@"%u", [_curDateLabel.text length]);
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:_rightSwipeGestureRecognizer];
    
    //初始化排序下拉列表的数据源
    NSArray *entityArray = [[NSArray alloc]initWithObjects:@"用户登录", @"个性化设置", @"我的收藏", @"帮助", nil];
    NSArray *entityArrayLogin = [[NSArray alloc]initWithObjects:@"退出登录", @"个性化设置", @"我的收藏", @"帮助", nil];
    BOOL isLogin = [[LoginManager instance] checkLoginState];
    
    _chooseArray = [[NSMutableArray alloc] initWithObjects: !isLogin ? entityArray : entityArrayLogin, nil];
    
    //添加排序下拉列表
    _menuList = [[DropDownListView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 23, 100, 40) dataSource:self delegate:self];
    
    _menuList.mSuperView = self.view;
    [self.view addSubview:_menuList];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:100]];
    
    //绑定账号切换消息
    [BasicMessageInterFace subMessage:self selector:@selector(accountChange) MessageID:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread];
    
    NSString *newsNo = [_titleLabel.text containsString:@"求是杂志"] ? [self getOrderByDate: _curDate] : _curDate;
    
    [self getNewsRecordList:newsNo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
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
            [dest setValue:sender forKey:@"newsRecord"];
        }
        
        NSMutableArray *cacheArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NewsRecord *record in _newsRecordReceiveInfo.data)
        {
            if ([record.type intValue] == 1)
            {
                continue;
            }
            [cacheArray addObject:record];
        }
        
        [dest setValue:cacheArray forKey:@"newsRecordArray"];
        
        [dest setValue:_curNewsPaper.name forKey:@"newsPaperName"];
    }
    if ([segue.identifier isEqualToString:@"toFavor"])
    {
        id dest  = segue.destinationViewController;
        
        [dest setValue:_newsPaperReceiveInfo forKey:@"newsPaperReceiveInfo"];
    }
}

#pragma mark - 需要子类继承的

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
}
#pragma mark - 与XIB绑定事件
- (IBAction)showMenu:(id)sender
{
    [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
}

- (IBAction)lastNewsPaper:(id)sender
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
    
    [_pickerView setHidden:YES];
    
    if(!_newsPaperReceiveInfo || [_newsPaperReceiveInfo.data count]==0)
    {
        return;
    }
    
    if ([_titleLabel.text containsString:@"求是杂志"])
    {
        [self getNewsRecordList:[self getLastOrNextOrderWithFlag:-1]];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *seeDate = [dateFormatter dateFromString:_curDate];
    NSDate *lastDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:seeDate];
    
    NSString *dateStr = MinLastDate;
    if ([dateStr intValue] > [[dateFormatter stringFromDate:lastDate] intValue])
    {
        [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@是最早一期！", MinLastDate]];
        return;
    }
    
    _curDate = [dateFormatter stringFromDate:lastDate];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _curDateLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: lastDate], [NSDate weekday:lastDate formatPrifix:@"周"]] ;
    
    [self getNewsRecordList:_curDate];
}

- (IBAction)nextNewsPaper:(id)sender
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
    
    [_pickerView setHidden:YES];
    
    if(!_newsPaperReceiveInfo || [_newsPaperReceiveInfo.data count]==0)
    {
        return;
    }
    
    if ([_titleLabel.text containsString:@"求是杂志"])
    {
        [self getNewsRecordList:[self getLastOrNextOrderWithFlag:1]];
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
    
    [self getNewsRecordList:_curDate];
}

- (IBAction)showDatePickerView:(id)sender
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
    
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
    
    NSString *dateStr = MinLastDate;
    if ([dateStr intValue] > [[dateFormatter stringFromDate:_pickerStart.date] intValue] && ![_titleLabel.text containsString:@"求是杂志"])
    {
        [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@是最早一期！", MinLastDate]];
        return;
    }
    
    _curDate = [dateFormatter stringFromDate:_pickerStart.date];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    _curDateLabel.text = [_titleLabel.text containsString:@"求是杂志"] ? [NSString stringWithFormat:@"第%@期", [self getOrderByDate:_curDate]] : [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: _pickerStart.date], [NSDate weekday:_pickerStart.date formatPrifix:@"周"]];
    
    NSString *newsNo = [_titleLabel.text containsString:@"求是杂志"] ? [self getOrderByDate: _curDate] : _curDate;
    
    [self getNewsRecordList:newsNo];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自己的方法
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    //    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    //    {
    //        NSInteger curIndex = [_newsPaperReceiveInfo.data indexOfObjectByNSS:_curNewsPaper];
    //        if (curIndex == [_newsPaperReceiveInfo.data count] - 1)
    //        {
    //            return;
    //        }
    //        _curNewsPaper = [_newsPaperReceiveInfo.data objectAtIndexByNSS:++curIndex];
    //        
    //        NSString *newsNo = [_curNewsPaper.name isEqualToString:@"求是杂志"] ? [self getOrderByDate: _curDate] : _curDate;
    //        
    //        [self getNewsRecordList:newsNo];
    //        return;
    //    }
    //    
    //    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    //    {
    //        NSInteger curIndex = [_newsPaperReceiveInfo.data indexOfObjectByNSS:_curNewsPaper];
    //        if (curIndex == 0)
    //        {
    //            return;
    //        }
    //        _curNewsPaper = [_newsPaperReceiveInfo.data objectAtIndexByNSS:--curIndex];
    //        NSString *newsNo = [_curNewsPaper.name isEqualToString:@"求是杂志"] ? [self getOrderByDate: _curDate] : _curDate;
    //        [self getNewsRecordList:newsNo];
    //        return;
    //    }
}


- (NSString *)getLastOrNextOrderWithFlag: (int)flag
{
    if([_curDateLabel.text length] < 8)
        return @"201601";
    
    int iOrder = [[_curDateLabel.text substringWithRange:NSMakeRange(5, 2)] intValue];
    
    int iYear = [[_curDateLabel.text substringWithRange:NSMakeRange(1, 4)] intValue];
    
    if (flag == -1)
    {
        if(--iOrder == 0)
        {
            iYear--;
            iOrder = 24;
        }
    }
    else
    {
        if(++iOrder == 25)
        {
            iYear++;
            iOrder = 1;
        }
    }
    NSString *retStr = (iOrder < 10) ? [NSString stringWithFormat:@"%d0%d", iYear, iOrder] : [NSString stringWithFormat:@"%d%d", iYear, iOrder];
    
    _curDateLabel.text = [NSString stringWithFormat:@"第%@期", retStr];
    return retStr;
}

- (NSString *)getOrderByDate: (NSString *)dateStr
{
    if(!dateStr || [dateStr length] < 8 )
        return @"201601";
    
    __strong NSMutableString *retStr = [[NSMutableString alloc] initWithCapacity:0];
    
    [retStr appendString:[dateStr substringWithRange:NSMakeRange(0, 4)]];
    
    int iOrder = [[dateStr substringWithRange:NSMakeRange(4, 2)] intValue] * 2 - 1;
    
    NSString *dayStr = [dateStr substringWithRange:NSMakeRange(6, 2)];
    if ([dayStr intValue] < 15)
    {
        iOrder--;
    }
    
    if (iOrder <= 0)
    {
        dayStr = @"01";
    }
    else
    {
        if (iOrder > 9)
        {
            dayStr=  [NSString stringWithFormat:@"%d", iOrder];
        }
        else
        {
            dayStr=  [NSString stringWithFormat:@"0%d", iOrder];
        }
    }
    [retStr appendString:dayStr];
    return  retStr;
}

- (void)getNewsRecordList:(NSString *)newsNo
{
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString: GetNewsListURL(newsNo, [_curNewsPaper.uid intValue])];
    
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
             _newsRecordReceiveInfo = [[NewsRecordReceiveInfo alloc] init];
             _newsRecordReceiveInfo.data = [[NSMutableArray alloc] initWithCapacity:0];
             [_tableView reloadData];
             return;
         }
         
         
         _newsRecordReceiveInfo = [[NewsRecordReceiveInfo alloc] init];
         if (![_newsRecordReceiveInfo setJsonDataWithDic:respData] || !_newsRecordReceiveInfo.data)
         {
             if (_newsRecordReceiveInfo.data)
             {
                 [_newsRecordReceiveInfo.data removeAllObjects];
             }
             else
             {
                 _newsRecordReceiveInfo.data = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [_tableView reloadData];
             return;
         }
         
         if ([_newsRecordReceiveInfo.data count] == 0)
         {
             if([_curNewsPaper.name containsString:@"求是杂志"])
             {
                 [BasicToastInterFace showToast:@"没有任何记录！"];
             }
             else
             {
                 [BasicToastInterFace showToast:@"报纸没有找到！"];
             }
         }
         
         //         if (![_titleLabel.text isEqualToString:_curNewsPaper.name])
         //         {
         //             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         //             dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
         //             dateFormatter.dateFormat = @"yyyyMMdd";
         //             NSDate *seeDate = [dateFormatter dateFromString:_curDate];
         //
         //             dateFormatter.dateFormat = @"yyyy-MM-dd";
         //
         //             _curDateLabel.text = [_curNewsPaper.name containsString:@"求是杂志"] ? [NSString stringWithFormat:@"第%@期", [self getOrderByDate:_curDate]] : [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: seeDate], [NSDate weekday:seeDate formatPrifix:@"周"]];
         //         }
         
         //         _titleLabel.text = _curNewsPaper.name;
         _titleLabel.text = [NSString stringWithFormat:@"%@%@", _curNewsPaper.name, _curNewsPaper.publictime];
         [_tableView reloadData];
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}

- (void)login
{
    [[LoginManager instance] doLogin];
}

- (void)loginOff
{
    [[LoginManager instance] doLogoff];
}

- (void)accountChange
{
    //初始化排序下拉列表的数据源
    NSArray *entityArray = [[NSArray alloc]initWithObjects:@"用户登录", @"个性化设置", @"我的收藏", @"帮助", nil];
    NSArray *entityArrayLogin = [[NSArray alloc]initWithObjects:@"退出登录", @"个性化设置", @"我的收藏", @"帮助", nil];
    BOOL isLogin = [[LoginManager instance] checkLoginState];
    
    _chooseArray = [[NSMutableArray alloc] initWithObjects: !isLogin ?entityArray : entityArrayLogin, nil];
    
    UserProfile *currentUser = [[UserProfile alloc] init];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSDictionary *dicData = (NSDictionary *)[standardUserDefaults objectForKey:@"LoginUserProfile"];
        
        [currentUser setJsonDataWithDic:dicData];
    }
    if (currentUser)
    {
        NSLog(@"手机号码－->%@\r\ntoken-->%@\r\n密码-->%@", currentUser.userName, currentUser.token, currentUser.password);
    }
    
}

#pragma mark - 消息方法

#pragma mark - 代理方法

#pragma mark - Tableview datasource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsRecord *newsRecord = [_newsRecordReceiveInfo.data objectAtIndex:indexPath.section];
    
    if([newsRecord.type intValue] == 1)
    {
        return 25;
    }
    else
    {
        return 87;
    }
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
    return [_newsRecordReceiveInfo.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"NewsRecordCell"];
    //    [cell.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    NewsRecord *newsRecord = [_newsRecordReceiveInfo.data objectAtIndex:indexPath.section];
    
    if([newsRecord.type intValue] == 1)
    {
        cell = [tableView makeCellByIdentifier:@"NewsRecordWithHeaderCell"];
        //        UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
        //        UILabel *paperLabel = (UILabel *)[cell viewWithTag:20];
        UILabel *newspageLabel = (UILabel *)[cell viewWithTag:30];
        
        //        titleLabel.text = newsRecord.newstitle;
        //        paperLabel.text = _curNewsPaper.name;
        newspageLabel.text = newsRecord.newspage;
    }
    else
    {
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
        UILabel *paperLabel = (UILabel *)[cell viewWithTag:20];
        
        titleLabel.text = newsRecord.newstitle;
        
        
        if(newsRecord.commentValue == nil)
        {
            //            paperLabel.text = _curNewsPaper.name;
            paperLabel.text = @"";
        }
        else
        {
            //            paperLabel.text = [NSString stringWithFormat:@"%@ %@", _curNewsPaper.name, newsRecord.commentValue] ;
            paperLabel.text = newsRecord.commentValue ;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NewsRecord *newsRecord = [_newsRecordReceiveInfo.data objectAtIndex:indexPath.section];
    if([newsRecord.type intValue] == 1)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"toNewsDetail" sender:newsRecord];
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    if (index == 0)
    {
        if ([[LoginManager instance] checkLoginState])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息：" message:@"是否继续退出？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            [alert show];
        }
        else
        {
            [[LoginManager instance] doLogin];
        }
        return;
    }
    if (index == 1)
    {
        [self performSegueWithIdentifier:@"showSettings" sender:nil];
        return;
    }
    if (index == 2)
    {
        if (![[LoginManager instance] checkLoginState])
        {
            [[LoginManager instance] doLogin];
        }
        else
        {
            [self performSegueWithIdentifier:@"toFavor" sender:nil];
        }
        return;
    }
    if (index == 3)
    {
        [self performSegueWithIdentifier:@"showTip" sender:nil];
        return;
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

#pragma mark - loading框代理


#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self loginOff];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.navigationController.viewControllers count] == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
