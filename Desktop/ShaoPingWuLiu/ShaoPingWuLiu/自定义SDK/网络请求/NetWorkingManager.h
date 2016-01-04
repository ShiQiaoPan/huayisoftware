//
//  NetWorkingManager.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError * error);

@interface NetWorkingManager : NSObject
+ (AFHTTPRequestOperation *)postWithUrl:(NSString *)urlString requestParams:(NSDictionary *)params SuccessHandler:(SuccessBlock)success failureHandler :(FailureBlock)failure;
/**
 *  因为除登录、注册、发送短信验证码外，所有接口中，用户ID、手机号、密码、token 字段 都必传所以提供一个拼接参数的方法给外部该拼接的时候调用此方法即可
 *
 *  @param params 不包含用户ID、手机号、密码、token 字段外的请求参数
 *
 *  @return 拼接好的请求参数
 */
+ (NSDictionary *)paramsByAppendingUserInfo:(NSDictionary *)params;

@end
