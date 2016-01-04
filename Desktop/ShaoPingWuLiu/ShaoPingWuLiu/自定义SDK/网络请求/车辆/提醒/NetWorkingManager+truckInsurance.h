//
//  NetWorkingManager+Insurance.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (TruckInsurance)
+ (AFHTTPRequestOperation *)submitTruckInsuranceWithIstarttime:(NSString *)isstarttime
                                                       details:(NSString *)details
                                                     starttime:(NSString *)starttime
                                                      iendtime:(NSString *)endtime
                                                     insurance:(NSString *)insranceCount
                                                    remindtime:(NSString *)remindtime
                                                successHandler:(SuccessBlock)success
                                                failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllInsuranceWithSuccessHandler:(SuccessBlock)success
                                               failureHandler:(FailureBlock)failure;
@end
