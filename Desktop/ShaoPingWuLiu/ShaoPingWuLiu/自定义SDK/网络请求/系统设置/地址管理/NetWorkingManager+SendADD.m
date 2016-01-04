//
//  NetWorkingManager+SendADD.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+SendADD.h"

@implementation NetWorkingManager (SendADD)
+ (AFHTTPRequestOperation *)saveSendADDWithName:(NSString *)name phone:(NSString *)phone site:(NSString *)address successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo: @{@"Name":name, @"phone":phone, @"site":address, @"username":[UserModel defaultUser].phoneNumber}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"shipments/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllSendADDWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * parmas = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"shipments/getAll" requestParams:parmas SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)setDefaultSendADDWithAddID:(NSString *)addID successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":[UserModel defaultUser].phoneNumber, @"id":addID};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"shipments/setdefaultshipments" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)deleteSendADDWithAddId:(NSString *)addId successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"id":addId, @"username":[UserModel defaultUser].phoneNumber};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"shipments/delete" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}

@end
