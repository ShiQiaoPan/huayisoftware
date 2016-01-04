//
//  NetWorkingManager+JoinVIP.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+JoinVIP.h"

@implementation NetWorkingManager (JoinVIP)
+ (AFHTTPRequestOperation *)joinVIPWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"username":[UserModel defaultUser].phoneNumber}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/signedapplication" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
