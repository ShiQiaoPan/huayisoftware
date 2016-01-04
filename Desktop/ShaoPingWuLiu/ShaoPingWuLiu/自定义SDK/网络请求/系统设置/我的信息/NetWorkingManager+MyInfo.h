//
//  NetWorkingManager+MyInfo.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (MyInfo)
+ (AFHTTPRequestOperation *)getMyInfoWithSuccessHandler:(SuccessBlock)success
                                         failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)submitHeadImageWithImageData:(NSData *)imageData andImageFile:(NSString *)imageFile successHandler:(void(^)(id responseObject, AFHTTPRequestOperation *operation))success failureHandler:(void(^)(id responseObject, NSError * error))failure;

@end
