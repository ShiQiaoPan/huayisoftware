//
//  NetWorkingManager+LinkModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+LinkModel.h"

@implementation NetWorkingManager (LinkModel)
+ (AFHTTPRequestOperation *)addLinkPersonWithName:(NSString *)name phone:(NSString *)phone successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"lname":name, @"ltel":phone}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"linkmode/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllPersonWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"linkmode/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)deleteLinkPersonWithLinkPersonId:(NSString *)personId successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = @{@"id":personId, @"member.id":[UserModel defaultUser].userID};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"linkmode/delete" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}

@end
