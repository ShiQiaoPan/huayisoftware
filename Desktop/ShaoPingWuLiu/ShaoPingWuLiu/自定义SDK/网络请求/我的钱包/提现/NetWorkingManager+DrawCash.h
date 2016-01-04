//
//  NetWorkingManager+DrawCash.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (DrawCash)
+ (AFHTTPRequestOperation *)submitDrawCashWithCardInfo:(NSDictionary * )cardDic
                                                 money:(NSString *)moneyCount
                                              password:(NSString *)pwd
                                        successHandler:(SuccessBlock)success
                                        failureHandler:(FailureBlock)failure;

@end
