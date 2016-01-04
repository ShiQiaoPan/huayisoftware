//
//  NetWorkingManager+WallerDetail.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+WallerDetail.h"

@implementation NetWorkingManager (WallerDetail)
+ (AFHTTPRequestOperation *)getWalletDetailWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":[UserModel defaultUser].phoneNumber};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"pursedetails/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getWalletDetailWithDate:(NSString *)date tradetype:(NSString *)type SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"time":date, @"tradetype":type}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"pursedetails/gettime" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
