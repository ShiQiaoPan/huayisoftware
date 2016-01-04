//
//  NetWorkingManager+GetBean.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (GetBean)
+ (AFHTTPRequestOperation *)getBeanCountWithsuccessHandler:(SuccessBlock)success
                                            failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getBeanConversionWithSuccessHandler:(SuccessBlock)success
                                                 failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)payBeanWithBeanCount:(NSString *)beanCount
                                  successHandler:(SuccessBlock)success
                                  failureHandler:(FailureBlock)failure;
@end
