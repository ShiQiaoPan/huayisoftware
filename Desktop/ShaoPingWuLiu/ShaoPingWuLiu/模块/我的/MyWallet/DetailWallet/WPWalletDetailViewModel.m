//
//  WPWalletDetailViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPWalletDetailViewModel.h"
#import "NetWorkingManager+WallerDetail.h"

@implementation WPWalletDetailViewModel
+ (void)getAllWalletDateWitSuccessBlock:(void (^)(NSArray *))success failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getWalletDetailWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if ([responseObject[@"datas"] count]) {
                success(responseObject[@"datas"]);
            } else {
                success([NSArray array]);
            }
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
+ (void)getMyWalletDetailWithTradetype:(NSString *)type date:(NSString *)date SuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getWalletDetailWithDate:date tradetype:type SuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if ([responseObject[@"datas"] count]) {
                infoBlock(responseObject[@"datas"]);
            } else {
                infoBlock([NSArray array]);
            }
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
@end
