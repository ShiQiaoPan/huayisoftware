//
//  NetWorkingManager+Maintenance.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (truckMaintenance)
+ (AFHTTPRequestOperation *)submitTruckMaintenanceWithMstarttime:(NSString *)mstarttime
                                                     mamount:(NSString *)mamount
                                                        mContent:(NSString *)content
                                                    remindtime:(NSString *)remindtime
                                                successHandler:(SuccessBlock)success
                                                failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllMaintenanceWithSuccessHandler:(SuccessBlock)success
                                          failureHandler:(FailureBlock)failure;

@end
