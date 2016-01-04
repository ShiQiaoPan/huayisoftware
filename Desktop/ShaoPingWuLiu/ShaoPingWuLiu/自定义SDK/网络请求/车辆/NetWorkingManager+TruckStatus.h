//
//  NetWorkingManager+TruckStatus.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (TruckStatus)
+ (AFHTTPRequestOperation *)getTruckStatusWithSuccessHandler:(SuccessBlock)success
                                              failureHandler:(FailureBlock)failure;
@end
