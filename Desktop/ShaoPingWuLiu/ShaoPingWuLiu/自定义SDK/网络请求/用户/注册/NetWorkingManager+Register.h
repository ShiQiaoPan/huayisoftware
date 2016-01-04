//
//  NetWorkingManager+Register.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/23.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (Register)
+ (AFHTTPRequestOperation *)registerWithName:(NSString *)phone
                                    password:(NSString *)password
                                        code:(NSString *)code
                                   orangeKey:orangeKey
                              successHandler:(SuccessBlock)success
                              failureHandler:(FailureBlock)failure;
@end
