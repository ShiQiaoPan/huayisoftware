//
//  NetWorkingManager+SaveADD.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (SaveReciveADD)
+ (AFHTTPRequestOperation *)saveReciveADDWithName:(NSString *)name
                                              phone:(NSString *)phone
                                               site:(NSString *)address
                                     successHandler:(SuccessBlock)success
                                     failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllReciveADDWithSuccessHandler:(SuccessBlock)success
                                               failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)setDefaultReciveADDWithAddId:(NSString *)addId
                                          successHandler:(SuccessBlock)success
                                          failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)deleteReciveADDWithAddId:(NSString *)addId
                                      successHandler:(SuccessBlock)success
                                      failureHandler:(FailureBlock)failure;
@end
