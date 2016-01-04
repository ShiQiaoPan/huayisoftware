//
//  MyInfoViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "MyInfoViewModel.h"
#import "NetWorkingManager+MyInfo.h"
#import "WKAlertView.h"

@implementation MyInfoViewModel
+ (void)getMyInfoWithSuccessBlock:(void (^)(NSDictionary *))infoBlock failBlock:(void (^)(NSString *))fail{
    [NetWorkingManager getMyInfoWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"]integerValue] == 0 &&[responseObject[@"datas"] count] > 0) {
            infoBlock(responseObject[@"datas"]);
        } else {
            if (responseObject[@"errMsg"]) {
                fail(responseObject[@"errMsg"]);
            } else {
                fail(@"网络数据错误");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
+ (void)submitHeadImageWithImageFile:(NSString *)imageFile andImageData:(NSData *)imageData successBlock:(void (^)(NSString *))success failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager submitHeadImageWithImageData:imageData andImageFile:imageFile successHandler:^(id responseObject, AFHTTPRequestOperation *operation) {
        if (![((NSDictionary *)operation)[@"code"] integerValue]) {
            success(@"上传成功");
        } else {
            fail(@"上传失败");
        }
        
    } failureHandler:^(id responseObject, NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
