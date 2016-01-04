//
//  NetWorkingManager+WallerDetail.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (WallerDetail)
+ (AFHTTPRequestOperation *)getWalletDetailWithSuccessHandler:(SuccessBlock)success
                                               failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getWalletDetailWithDate:(NSString *)date
                                          tradetype:(NSString *)type
                                     SuccessHandler:(SuccessBlock)success
                                     failureHandler:(FailureBlock)failure;

@end
