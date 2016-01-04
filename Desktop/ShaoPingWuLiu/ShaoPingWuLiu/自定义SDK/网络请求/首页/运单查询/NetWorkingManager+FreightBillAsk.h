//
//  NetWorkingManager+FreightBillAsk.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/25.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (FreightBillAsk)

+ (AFHTTPRequestOperation *)getFreightBillWithBillNO:(NSString *) billNO
                                      SuccessHandler:(SuccessBlock) successOption
                                      FailureHandler:(FailureBlock) failuerOption;

@end
