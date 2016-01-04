//
//  NetWorkingManager+GetCode.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+GetCode.h"

@implementation NetWorkingManager (GetCode)
+ (AFHTTPRequestOperation *)getCodeWithPhone:(NSString *)phone successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = @{@"username":phone};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/sendnote" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}

@end
