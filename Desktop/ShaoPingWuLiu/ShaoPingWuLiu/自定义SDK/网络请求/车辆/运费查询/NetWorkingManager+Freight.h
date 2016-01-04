//
//  NetWorkingManager+Freight.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (Freight)

+ (AFHTTPRequestOperation *)freightAskWithDate:(NSString *)date
                                successHandler:(SuccessBlock)success
                                failureHandler:(FailureBlock)failure;
@end
