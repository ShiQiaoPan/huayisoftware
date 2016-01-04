//
//  NetWorkingManager+TruckBasic.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (TruckBasic)
+ (AFHTTPRequestOperation *)submitTruckBasicWithDrivinglicense:(NSString *)drivinglicense
                                                   andPlateNumber:(NSString *)plateNum
                                                     imageData:(NSData *)imageData
                                                  andImageFile:(NSString *)imageFile
                                                successHandler:(void(^)(id responseObject, AFHTTPRequestOperation *operation))success
                                                failureHandler:(void(^)(id responseObject, NSError * error))failure;
+ (AFHTTPRequestOperation *)getTruckBasicInfoWithSuccessHandler:(SuccessBlock)success
                                                 failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)submitTruckBasicInfoWithParams:(NSMutableDictionary *)params
                                            successHandler:(SuccessBlock)success
                                            failureHandler:(FailureBlock)failure;


@end
