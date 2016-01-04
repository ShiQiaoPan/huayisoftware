//
//  NetWorkingManager+Login.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+Login.h"

@implementation NetWorkingManager (Login)
+ (AFHTTPRequestOperation *)loginWithName:(NSString *)phone password:(NSString *)password successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":phone, @"password":password};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/login" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
