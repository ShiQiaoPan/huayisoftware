//
//  NetWorkingManager+Freight.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+Freight.h"

@implementation NetWorkingManager (Freight)
+ (AFHTTPRequestOperation *)freightAskWithDate:(NSString *)date successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"date":date}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"vehicle/getfreight" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
