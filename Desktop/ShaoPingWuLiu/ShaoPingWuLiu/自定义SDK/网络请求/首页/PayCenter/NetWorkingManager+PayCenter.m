//
//  NetWorkingManager+PayCenter.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+PayCenter.h"

@implementation NetWorkingManager (PayCenter)

+ (AFHTTPRequestOperation *) getBillsIsWayBill:(BOOL) isWaybill SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSString *strUrl = isWaybill ? @"/indent/payment" : @"/indent/payment";
    AFHTTPRequestOperation *option = [self postWithUrl:strUrl requestParams:@{@"id":[UserModel defaultUser].userID,
    } SuccessHandler:success failureHandler:failure];
    return option;
}
+ (AFHTTPRequestOperation *)payOrderWithWpwd:(NSString *)wpwd money:(NSString *)moneyCount indentId:(NSString *)indent SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:@{@"wpassword":wpwd ,@"money":moneyCount, [NSString stringWithFormat:@"indent[%@]", indent]:indent}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"'" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
