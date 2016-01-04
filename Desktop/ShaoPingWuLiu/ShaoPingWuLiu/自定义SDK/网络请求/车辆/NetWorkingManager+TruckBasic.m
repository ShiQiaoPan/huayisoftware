//
//  NetWorkingManager+TruckBasic.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+TruckBasic.h"
#import "URL.h"

@implementation NetWorkingManager (TruckBasic)
+ (AFHTTPRequestOperation *)submitTruckBasicWithDrivinglicense:(NSString *)drivinglicense andPlateNumber:(NSString *)plateNum imageData:(NSData *)imageData andImageFile:(NSString *)imageFile successHandler:(void (^)(id, AFHTTPRequestOperation *))success failureHandler:(void (^)(id, NSError *))failure{
    
    NSDictionary * params = @{@"drivinglicense":drivinglicense, @"platenumber":plateNum, @"username":[UserModel defaultUser].phoneNumber};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager POST:[NSString stringWithFormat:@"%@vehicle/save", BASIC_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"dlpicture" fileName:imageFile mimeType:@"png/jpg"];
    } success:success failure:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)submitTruckBasicInfoWithParams:(NSMutableDictionary *)params successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    params[@"vehicle.id"] = [UserModel defaultUser].userID;
    AFHTTPRequestOperation * operation = [self postWithUrl:@"vehicledata/save" requestParams:params SuccessHandler:success failureHandler:failure];
    NSLog(@"%@", params);
    return operation;
}
+ (AFHTTPRequestOperation *)getTruckBasicInfoWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * params = [self paramsByAppendingUserInfo:nil];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"vehicledata/get" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}

@end
