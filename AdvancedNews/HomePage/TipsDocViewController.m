//
//  TipsDocViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "TipsDocViewController.h"
#import "AppDelegate.h"
#import "LoginManager.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "NUURL.h"

@interface TipsDocViewController ()
{
    NSString *_jsString;
    float _currentFontSize;
}
@property (nonatomic, strong) NewsRecord *newsRecord;
@property (nonatomic, strong) NSArray *newsRecordArray;

@property (nonatomic, strong) NSString *newsPaperName;
@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation TipsDocViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //－－－－－－－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－－－－－－－－
    //加入左右滑动手势｛
    for (id subview in [_webView subviews])
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            ((UIScrollView *)subview).bounces = NO;
            break;
        }
    }
    //－－－－－－－－－｝
    _webView.backgroundColor = [UIColor whiteColor];
    _currentFontSize = 18.f;
    //－－－－－－－－－｝
    [self getTipDocumentURL];
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
    
}

#pragma mark - 需要子类继承的
#pragma mark - 与XIB绑定事件
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 自己的方法

- (void)getTipDocumentURL
{
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:TipDocumentURL];
    
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
             [_webView loadHTMLString:@"" baseURL:nil];
             _webView.scalesPageToFit = NO;
             return;
         }
         
        _jsString = [NSString stringWithFormat:@"<html> \n"
                   "<head> \n"
                   "<style type=\"text/css\"> \n"
                   "body {font-size: %f;  color: %@;}\n"
                   "</style> \n"
                   "</head> \n"
                   "<body>%@</body> \n"
                   "</html>", 12.0,@"#686868",respData];

        [_webView loadHTMLString:_jsString baseURL:nil];
        _webView.scalesPageToFit = YES;
         
     }                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
    
    
//    
//    NSString *url = [[NSSConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:TipDocumentURL];
//    
//    [super callNetTaskWithName:taskNameStr url:url parameters:nil finishCallbackBlock:^(id responseInfo, BOOL isSuccess)
//     {
//         [NSSLoadingInterFace hideLoadingWithNameID:taskNameStr];
//         if (!isSuccess)
//         {
//             [_webView loadHTMLString:@"" baseURL:nil];
//             _webView.scalesPageToFit = NO;
//             return;
//         }
//         
//         _jsString = [NSString stringWithFormat:@"<html> \n"
//                      "<head> \n"
//                      "<style type=\"text/css\"> \n"
//                      "body {font-size: %f;  color: %@;}\n"
//                      "</style> \n"
//                      "</head> \n"
//                      "<body>%@</body> \n"
//                      "</html>", 12.0,@"#686868",[[NSString alloc] initWithData:responseInfo encoding:4]];
//         
//         [_webView loadHTMLString:_jsString baseURL:nil];
//         _webView.scalesPageToFit = YES;
//     }];
}
#pragma mark - 消息方法

#pragma mark - 代理方法


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //    //字体大小
    //    NSString *fontStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", _currentFontSize];
    //    [webView stringByEvaluatingJavaScriptFromString:fontStr];
    //    //    字体颜色
    //    NSNumber *isNightMode;
    //    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //    if (standardUserDefaults)
    //    {
    //        isNightMode = (NSNumber *)[standardUserDefaults objectForKey:@"NightMode"];
    //    }
    //    
    //    NSString *fontColorStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '%@'", [isNightMode boolValue] ? @"white" : @"gray"];
    //    
    //    [webView stringByEvaluatingJavaScriptFromString:fontColorStr];
    //    //    页面背景色
    //    NSString *backColorStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.background='%@'", [isNightMode boolValue] ? @"#2E2E2E" : @"#FFFFFF"];
    //    
    //    [webView stringByEvaluatingJavaScriptFromString:backColorStr];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    NSLog(@"didFailLoadWithError:%@", error);
}


@end
