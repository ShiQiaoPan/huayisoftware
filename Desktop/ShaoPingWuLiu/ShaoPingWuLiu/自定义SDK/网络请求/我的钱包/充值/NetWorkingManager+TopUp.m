//
//  NetWorkingManager+TopUp.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+TopUp.h"

@implementation NetWorkingManager (TopUp)
+ (AFHTTPRequestOperation *)submitTopupWithBalance:(NSString *)balance WithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"balance":@"1000"}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/tify" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
