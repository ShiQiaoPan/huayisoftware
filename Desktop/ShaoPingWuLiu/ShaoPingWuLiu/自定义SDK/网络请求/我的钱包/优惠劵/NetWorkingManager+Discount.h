//
//  NetWorkingManager+Discount.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (Discount)
+ (AFHTTPRequestOperation *)getDiscountDetailWithSuccessHandler:(SuccessBlock)success
                                         failureHandler:(FailureBlock)failure;
@end
