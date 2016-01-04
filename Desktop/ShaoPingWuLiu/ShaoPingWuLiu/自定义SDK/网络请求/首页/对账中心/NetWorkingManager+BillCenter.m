//
//  NetWorkingManager+BillCenter.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+BillCenter.h"

@implementation NetWorkingManager (BillCenter)

+ (AFHTTPRequestOperation *)getBillsWithBeginDate:(NSString *)begin EndDate:(NSString *)end ConsigneeTel:(NSString *)conTel isReceiver:(BOOL)isReceiver SuccessHandler:(SuccessBlock)successOption FailureHandler:(FailureBlock)failuerOption {
    NSDictionary *params = [@{
                             @"id":[UserModel defaultUser].userID,
                             @"begin":begin,
                             @"over":end,
                             @"dphone":conTel ? conTel:@""
                             } copy];
    NSString *urlStr = isReceiver ? @"/waybill/getmydelivery" : @"indent/getdate";
    AFHTTPRequestOperation *operation = [self postWithUrl:urlStr requestParams:params SuccessHandler:successOption failureHandler:failuerOption];
    return operation;
}

@end
