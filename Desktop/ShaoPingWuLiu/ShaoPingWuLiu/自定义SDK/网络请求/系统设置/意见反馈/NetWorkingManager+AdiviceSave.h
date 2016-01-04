//
//  NetWorkingManager+AdiviceSave.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (AdiviceSave)
+ (AFHTTPRequestOperation *)saveAdviceWithAdviceDetail:(NSString *)advice
                                 successHandler:(SuccessBlock)success
                                 failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllAdviceWithSuccessHandler:(SuccessBlock)success
                                  failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getSingleWAdviceWithAdviceId:(NSString *)adviceId
                                  successHandler:(SuccessBlock)success
                                  failureHandler:(FailureBlock)failure;
@end
