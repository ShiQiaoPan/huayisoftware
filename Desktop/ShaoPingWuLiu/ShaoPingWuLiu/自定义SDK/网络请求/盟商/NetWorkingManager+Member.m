//
//  NetWorkingManager+Member.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+Member.h"

@implementation NetWorkingManager (Member)
+ (AFHTTPRequestOperation *)getAllMemberWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    AFHTTPRequestOperation * operation = [self postWithUrl:@"franchisees/getAll" requestParams:nil SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)submitMemberWithName:(NSString *)name tel:(NSString *)phone company:(NSString *)companyName successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo: @{@"name":name, @"tel":phone, @"company":companyName}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"franchisees/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
