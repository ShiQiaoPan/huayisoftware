//
//  NetWorkingManager+Repair.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (TruckRepair)
+ (AFHTTPRequestOperation *)submitRepairWithFfdate:(NSString *)date
                                        serviceman:(NSString *)manName
                                      sercivemoney:(NSString *)money
                                    servicecontent:(NSArray *)content
                                    successHandler:(SuccessBlock)success
                                    failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllRepairWithSuccessHandler:(SuccessBlock)success
                                            failureHandler:(FailureBlock)failure;
@end
