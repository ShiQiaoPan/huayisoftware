//
//  NetWorkingManager+LinkModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (LinkModel)
+ (AFHTTPRequestOperation *)addLinkPersonWithName:(NSString *)name
                                            phone:(NSString *)phone
                                   successHandler:(SuccessBlock)success
                                   failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllPersonWithSuccessHandler:(SuccessBlock)success
                                     failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)deleteLinkPersonWithLinkPersonId:(NSString *)personId
                                              successHandler:(SuccessBlock)success
                                              failureHandler:(FailureBlock)failure;
@end
