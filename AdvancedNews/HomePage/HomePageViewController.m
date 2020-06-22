//
//  HomePageViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "HomePageViewController.h"
#import "NewsData.h"
#import "LoginManager.h"
#import "DropDownListView.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "BasicMessageInterFace.h"
#import "BasicDriver.h"
#import "MJRefresh.h"
#import "NUURL.h"
#import "NSDate+Weekday.h"
#import "UITableView+Cell.h"

@interface HomePageViewController ()
{
    DropDownListView * _menuList;
    NSMutableArray *_chooseArray;
    
    HotNewsReceiveInfo *_hotNewsReceiveInfo;
    NewsPaperReceiveInfo *_newsPaperReceiveInfo;
    CurrentDateReceiveInfo *_curDateRecInfo;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *newsPaperView;
@property (nonatomic, weak) IBOutlet UIButton *menuBtn;
@property (nonatomic, weak) IBOutlet UILabel *currentDateLabel;
@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation HomePageViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(refreshTableByHeader) dateKey:@"table"];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉即可刷新";
    self.tableView.headerReleaseToRefreshText = @"松开即可刷新";
    self.tableView.headerRefreshingText = @"正在刷新";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
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
    
    
    //设置当前日期
    [self getCurrentDate];
    //    [self getHotNews];
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
    if ([segue.identifier isEqualToString:@"showNewsDetail"])
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
    if ([segue.identifier isEqualToString:@"showNewsPaper"])
    {
        id dest  = segue.destinationViewController;
        if (sender)
        {
            for ( int i=0; i<[_newsPaperReceiveInfo.data count];i++)
            {
                NewsPaper *newsPaper = [_newsPaperReceiveInfo.data objectAtIndex:i];
                
                UILabel *label = [[sender superview] viewWithTag:10];
                if ([label.text isEqualToString:newsPaper.name])
                {
                    
                    [dest setValue:newsPaper forKey:@"curNewsPaper"];
                    
                    [dest setValue:_newsPaperReceiveInfo forKey:@"newsPaperReceiveInfo"];
                    [dest setValue:_curDateRecInfo.data forKey:@"curDate"];
                    break;
                }
            }
        }
    }
    if ([segue.identifier isEqualToString:@"toFavor"])
    {
        id dest  = segue.destinationViewController;
        
        [dest setValue:_newsPaperReceiveInfo forKey:@"newsPaperReceiveInfo"];
    }
}

#pragma mark - 需要子类继承的
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
}


#pragma mark - 与XIB绑定事件
- (IBAction)showMoreHotNews:(id)sender
{
    [self performSegueWithIdentifier:@"showMoreHot" sender:nil];
}

- (IBAction)showMenu:(id)sender
{
    [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
}

- (void)getCurrentDate
{
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    //请求参数
    //    NSMutableDictionary *params = [@{@"openId":_zjOpenId, @"ipsAccount":_ipsAccount, @"member":[BasicAccountInterFace getCurAccountName]} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:GetSystemDateURL];
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
             return;
         }
         
         _curDateRecInfo = [[CurrentDateReceiveInfo alloc] init];
         if (![_curDateRecInfo setJsonDataWithDic:respData] || !_curDateRecInfo.data)
         {
             return;
         }
         
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
         dateFormatter.dateFormat = @"yyyyMMdd";
         NSDate *seeDate = [dateFormatter dateFromString:_curDateRecInfo.data];
         
         
         dateFormatter.dateFormat = @"yyyy-MM-dd";
         _currentDateLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate: seeDate], [NSDate weekday:seeDate formatPrifix:@"周"]];
         
         NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
         if (standardUserDefaults)
         {
             [standardUserDefaults setObject:_curDateRecInfo.data forKey:@"CurrentDate"];
             [standardUserDefaults synchronize];
         }
         
         //获取头版头条
         [self getHotNews];
         [self getNewsPaper];
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}

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
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:GetNewsHeadURL(_curDateRecInfo.data)];
    
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
- (void)getNewsPaper
{
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:GetAllNewsPaperURL];
    
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
             return;
         }
         
         _newsPaperReceiveInfo = [[NewsPaperReceiveInfo alloc] init];
         if (![_newsPaperReceiveInfo setJsonDataWithDic:respData] || !_newsPaperReceiveInfo.data)
         {
             return;
         }
         
         if ([_newsPaperReceiveInfo.data count] == 0)
         {
             [BasicToastInterFace showToast:@"没有任何记录！"];
             return;
         }
         
         UIView *subV0 = [self.view  viewWithTag:200];
         UIView *subV1 = nil;
         UIView *subV2 = nil;
         
         for ( int i=0; i<[_newsPaperReceiveInfo.data count];i++)
         {
             NewsPaper *newsPaper = [_newsPaperReceiveInfo.data objectAtIndex:i];
             
             if (i<4)
             {
                 subV1 = [subV0 viewWithTag:10];
                 subV2 = [subV1 viewWithTag:i+1];
                 
             }
             else
             {
                 subV1 = [subV0 viewWithTag:20];
                 subV2 = [subV1 viewWithTag:i+1-4];
             }
             UILabel *label = [subV2 viewWithTag:10];
             label.text = newsPaper.name;
             
         }
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}

- (IBAction)showRecord:(id)sender
{
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
    
    if (!_newsPaperReceiveInfo || !_newsPaperReceiveInfo.data || [_newsPaperReceiveInfo.data count] == 0)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"showNewsPaper" sender:sender];
}

#pragma mark - 自己的方法
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

- (void)refreshTableByHeader
{
    [self.tableView headerEndRefreshing];
    //设置当前日期
    [self getCurrentDate];
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
    
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        if ([_hotNewsReceiveInfo.data count] < 3)
        {
            return [_hotNewsReceiveInfo.data count];
        }
        else
        {
            return 3;
        }
    }
    else if (phoneScreen == PHONESCREEN_6)
    {
        if ([_hotNewsReceiveInfo.data count] < 4)
        {
            return [_hotNewsReceiveInfo.data count];
        }
        else
        {
            return 4;
        }
    }
    
    else if (phoneScreen == PHONESCREEN_6Pluse)
    {
        if ([_hotNewsReceiveInfo.data count] < 5)
        {
            return [_hotNewsReceiveInfo.data count];
        }
        else
        {
            return 5;
        }
    }
    else
    {
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"HotNewsCell"];
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
    if ([_menuList isShow])
    {
        [_menuList performSelector:@selector(sectionBtnTouch:) withObject:_menuBtn];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HotNews *hotNews = [_hotNewsReceiveInfo.data objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showNewsDetail" sender:hotNews];
}

#pragma mark - gesture代理

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
            [self login];
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
            [self login];
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

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self loginOff];
    }
    
}

@end
