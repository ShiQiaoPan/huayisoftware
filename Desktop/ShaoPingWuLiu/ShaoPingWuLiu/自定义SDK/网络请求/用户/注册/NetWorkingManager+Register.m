//
//  NetWorkingManager+Register.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+Register.h"


@implementation NetWorkingManager (Register)
+ (AFHTTPRequestOperation *)registerWithName:(NSString *)phone password:(NSString *)password code:(NSString *)code orangeKey:orangeKey successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":phone, @"password":password, @"code":code, @"orangeKey":orangeKey};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/register" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;

}
@end
