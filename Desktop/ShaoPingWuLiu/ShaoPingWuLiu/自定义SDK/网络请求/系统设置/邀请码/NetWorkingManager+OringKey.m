//
//  NetWorkingManager+OringKey.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+OringKey.h"

@implementation NetWorkingManager (OringKey)
+ (AFHTTPRequestOperation *)getOrangeWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/getorangekey" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
