//
//  NetWorkingManager+SaveADD.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+SaveADD.h"

@implementation NetWorkingManager (SaveReciveADD)
+ (AFHTTPRequestOperation *)saveReciveADDWithName:(NSString *)name phone:(NSString *)phone site:(NSString *)address successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo: @{@"name":name, @"phone":phone, @"site":address, @"username":[UserModel defaultUser].phoneNumber}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"delivery/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllReciveADDWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * parmas = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"delivery/getAll" requestParams:parmas SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)setDefaultReciveADDWithAddId:(NSString *)addId successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":[UserModel defaultUser].phoneNumber, @"id":addId};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"delivery/setdefaultsite" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)deleteReciveADDWithAddId:(NSString *)addId successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"id":addId, @"username":[UserModel defaultUser].phoneNumber};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"delivery/delete" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
