//
//  NetWorkingManager.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"
#import "URL.h"

@implementation NetWorkingManager

+ (AFHTTPRequestOperation *)postWithUrl:(NSString *)urlString requestParams:(NSDictionary *)params SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSString * url = [BASIC_URL stringByAppendingString:urlString];    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) { success(responseObject); }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) { failure(error); }
    }];
    return operation;
}
+ (NSDictionary *)paramsByAppendingUserInfo:(NSDictionary *)params {
    NSMutableDictionary * newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    newParams[@"id"] = [UserModel defaultUser].userID;
    return newParams;
}

+ (BOOL)DataIsNull:(id)object
{
    // 判断是否为空的字符串
    if ([object isEqual:[NSNull null]])
    {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (object == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
@end
