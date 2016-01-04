//
//  NetWorkingManager+PackingCargo.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (PackingCargo)

+ (AFHTTPRequestOperation *) submitPackingOrderWithParamsDict:(NSDictionary *) params
                                               SuccessHandler:(SuccessBlock) successOption
                                               FailureHandler:(FailureBlock) failuerOption;
+ (AFHTTPRequestOperation *) getdestinationCitySuccessHandler:(SuccessBlock) successOperation FailureHandler:(FailureBlock) failuerOperation;
@end
