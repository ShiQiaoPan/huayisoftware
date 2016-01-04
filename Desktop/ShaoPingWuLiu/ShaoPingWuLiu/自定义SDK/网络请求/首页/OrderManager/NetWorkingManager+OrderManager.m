//
//  NetWorkingManager+OrderManager.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+OrderManager.h"

@implementation NetWorkingManager (OrderManager)

+ (AFHTTPRequestOperation *)getOrderComplete:(BOOL)isCompleted SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSString *strUrl = isCompleted ? @"indent/indentaccomplish" : @"indent/indentunfinished";
    AFHTTPRequestOperation *option = [self postWithUrl:strUrl requestParams:@{
    @"id":[UserModel defaultUser].userID,
    } SuccessHandler:success failureHandler:failure];
    return option;
}

+ (AFHTTPRequestOperation *) postCommentWithId:(NSString *)commitId AndDetailComment:(NSString *)comments AndAttitude:(NSNumber *)attitude AndAging:(NSNumber *)aging SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSString *strUrl = @"content/firstcomment";
    AFHTTPRequestOperation *option = [self postWithUrl:strUrl requestParams:@{
             @"id":[UserModel defaultUser].userID,
            @"username":[UserModel defaultUser].userID,
        @"indent.id":commitId,
        @"details":comments,
        @"attitude":attitude,
        @"aging":aging
        } SuccessHandler:success failureHandler:failure];
    return option;
}

+ (AFHTTPRequestOperation *)cancelOrderWithOrderId:(NSString *)orderId SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSString *strUrl = @"indent/cancel";
    AFHTTPRequestOperation *option = [self postWithUrl:strUrl requestParams:@{
            @"orderid":orderId
            } SuccessHandler:success failureHandler:failure];
    return option;
}

@end
