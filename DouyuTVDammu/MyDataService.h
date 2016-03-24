//
//  MyDataService.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/15.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *kBasicURL = @"http://capi.douyucdn.cn/api/v1/";


@interface MyDataService : NSObject

+ (NSURLSessionDataTask *)requestURL:(NSString *)urlstring
                          httpMethod:(NSString *)method
                              params:(NSDictionary *)params
                          completion:(void(^)(id result,NSError *error))block;
@end
