//
//  NetWorkingManager+MyJudge.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/10.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (MyJudge)

+ (AFHTTPRequestOperation *) getMyJudgeSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure;

@end
