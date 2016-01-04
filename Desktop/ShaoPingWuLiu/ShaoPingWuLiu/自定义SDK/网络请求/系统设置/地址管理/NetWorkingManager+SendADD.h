//
//  NetWorkingManager+SendADD.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (SendADD)
+ (AFHTTPRequestOperation *)saveSendADDWithName:(NSString *)name
                                          phone:(NSString *)phone
                                           site:(NSString *)address
                                 successHandler:(SuccessBlock)success
                                 failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllSendADDWithSuccessHandler:(SuccessBlock)success
                                             failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)setDefaultSendADDWithAddID:(NSString *)addID
                                        successHandler:(SuccessBlock)success
                                        failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)deleteSendADDWithAddId:(NSString *)addId
                                    successHandler:(SuccessBlock)success
                                    failureHandler:(FailureBlock)failure;
@end
