//
//  NetWorkingManager+ChangeLoginPwd.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+ChangeLoginPwd.h"

@implementation NetWorkingManager (ChangeLoginPwd)
+ (AFHTTPRequestOperation *)changeLoginPwdWithPassword:(NSString *)pwd newpassword:(NSString *)newPwd affirm:(NSString *)rePwd successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"password":pwd, @"newpassword":newPwd, @"affirm":rePwd}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/changepassword" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
