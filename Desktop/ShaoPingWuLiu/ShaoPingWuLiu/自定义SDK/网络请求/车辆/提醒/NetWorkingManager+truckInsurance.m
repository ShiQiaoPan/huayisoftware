//
//  NetWorkingManager+Insurance.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+truckInsurance.h"

@implementation NetWorkingManager (TruckInsurance)
+ (AFHTTPRequestOperation *)submitTruckInsuranceWithIstarttime:(NSString *)isstarttime details:(NSString *)details starttime:(NSString *)starttime iendtime:(NSString *)endtime insurance:(NSString *)insranceCount remindtime:(NSString *)remindtime successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * parmas = [self paramsByAppendingUserInfo: @{@"istarttime":isstarttime, @"starttime":starttime, 
@"iendtime":endtime, @"insurance":insranceCount, @"remindtime":remindtime, @"details":details}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"insurance/save" requestParams:parmas SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllInsuranceWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"insurance/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
