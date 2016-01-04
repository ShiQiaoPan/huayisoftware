//
//  NetWorkingManager+Repair.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+TruckRepair.h"

@implementation NetWorkingManager (TruckRepair)
+ (AFHTTPRequestOperation *)submitRepairWithFfdate:(NSString *)date serviceman:(NSString *)manName sercivemoney:(NSString *)money servicecontent:(NSArray *)content successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSMutableDictionary * bfParams = [NSMutableDictionary dictionaryWithDictionary:@{@"serviceman":manName, @"amount":money, @"ffdate":date, @"vehicle.id":[UserModel defaultUser].userID}];
    for (NSDictionary * dict in content) {
        NSArray * keys = dict.allKeys;
        for (NSString * key in keys) {
            [bfParams setObject:dict[key] forKey:key];
        }
    }
    NSDictionary * params = [NSDictionary dictionaryWithDictionary:bfParams];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"maintenance/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)getAllRepairWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"maintenance/getAll" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
