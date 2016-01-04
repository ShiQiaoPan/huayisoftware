//
//  NetWorkingManager+Member.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (Member)
+ (AFHTTPRequestOperation *)getAllMemberWithSuccessHandler:(SuccessBlock)success
                                            failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)submitMemberWithName:(NSString *)name
                                            tel:(NSString *)phone
                                         company:(NSString *)companyName
                                        successHandler:(SuccessBlock)success
                                        failureHandler:(FailureBlock)failure;
@end
