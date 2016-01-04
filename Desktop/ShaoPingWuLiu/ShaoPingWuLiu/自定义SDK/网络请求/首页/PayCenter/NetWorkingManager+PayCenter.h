//
//  NetWorkingManager+PayCenter.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (PayCenter)

+ (AFHTTPRequestOperation *) getBillsIsWayBill:(BOOL) isWaybill SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)payOrderWithWpwd:(NSString *)wpwd
                                       money:(NSString *)moneyCount
                                    indentId:(NSString *)indent
                              SuccessHandler:(SuccessBlock)success
                              failureHandler:(FailureBlock)failure;
@end
