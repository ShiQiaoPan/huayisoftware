//
//  NetWorkingManager+FreightBillAsk.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/25.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+FreightBillAsk.h"

@implementation NetWorkingManager (FreightBillAsk)
+ (AFHTTPRequestOperation *)getFreightBillWithBillNO:(NSString *)billNO SuccessHandler:(SuccessBlock)successOption FailureHandler:(FailureBlock)failuerOption {
    NSDictionary * params = @{@"YBillNo":billNO};
    AFHTTPRequestOperation * operation = [self postWithUrl:@"waybill/get" requestParams:params SuccessHandler:successOption failureHandler:failuerOption];
    return operation;
}
@end
