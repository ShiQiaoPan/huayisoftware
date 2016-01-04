//
//  NetWorkingManager+OrderManager.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (OrderManager)

+ (AFHTTPRequestOperation *) getOrderComplete:(BOOL) isCompleted SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;

+ (AFHTTPRequestOperation *) postCommentWithId:(NSString *) commitId AndDetailComment:(NSString *) comments AndAttitude:(NSNumber *) attitude AndAging:(NSNumber *) aging SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;

+ (AFHTTPRequestOperation *) cancelOrderWithOrderId:(NSString *) orderId SuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;

@end
