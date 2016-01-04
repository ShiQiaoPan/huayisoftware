//
//  NetWorkingManager+ChangeName.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (ChangeName)
+ (AFHTTPRequestOperation *)changeNameWithNickname:(NSString *)nickName
                                      successHandler:(SuccessBlock)success
                                      failureHandler:(FailureBlock)failure;
@end
