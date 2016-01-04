//
//  NetWorkingManager+JoinVIP.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (JoinVIP)
+ (AFHTTPRequestOperation *)joinVIPWithSuccessHandler:(SuccessBlock)success
                                  failureHandler:(FailureBlock)failure;
@end
