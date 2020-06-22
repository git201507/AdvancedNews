//
//  FavorNewsViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "FavorNewsViewController.h"
#import "UserData.h"
#import "NSDate+Weekday.h"
#import "UITableView+Cell.h"
#import "UIColor+Hex.h"
#import "BasicConfigPath.h"
#import "NUURL.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"

@interface FavorNewsViewController ()
{
    NewsRecordReceiveInfo *_favorNewsReceiveInfo;
    
    NewsPaperReceiveInfo *_newsPaperReceiveInfo;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation FavorNewsViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取头版头条
    [self getFavorList];
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
            [dest setValue:sender forKey:@"newsRecord"];
        }
        
        NSMutableArray *cacheArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NewsRecord *record in _favorNewsReceiveInfo.data)
        {
            [cacheArray addObject:record];
        }
        
        [dest setValue:cacheArray forKey:@"newsRecordArray"];
    }
}

#pragma mark - 需要子类继承的
#pragma mark - 与XIB绑定事件
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 自己的方法
- (void)getFavorList
{
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    

    UserProfile *currentUser = [[UserProfile alloc] init];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSDictionary *dicData = (NSDictionary *)[standardUserDefaults objectForKey:@"LoginUserProfile"];

        [currentUser setJsonDataWithDic:dicData];
    }

    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:GetFavorListURL(currentUser.token)];

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
              _favorNewsReceiveInfo = [[NewsRecordReceiveInfo alloc] init];
              _favorNewsReceiveInfo.data = [[NSMutableArray alloc] initWithCapacity:0];
              [_tableView reloadData];
              return;
         }
         

          _favorNewsReceiveInfo = [[NewsRecordReceiveInfo alloc] init];
          if (![_favorNewsReceiveInfo setJsonDataWithDic:respData] || !_favorNewsReceiveInfo.data)
          {
              if (_favorNewsReceiveInfo.data)
              {
                  [_favorNewsReceiveInfo.data removeAllObjects];
              }
              else
              {
                  _favorNewsReceiveInfo.data = [[NSMutableArray alloc] initWithCapacity:0];
              }
              [_tableView reloadData];
              return;
          }
 
          if ([_favorNewsReceiveInfo.data count] == 0)
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
    return 23;
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
    return [_favorNewsReceiveInfo.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"FavorNewsCell"];
    
    
    [cell.contentView setBackgroundColor:(indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor colorWithHexString:@"f3f3f3"]];
    
    NewsRecord *favorNewsRecord = [_favorNewsReceiveInfo.data objectAtIndex:indexPath.row];
    
    NewsPaper *newpaper = [_newsPaperReceiveInfo.data objectAtIndex:([favorNewsRecord.newspaper intValue] - 1 < 0) ? 0 : [favorNewsRecord.newspaper intValue] - 1 ];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    UILabel *paperLabel = (UILabel *)[cell viewWithTag:20];
    
    titleLabel.text = favorNewsRecord.newstitle;
    paperLabel.text = [NSString stringWithFormat:@"%@ %@期%@", newpaper.name, favorNewsRecord.newsno, favorNewsRecord.newspage];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NewsRecord *favorNews = [_favorNewsReceiveInfo.data objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"toNewsDetail" sender:favorNews];
}

@end
