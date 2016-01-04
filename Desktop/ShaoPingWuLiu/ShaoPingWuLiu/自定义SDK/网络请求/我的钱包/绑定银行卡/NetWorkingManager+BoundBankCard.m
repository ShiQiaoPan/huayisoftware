//
//  NetWorkingManager+BoundBankCard.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+BoundBankCard.h"

@implementation NetWorkingManager (BoundBankCard)
+ (AFHTTPRequestOperation *)submitBoundBankCardWithCardNumber:(NSString *)cardNum bankName:(NSString *)bankName bindingname:(NSString *)personName tel:(NSString *)phoneNum SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"cardnumber":cardNum, @"bankname":bankName, @"bindingname":personName, @"tel":phoneNum, @"username":[UserModel defaultUser].phoneNumber};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"bankcard/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllBankCardWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"bankcard/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)deleteSingleBankCardWithBankcardNum:(NSString *)cardNum SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":[UserModel defaultUser].phoneNumber, @"cardnumber":cardNum};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"bankcard/delete" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
