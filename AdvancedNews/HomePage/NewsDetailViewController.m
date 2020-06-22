//
//  NewsDetailViewController.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "NewsData.h"
#import "LoginManager.h"
#import "BasicToastInterFace.h"
#import "AFNRequestData.h"
#import "BasicConfigPath.h"
#import "NUURL.h"
#import "BasicToastInterFace.h"

@interface NewsDetailViewController ()
{
    NSString *_jsString;
    float _currentFontSize;
}

@property (nonatomic, weak) IBOutlet UIButton *readModeBtn;
@property (nonatomic, weak) IBOutlet UIButton *addFavorBtn;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) NewsRecord *newsRecord;
@property (nonatomic, strong) NSArray *newsRecordArray;

@property (nonatomic, strong) NSString *newsPaperName;

@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation NewsDetailViewController

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
    //－－－－－－－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－－－－－－－－
    //加入左右滑动手势｛
    
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:_rightSwipeGestureRecognizer];
    //－－－－－－－－－｝
    
    //－－－－－－－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－－－－－－－－
    //设置开灯关灯的默认值｛
    NSNumber *defaultReadMode;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        defaultReadMode = (NSNumber *)[standardUserDefaults objectForKey:@"NightMode"];
        
        if (!defaultReadMode)
        {
            [standardUserDefaults setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"NightMode"];
            [standardUserDefaults synchronize];
            defaultReadMode = (NSNumber *)[standardUserDefaults objectForKey:@"NightMode"];
        }
    }
    else
    {
        defaultReadMode = [[NSNumber alloc] initWithBool:NO];
    }
    
    _webView.backgroundColor = [defaultReadMode boolValue] ? [UIColor grayColor] : [UIColor whiteColor];
    
    _readModeBtn.restorationIdentifier = [defaultReadMode boolValue] ? @"night" :@"day";
    [_readModeBtn addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_readModeBtn setTitle:[defaultReadMode boolValue] ? @"夜间模式" : @"日间模式" forState:UIControlStateNormal];
    
    _readModeBtn.layer.masksToBounds = YES;
    _readModeBtn.layer.cornerRadius = 3.f;
    _readModeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _readModeBtn.layer.borderWidth = 1.f;
    //－－－－－－－－－｝
    
    //－－－－－－－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－－－－－－－－
    //设置网页文字为默认字体大小｛
    NSNumber *defaultFontSize;
    if (standardUserDefaults)
    {
        defaultFontSize = (NSNumber *)[standardUserDefaults objectForKey:@"DefaultFontSize"];
        
        if (!defaultFontSize)
        {
            [standardUserDefaults setObject:[[NSNumber alloc] initWithFloat:NORMALFONTSIZE] forKey:@"DefaultFontSize"];
            [standardUserDefaults synchronize];
            defaultFontSize = (NSNumber *)[standardUserDefaults objectForKey:@"DefaultFontSize"];
        }
    }
    else
    {
        defaultFontSize = [[NSNumber alloc] initWithFloat:NORMALFONTSIZE];
    }
    
    _currentFontSize = [defaultFontSize floatValue];
    //－－－－－－－－－｝
    
    //－－－－－－－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－－－－－－－－
    //加入手势控制页面放大缩小｛
    UIPinchGestureRecognizer *twoFingerPinch =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    twoFingerPinch.delegate = self;
    [[self view] addGestureRecognizer:twoFingerPinch];
    //－－－－－－－－－｝
    
    if (![[LoginManager instance] checkLoginState])
    {
        //        [_addFavorBtn setBackgroundImage:[UIImage imageNamed:@"ico_sc"] forState:UIControlStateNormal];
    }
    else
    {
        //        [_addFavorBtn setBackgroundImage:[UIImage imageNamed:@"ico_sc_red"] forState:UIControlStateNormal];
    }
    _addFavorBtn.layer.masksToBounds = YES;
    _addFavorBtn.layer.cornerRadius = 3.f;
    _addFavorBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _addFavorBtn.layer.borderWidth = 1.f;
    
    if (!_newsPaperName || _newsPaperName.length == 0)
    {
        _newsPaperName = @"新闻详情";
    }
    
    //    _titleLabel.text = _newsPaperName;
    [self getWebPageData];
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
-(IBAction)segmentPressed:(UIButton *)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (_readModeBtn == sender)
    {
        if ([_readModeBtn.restorationIdentifier isEqualToString:@"night"])
        {
            
            if (standardUserDefaults)
            {
                [standardUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"NightMode"];
                [standardUserDefaults synchronize];
            }
            _webView.backgroundColor = [UIColor whiteColor];
            
            //    字体颜色
            NSString *fontColorStr = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'";
            
            [_webView stringByEvaluatingJavaScriptFromString:fontColorStr];
            //    页面背景色
            NSString *backColorStr =@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'";
            
            [_webView stringByEvaluatingJavaScriptFromString:backColorStr];
            _readModeBtn.restorationIdentifier = @"day";
            [_readModeBtn setTitle:@"日间模式" forState:UIControlStateNormal];
        }
        else
        {
            if (standardUserDefaults)
            {
                [standardUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"NightMode"];
                [standardUserDefaults synchronize];
            }
            
            _webView.backgroundColor = [UIColor grayColor];
            
            //    字体颜色
            NSString *fontColorStr = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'";
            
            [_webView stringByEvaluatingJavaScriptFromString:fontColorStr];
            //    页面背景色
            NSString *backColorStr =@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'";
            
            [_webView stringByEvaluatingJavaScriptFromString:backColorStr];
            
            _readModeBtn.restorationIdentifier = @"night";
            [_readModeBtn setTitle:@"夜间模式" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)AddFavor:(id)sender
{
    //        NSSUSERLONGSTATE state = [NSSUserInterFace getLogInState];
    //        if (state == NSSUSERLONGSTATE_NONE)
    //        {
    //            [NSSUserInterFace doLogIn];
    //        }
    //    
    //    [self performSegueWithIdentifier:@"nextVC" sender:nil];
    
    if (![[LoginManager instance] checkLoginState])
    {
        [[LoginManager instance] doLogin];
    }
    else
    {
        if(!_act)
        {
            _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
            [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
            [self.view addSubview:_act];
        }
        [_act startAnimating];
        
        //        NSMutableDictionary *parameters;
        UserProfile *currentUser = [[UserProfile alloc] init];
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults)
        {
            NSDictionary *dicData = (NSDictionary *)[standardUserDefaults objectForKey:@"LoginUserProfile"];
            
            [currentUser setJsonDataWithDic:dicData];
        }
        
        NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:AddFavorURL(_newsRecord.uid, currentUser.token)];
        
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
             
             [BasicToastInterFace showToast:@"收藏成功"];
         }                          fail:^(NSError *error)
         {
             [_act stopAnimating];
             NSLog(@"%@",[error description]);
             
             [BasicToastInterFace showToast:Network_NotReachable];
         }];
    }
}

- (IBAction)lastPage:(id)sender
{
    if (!_newsRecordArray || [_newsRecordArray count] == 0)
    {
        return;
    }
    NSInteger curIndex = [_newsRecordArray indexOfObject:_newsRecord];
    if (curIndex == 0)
    {
        [BasicToastInterFace showToast:@"已经是第一篇了"];
        return;
    }
    _newsRecord = [_newsRecordArray objectAtIndex:--curIndex];
    [self getWebPageData];
}

- (IBAction)nextPage:(id)sender
{
    if (!_newsRecordArray || [_newsRecordArray count] == 0)
    {
        return;
    }
    NSInteger curIndex = [_newsRecordArray indexOfObject:_newsRecord];
    if (curIndex == ([_newsRecordArray count] - 1))
    {
        
        [BasicToastInterFace showToast:@"已经是最后一篇了"];
        return;
    }
    _newsRecord = [_newsRecordArray objectAtIndex:++curIndex];
    [self getWebPageData];
}

- (IBAction)zoomout:(id)sender
{
    float fScale = 1.1f;
    if ((_currentFontSize * fScale) >= MAXFONTSIZE)
    {
        _currentFontSize = MAXFONTSIZE;
        [BasicToastInterFace showToast:@"已经是最大了"];
        return;
    }
    
    _currentFontSize = _currentFontSize * fScale;
    
    //字体大小
    NSString *fontStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", _currentFontSize];
    [_webView stringByEvaluatingJavaScriptFromString:fontStr];
}

- (IBAction)zoomin:(id)sender
{
    float fScale = 0.9f;
    if ((_currentFontSize * fScale) <= MINFONTSIZE)
    {
        _currentFontSize = MINFONTSIZE;
        [BasicToastInterFace showToast:@"已经是最小了"];
        return;
    }
    
    _currentFontSize = _currentFontSize * fScale;
    
    //字体大小
    NSString *fontStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", _currentFontSize];
    [_webView stringByEvaluatingJavaScriptFromString:fontStr];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 自己的方法
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"Pinch scale: %f", recognizer.scale);
    
    static float tempFontSize = NORMALFONTSIZE;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        tempFontSize = _currentFontSize;
        [_webView setUserInteractionEnabled:NO];
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if ((tempFontSize * recognizer.scale) >= MAXFONTSIZE)
        {
            _currentFontSize = MAXFONTSIZE;
            return;
        }
        else if((tempFontSize * recognizer.scale) <= MINFONTSIZE)
        {
            _currentFontSize = MINFONTSIZE;
            return;
        }
        else
        {
            _currentFontSize = tempFontSize * recognizer.scale;
        }
        //字体大小
        NSString *fontStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", _currentFontSize];
        [_webView stringByEvaluatingJavaScriptFromString:fontStr];
        
        return;
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {        
        [_webView setUserInteractionEnabled:YES];
        return;
    }
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self nextPage:nil];
        return;
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self lastPage:nil];
        return;
    }
}

- (void)getWebPageData
{
    
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"CLOUDPUSH"] stringByAppendingString:GetNewsContentURL(_newsRecord.uid)];
    
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
                      "</html>", 12.0,@"#686868",[[NSString alloc] initWithData:[respData dataUsingEncoding:NSUTF8StringEncoding] encoding:4]];
         
         [_webView loadHTMLString:_jsString baseURL:nil];
         _webView.scalesPageToFit = YES;
         
     }                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:Network_NotReachable];
     }];
}
#pragma mark - 消息方法

#pragma mark - 代理方法

#pragma mark - loading框代理

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //字体大小
    NSString *fontStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", _currentFontSize];
    [webView stringByEvaluatingJavaScriptFromString:fontStr];
    //    字体颜色
    NSNumber *isNightMode;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        isNightMode = (NSNumber *)[standardUserDefaults objectForKey:@"NightMode"];
    }
    
    NSString *fontColorStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '%@'", [isNightMode boolValue] ? @"white" : @"gray"];
    
    [webView stringByEvaluatingJavaScriptFromString:fontColorStr];
    //    页面背景色
    NSString *backColorStr =[NSString stringWithFormat: @"document.getElementsByTagName('body')[0].style.background='%@'", [isNightMode boolValue] ? @"#2E2E2E" : @"#FFFFFF"];
    
    [webView stringByEvaluatingJavaScriptFromString:backColorStr];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    NSLog(@"didFailLoadWithError:%@", error);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
