//
//  NetWorkingManager+CashPwd.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+CashPwd.h"

@implementation NetWorkingManager (CashPwd)
+ (AFHTTPRequestOperation *)firstSetCashPwdWithPwd:(NSString *)pwd withRePwd:(NSString *)rePwd SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"npassword":pwd,@"repeatpassword":rePwd}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/setwpassword" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)updateCashPwdWithPassword:(NSString *)pwd newpassword:(NSString *)newPwd affirm:(NSString *)rePwd SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"wpassword":pwd, @"npassword":newPwd, @"repeatpassword":rePwd ,@"username":[UserModel defaultUser].phoneNumber}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/upwpassword" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;

}
+ (AFHTTPRequestOperation *)findCashPwdWithName:(NSString *)phone withCode:(NSString *)code newpassword:(NSString *)password newpassword2:(NSString *)repwd SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo: @{@"username":phone, @"code":code, @"npassword":password, @"repeatpassword":repwd}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/forgetwpassword" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
