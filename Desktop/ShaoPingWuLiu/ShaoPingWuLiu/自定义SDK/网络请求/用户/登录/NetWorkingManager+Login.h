//
//  NetWorkingManager+Login.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (Login)
+ (AFHTTPRequestOperation *)loginWithName:(NSString *)phone
                                    password:(NSString *)password
                              successHandler:(SuccessBlock)success
                              failureHandler:(FailureBlock)failure;

@end
