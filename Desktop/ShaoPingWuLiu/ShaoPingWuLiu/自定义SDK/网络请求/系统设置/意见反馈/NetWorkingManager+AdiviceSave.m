//
//  NetWorkingManager+AdiviceSave.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+AdiviceSave.h"

@implementation NetWorkingManager (AdiviceSave)
+ (AFHTTPRequestOperation *)saveAdviceWithAdviceDetail:(NSString *)advice successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"Feedback":advice}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"feedback/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllAdviceWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"feedback/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getSingleWAdviceWithAdviceId:(NSString *)adviceId successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params =  @{@"adviceId":adviceId};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"feedback/get" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;

}
@end
