//
//  NetWorkingManager+TruckStatus.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+TruckStatus.h"

@implementation NetWorkingManager (TruckStatus)
+ (AFHTTPRequestOperation *)getTruckStatusWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    AFHTTPRequestOperation * operation = [self postWithUrl:@"demand/login" requestParams:[self paramsByAppendingUserInfo:nil] SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
