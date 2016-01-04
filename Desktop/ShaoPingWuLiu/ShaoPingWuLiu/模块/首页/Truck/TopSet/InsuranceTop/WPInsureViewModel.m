//
//  WPInsureViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPInsureViewModel.h"
#import "NetWorkingManager+truckInsurance.h"

@implementation WPInsureViewModel
+ (void)getAllInsuranceWithSuccessBlock:(void (^)(NSArray *))success andWithFailBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllInsuranceWithSuccessHandler:^(id responseObject) {
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
+ (void)addInsuranceWithBuyDate:(NSString *)buyDate insuranceDetail:(NSString *)detail startTime:(NSString *)startDate endTime:(NSString *)endDate insurancePay:(NSString *)pay nextTopDate:(NSString *)topDate WithSuccessBlock:(void (^)(NSString *))suc failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager submitTruckInsuranceWithIstarttime:buyDate details:detail starttime:startDate iendtime:endDate insurance:pay remindtime:topDate successHandler:^(id responseObject) {
        if ([responseObject[@"code"]integerValue] == 0) {
            if (responseObject[@"errMsg"]) {
                suc(responseObject[@"errMsg"]);
            } else {
                suc(@"网络数据错误");
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
