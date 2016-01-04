//
//  NetWorkingManager+TruckNeed.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/28.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+TruckNeed.h"

@implementation NetWorkingManager (TruckNeed)
+ (AFHTTPRequestOperation *)getTruckTodayNeedWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    AFHTTPRequestOperation * operation = [self postWithUrl:@"demand/all" requestParams:[self paramsByAppendingUserInfo:nil] SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
