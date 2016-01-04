//
//  WPMaintenanceViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMaintenanceViewModel.h"
#import "NetWorkingManager+truckMaintenance.h"

@implementation WPMaintenanceViewModel
+ (void)getAllMaintenaceWithSuccessBlock:(void (^)(NSArray *))success andWithFailBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllMaintenanceWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if ([responseObject[@"datas"] count] == 0) {
                success([NSArray array]);
            } else {
                success(responseObject[@"datas"]);
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
+ (void)addMaintenanceWithInsuranceDate:(NSString *)insuranceDate andInsuranceDetail:(NSString *)insuranceDetail andInsurancePay:(NSString *)pay nextTopDate:(NSString *)topDate WithSuccessBlock:(void (^)(NSString *))suc failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager submitTruckMaintenanceWithMstarttime:insuranceDate mamount:pay mContent:insuranceDetail remindtime:topDate successHandler:^(id responseObject) {
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
