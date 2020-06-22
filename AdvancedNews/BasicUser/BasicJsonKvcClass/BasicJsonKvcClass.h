//
//  BasicJsonKvcClass.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicJsonKvcClass : NSObject

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//将json字典转换为json串
+ (NSString*)dataToJsonString:(id)obj;

//将json字典数据转成类对象
- (BOOL)setJsonDataWithDic:(NSDictionary *)jsonData;

//如果属性名与字段名对不上时重写这个方法,NSARRAY 必须重写
- (NSString *)changePropertyType:(NSString*)proname;

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
- (NSDictionary*)getObjectData;

//将getObjectData方法返回的NSDictionary转化成JSON
- (NSData*)getJSONOptions:(NSJSONWritingOptions)options error:(NSError**)erro;

- (BOOL)parseWithDic:(NSDictionary *)dic;

@end
