//
//  NetWorkingManager+PackingCargo.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+PackingCargo.h"

@implementation NetWorkingManager (PackingCargo)

+ (AFHTTPRequestOperation *) submitPackingOrderWithParamsDict:(NSDictionary *) params SuccessHandler:(SuccessBlock) successOperation FailureHandler:(FailureBlock) failuerOperation {
    AFHTTPRequestOperation *operation = [self postWithUrl:@"indent/neworders" requestParams:params SuccessHandler:successOperation failureHandler:failuerOperation];
    return operation;
}

+ (AFHTTPRequestOperation *) getdestinationCitySuccessHandler:(SuccessBlock) successOperation FailureHandler:(FailureBlock) failuerOperation {
    AFHTTPRequestOperation *operation = [self postWithUrl:@"canshipcities/getAll" requestParams:nil SuccessHandler:successOperation failureHandler:failuerOperation];
    return operation;
}

@end
