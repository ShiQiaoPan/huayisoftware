//
//  NetWorkingManager+ChangeLoginPwd.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (ChangeLoginPwd)
+ (AFHTTPRequestOperation *)changeLoginPwdWithPassword:(NSString *)pwd
                                           newpassword:(NSString *)newPwd
                                                affirm:(NSString *)rePwd successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;
@end
