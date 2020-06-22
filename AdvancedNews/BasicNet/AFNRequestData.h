//
//  AFNRequestData.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface AFNRequestData : NSObject

/**
 *  数据请求
 *
 *  @param urlstring URL
 *  @param method    get or Post
 *  @param parmas    请求参数
 *  @param files     请求文件(图片)
 *  @param success   请求成功的block
 *  @param fail      请求失败的block
 */


+ (void)requestURL:(NSString *)requestURL
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
              file:(NSDictionary *)files
           success:(void (^)(id respData, NSInteger statusCode))success
              fail:(void (^)(NSError *error))fail;

@end
