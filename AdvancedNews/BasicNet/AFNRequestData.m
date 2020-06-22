//
//  AFNRequestData.m
//  AFN
//
//  Created by cherish on 15/8/31.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import "AFNRequestData.h"
#import "AFNetworking.h"
#import "BasicToastInterFace.h"

@implementation AFNRequestData



+ (void)requestURL:(NSString *)requestURL
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
              file:(NSDictionary *)files
           success:(void (^)(id respData, NSInteger statusCode))success
              fail:(void (^)(NSError *error))fail
{
    //设置安全机制，允许无证书访问
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    //构造操作对象管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //这里进行设置
    [manager setSecurityPolicy:securityPolicy];
    
    //初始化应答解析格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.设置解析格式，默认json
    //    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    //    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    //初始化请求解析格式，默认json，如忽略此步骤则可能导致500内部错误。
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer.timeoutInterval = 15;
    
    //附加头信息
    //        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //        [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    
    //3.判断网络状况
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            
            //showAlert
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络链接错误,请检查网络链接" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
            
            //NSLog(@"没有网络");
            
            return;
            
        }else if (status == AFNetworkReachabilityStatusUnknown){
            
            //NSLog(@"未知网络");
            
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            //NSLog(@"WiFi");
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            //NSLog(@"手机网络");
        }
    }];
    
    
    // 4.get请求
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        
        [manager GET:requestURL
          parameters:parmas
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 
                 if (success != nil)
                 {
                     NSLog(@"operation: %@", operation.responseString);
                     
                     responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                     if (!responseObject)
                     {
                         responseObject = operation.responseString;
                         success(responseObject, 0);
                         return;
                     }
                     
                     NSDictionary *status = [responseObject objectForKey:@"status"];
                     
                     NSString *code = [status objectForKey:@"code"];
                     NSString *msg = [status objectForKey:@"message"];
                     
                     if ([code intValue] != 0)
                     {
                         [BasicToastInterFace showToast:msg];
                     }
                     
                     success(responseObject, [code intValue]);
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 
                 
                 if (fail != nil) {
                     fail(error);
                 }
             }];
        
        
        // 5.post请求不带文件 和post带文件
    }else if ([[method uppercaseString] isEqualToString:@"POST"]) {
        
        
        if (files == nil) {
            
            
            [manager POST:requestURL
               parameters:parmas
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      
                      if (success) {
                          NSLog(@"operation: %@", operation.responseString);
                          
                          
                          responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                          if (!responseObject)
                          {
                              responseObject = operation.responseString;
                              success(responseObject, 0);
                              return;
                          }
                          
                          NSDictionary *status = [responseObject objectForKey:@"status"];
                          
                          NSString *code = [status objectForKey:@"code"];
                          NSString *msg = [status objectForKey:@"message"];
                          
                          if ([code intValue] != 0)
                          {
                              [BasicToastInterFace showToast:msg];
                          }
                          
                          success(responseObject, [code intValue]);
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"operation: %@", operation.responseString);
                      
                      if (fail) {
                          fail(error);
                      }
                      
                  }];
            
        } else {
            
            [manager POST:requestURL
               parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   
                   
                   for (id key in files) {
                       
                       id value = files[key];
                       
                       
                       
                       [formData appendPartWithFileData:value
                                                   name:key
                                               fileName:@"header.png"
                                               mimeType:@"image/png"];
                   }
                   
               } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   if (success) {
                       success(responseObject, operation.response.statusCode);
                   }
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   if (fail) {
                       fail(error);
                   }
                   
               }];
        }
        
    }
    
}

@end
