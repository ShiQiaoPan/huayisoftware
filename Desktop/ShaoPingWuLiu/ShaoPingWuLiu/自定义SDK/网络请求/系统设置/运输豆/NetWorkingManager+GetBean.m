//
//  NetWorkingManager+GetBean.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+GetBean.h"

@implementation NetWorkingManager (GetBean)
+ (AFHTTPRequestOperation *)getBeanCountWithsuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/gettransportbean" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;

}
+ (AFHTTPRequestOperation *)getBeanConversionWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    AFHTTPRequestOperation * operation = [self postWithUrl:@"subscriptionratio/getAll" requestParams:nil SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)payBeanWithBeanCount:(NSString *)beanCount successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo: @{@"number":@([beanCount integerValue])}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/conversion" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
