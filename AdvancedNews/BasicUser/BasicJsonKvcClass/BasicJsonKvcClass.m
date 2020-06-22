//
//  BasicJsonKvcClass.m
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#import <objc/runtime.h>
#import "BasicJsonKvcClass.h"

@implementation BasicJsonKvcClass

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:
                         NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSString *)dataToJsonString:(id)obj
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

const char *property_getTypeName(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T')
        {
            size_t len = strlen(attribute);
            attribute[len - 1] = '\0';
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:len - 2] bytes];
        }
    }
    return "@";
}

- (NSString *)changePropertyType:(NSString*)proname
{
    return nil;
}

-(NSString*)getPropertyType:(NSString*)proname fatherObj:(id)fatherObj
{
    NSString *rltStr = nil;
    
    NSString *changeStr = [self changePropertyType:proname];
    if (changeStr)
    {
        rltStr = changeStr;
    }
    else
    {
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList([fatherObj class], &propertyCount);
        
        for (unsigned int i = 0; i < propertyCount; ++i)
        {
            objc_property_t property = properties[i];
            const char *prName = property_getTypeName(property);
            if (!prName)
            {
                continue;
            }
            NSString *className = [NSString stringWithUTF8String:prName];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            if (className && [proname isEqualToString:propertyName])
            {
                if (![className isEqualToString:@"NSArray"])
                {
                    rltStr = className;
                }
                break;
            }
        }
        free(properties);
    }
    
    return rltStr;
    
}

- (BOOL)isSelfClassProperty:(NSString *)name
{
    BOOL rlt = NO;
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([name isEqualToString:propertyName])
        {
            rlt = YES;
            break;
        }
    }
    free(properties);
    
    return rlt;
}

- (BOOL)parseWithDic:(NSDictionary *)dic
{
    NSArray *allkey = [dic allKeys];
    
    for (int i=0; i<[allkey count]; ++i)
    {
        NSString* key = [allkey objectAtIndex:i];
        
        id val = [dic objectForKey:key];
        
        if([val isKindOfClass:[NSNull class]])
        {
            continue;
        }
        
        if([val isKindOfClass:[NSDictionary class]])
        {
            id obj = [[NSClassFromString([self getPropertyType:key fatherObj:self]) alloc] init];
            
            //不存在该类或者不继承NSSJsonKvcClass 则不管
            if(!obj || ![obj isKindOfClass:[BasicJsonKvcClass class]])
            {
                continue;
            }
            
            [obj setJsonDataWithDic:val];
            
            if ([self isSelfClassProperty:key])
            {
                [self setValue:obj forKey:key];
            }
            
            obj = nil;
            
        }
        else if([val isKindOfClass:[NSArray class]])
        {
            
            NSString* arrayKey = [self getPropertyType:key fatherObj:self];
            
            if(arrayKey)
            {
                NSMutableArray* arry = [[NSMutableArray alloc] init];
                
                for (int i=0; i<[val count]; ++i)
                {
                    
                    id obj = [[NSClassFromString(arrayKey) alloc] init];
                    
                    if(!obj || ![obj isKindOfClass:[BasicJsonKvcClass class]])
                    {
                        // 服务器返回数据中一个字段为数组，数组元素为id类型，而不是NSSJsonKvcClass类型时，走下面这个判断条件，如若有其他类似情况，请把其他情况放在else if中来判断
                        if ([obj isKindOfClass:[NSArray class]])
                        {
                            id arrayVal = [val objectAtIndex:i];
                            [arry addObject:arrayVal];
                        }
                        else
                        {
                            continue;
                        }
                        
                    }
                    else if ([obj setJsonDataWithDic:[val objectAtIndex:i]])
                    {
                        [arry addObject:obj];
                    }
                    obj = nil;
                    
                }
                
                if ([self isSelfClassProperty:key])
                {
                    [self setValue:arry forKey:key];
                }
                
                arry = nil;
                
            }
            else
            {
                if ([self isSelfClassProperty:key])
                {
                    [self setValue:[NSMutableArray arrayWithArray:val] forKey:key];
                }
            }
        }
        else
        {
            NSString *str = [self changePropertyType:key];
            if (str)
            {
                if ([self isSelfClassProperty:str])
                {
                    [self setValue:val forKey:str];
                }
            }
            else
            {
                if ([self isSelfClassProperty:key])
                {
                    [self setValue:val forKey:key];
                }
            }
        }
        
    }
    
    return YES;
}

- (BOOL)setJsonDataWithDic:(NSDictionary *)jsonData
{
    BOOL rlt = NO;
    
    if ([jsonData isKindOfClass:[NSDictionary class]])
    {
        rlt = [self parseWithDic:jsonData];
    }
    else
    {
        rlt = NO;
    }
    
    return rlt;
}

- (NSDictionary*)getObjectData
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    
    for(int i = 0;i < propsCount; i++)
    {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [self valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        //该字段不是继承NSSJsonKvcClass，舍弃
        if (value)
        {
            NSString *str = [self changePropertyType:propName];
            
            if ([value isKindOfClass:[NSArray class]])
            {
                str = propName;
            }
            if (str)
            {
                [dic setObject:value forKey:str];
            }
            else
            {
                [dic setObject:value forKey:propName];
            }
        }
    }
    
    free(props);
    return dic;
}

- (NSData*)getJSONOptions:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData] options:options error:error];
}

- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    if ([obj isKindOfClass:[BasicJsonKvcClass class]])
    {
        return [obj getObjectData];
    }
    return nil;
}
@end
