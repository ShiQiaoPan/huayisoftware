//
//  NetWorkingManager+Exam.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (truckExam)
+ (AFHTTPRequestOperation *)submitTruckExamWithEstarttime:(NSString *)estarttime
                                               remindtime:(NSString *)remindtime
                                           successHandler:(SuccessBlock)success
                                           failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllTruckExamWithSuccessHandler:(SuccessBlock)success
                                               failureHandler:(FailureBlock)failure;

@end
