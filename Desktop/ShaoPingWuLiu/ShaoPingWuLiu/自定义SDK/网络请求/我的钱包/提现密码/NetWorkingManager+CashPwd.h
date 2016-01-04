//
//  NetWorkingManager+CashPwd.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (CashPwd)
+ (AFHTTPRequestOperation *)firstSetCashPwdWithPwd:(NSString *)pwd
                                         withRePwd:(NSString *)rePwd
                                    SuccessHandler:(SuccessBlock)success
                                    failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)updateCashPwdWithPassword:(NSString *)pwd
                                          newpassword:(NSString *)newPwd
                                               affirm:(NSString *)rePwd
                                       SuccessHandler:(SuccessBlock)success
                                       failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)findCashPwdWithName:(NSString *)phone
                                           withCode:(NSString *)code
                                    newpassword:(NSString *)password
                                   newpassword2:(NSString *)repwd
                                 SuccessHandler:(SuccessBlock)success
                                 failureHandler:(FailureBlock)failure;
@end
