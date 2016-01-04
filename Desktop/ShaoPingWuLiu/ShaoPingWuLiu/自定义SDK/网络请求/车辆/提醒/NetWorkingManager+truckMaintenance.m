//
//  NetWorkingManager+Maintenance.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+truckMaintenance.h"

@implementation NetWorkingManager (truckMaintenance)
+ (AFHTTPRequestOperation *)submitTruckMaintenanceWithMstarttime:(NSString *)mstarttime mamount:(NSString *)mamount mContent:(NSString *)content remindtime:(NSString *)remindtime successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * paramas = [self paramsByAppendingUserInfo: @{@"mstarttime":mstarttime, @"remindtime":remindtime, @"mamount":mamount, @"mcontent":content}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"maintain/save" requestParams:paramas SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllMaintenanceWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"maintain/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
