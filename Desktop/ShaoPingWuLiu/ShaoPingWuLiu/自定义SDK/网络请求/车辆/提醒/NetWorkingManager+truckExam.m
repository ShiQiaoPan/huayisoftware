//
//  NetWorkingManager+Exam.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+truckExam.h"

@implementation NetWorkingManager (truckExam)
+ (AFHTTPRequestOperation *)submitTruckExamWithEstarttime:(NSString *)estarttime remindtime:(NSString *)remindtime successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"estarttime":estarttime, @"eendtime":remindtime}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"examined/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllTruckExamWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"examined/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;

}
@end
