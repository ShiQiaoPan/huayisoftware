//
//  NetWorkingManager+Discount.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+Discount.h"

@implementation NetWorkingManager (Discount)
+ (AFHTTPRequestOperation *)getDiscountDetailWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"coupon/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
