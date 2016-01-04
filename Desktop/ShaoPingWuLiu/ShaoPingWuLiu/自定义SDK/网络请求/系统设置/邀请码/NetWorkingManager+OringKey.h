//
//  NetWorkingManager+OringKey.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (OringKey)
+ (AFHTTPRequestOperation *)getOrangeWithSuccessHandler:(SuccessBlock)success
                                  failureHandler:(FailureBlock)failure;

@end
