//
//  NetWorkingManager+TruckNeed.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/28.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (TruckNeed)
+ (AFHTTPRequestOperation *)getTruckTodayNeedWithSuccessHandler:(SuccessBlock)success
                                                 failureHandler:(FailureBlock)failure;
@end
