//
//  NetWorkingManager+ResetPwd.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (ResetPwd)
+ (AFHTTPRequestOperation *)reSetPwdWithName:(NSString *)phone
                                        code:(NSString *)code
                                    newpassword:(NSString *)password
                                   newpassword2:(NSString *)repwd
                              successHandler:(SuccessBlock)success
                              failureHandler:(FailureBlock)failure;

@end
