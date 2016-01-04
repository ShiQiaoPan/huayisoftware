//
//  NetWorkingManager+MyInfo.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+MyInfo.h"
#import "URL.h"

@implementation NetWorkingManager (MyInfo)
+ (AFHTTPRequestOperation *)getMyInfoWithSuccessHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure {
    NSDictionary * parmas = [self paramsByAppendingUserInfo:@{@"username":[UserModel defaultUser].phoneNumber}];
    AFHTTPRequestOperation * operation = [self postWithUrl:@"member/my" requestParams:parmas SuccessHandler:success failureHandler:failure];
    return operation;
}
+ (AFHTTPRequestOperation *)submitHeadImageWithImageData:(NSData *)imageData andImageFile:(NSString *)imageFile successHandler:(void(^)(id responseObject, AFHTTPRequestOperation *operation))success failureHandler:(void(^)(id responseObject, NSError * error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation * operation = [manager POST:[NSString stringWithFormat:@"%@member/upfavicon", BASIC_URL] parameters:@{@"username":[UserModel defaultUser].phoneNumber} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"favicon" fileName:imageFile mimeType:@"png/jpg"];
    } success:success failure:failure];
    return operation;
}
@end
