//
//  MyDataService.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/15.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "MyDataService.h"
#import "AFNetWorking.h"

@implementation MyDataService
+ (NSURLSessionDataTask *)requestURL:(NSString *)urlstring
                          httpMethod:(NSString *)method
                              params:(NSDictionary *)params
                          completion:(void(^)(id result,NSError *error))block{
    //1.拼接URL
    NSString *url = [kBasicURL stringByAppendingString:urlstring];
    
    //copyparams
    NSMutableDictionary *mutableDic = params.mutableCopy;
    
    //3.创建AFHTTPSessionManager对象
    AFHTTPSessionManager *af = [AFHTTPSessionManager manager];
    
    //设置请求头
    //    [af.requestSerializer setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>]
    
    //设置请求参数的数据格式：JSON   默认：&拼接
    //    af.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:<#(NSJSONWritingOptions)#>];
    
    //设置服务器返回的数据，不做解析，默认：使用JSON解析
    //    af.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *task = nil;
    
    //4.判断请求方式
    if ([method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
        
        //发送GET请求
        task = [af GET:url parameters:mutableDic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            block(responseObject,nil);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            block(nil,error);
            
        }];
        
        
    }
    else if([method caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        
        //发送POST请求
        task = [af POST:url parameters:mutableDic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            block(responseObject,nil);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            block(nil,error);
            
        }];
        
    }
    
    return task;
    
}

@end
