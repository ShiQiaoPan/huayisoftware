//
//  NetWorkingManager+ResetPwd.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+ResetPwd.h"

@implementation NetWorkingManager (ResetPwd)
+ (AFHTTPRequestOperation *)reSetPwdWithName:(NSString *)phone code:(NSString *)code newpassword:(NSString *)password newpassword2:(NSString *)repwd successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":phone, @"newpassword":password, @"code":code, @"newpassword2":repwd};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/resetpassword" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;

}
@end
