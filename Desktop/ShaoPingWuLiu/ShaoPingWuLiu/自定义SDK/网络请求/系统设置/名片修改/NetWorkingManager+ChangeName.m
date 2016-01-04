//
//  NetWorkingManager+ChangeName.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+ChangeName.h"

@implementation NetWorkingManager (ChangeName)
+ (AFHTTPRequestOperation *)changeNameWithNickname:(NSString *)nickName successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"nickname":nickName}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/upnickname" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
