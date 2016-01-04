//
//  NetWorkingManager+MyJudge.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/10.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+MyJudge.h"

@implementation NetWorkingManager (MyJudge)

+(AFHTTPRequestOperation *)getMyJudgeSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    AFHTTPRequestOperation *option = [NetWorkingManager postWithUrl:@"content/get" requestParams:@{@"id":[UserModel defaultUser].userID} SuccessHandler:success failureHandler:failure];
    return option;
}

@end
