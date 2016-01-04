//
//  NetWorkingManager+Balance.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+Balance.h"

@implementation NetWorkingManager (Balance)
+ (AFHTTPRequestOperation *)getWalletWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"username":[UserModel defaultUser].phoneNumber}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/wallet" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
