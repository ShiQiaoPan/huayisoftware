//
//  WPTruckBasicInfoViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTruckBasicInfoViewModel.h"
#import "NetWorkingManager+TruckBasic.h"

@implementation WPTruckBasicInfoViewModel
+ (void)getTruckBasicInfoWithSuccessBlock:(void (^)(NSDictionary *))success andWithFailBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getTruckBasicInfoWithSuccessHandler:^(id responseObject) {
        if ([responseObject count]) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            if ([responseObject[@"wd"] count]) {
                NSMutableDictionary * resultDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"wd"]];
                NSArray * keys = resultDic.allKeys;
                for (NSString * key in keys) {
                    resultDic[key] = resultDic[key] == [NSNull null]?@"":resultDic[key];
                }
                dict[@"COwner"] = resultDic[@"owner"];
                dict[@"COwnerPhone"] = resultDic[@"ownerphone"];
                dict[@"Driver"] = resultDic[@"driver"];
                dict[@"DriverPhone"] = resultDic[@"driverphone"];
                dict[@"DriveCard"] = resultDic[@"drivinglicence"];
                dict[@"IDCard"] = resultDic[@"driverid"];
                dict[@"CarNo"] = resultDic[@"numberplate"];
                dict[@"GCRQ"] = resultDic[@"purchasedata"];
                dict[@"Long"] = [NSString stringWithFormat:@"%.2f", [resultDic[@"vehiclelength"] floatValue]];;
                dict[@"Height"] = [NSString stringWithFormat:@"%.2f", [resultDic[@"chassisheight"] floatValue]];
                dict[@"Width"] = [NSString stringWithFormat:@"%.2f", [resultDic[@"accountname"] floatValue]];
                dict[@"BonnetNumber"] = resultDic[@"axescount" ];
                dict[@"BankHM"] = resultDic[@"accountname"];
                dict[@"BankName"] = resultDic[@"openingbank"];
                dict[@"BankNo"] = resultDic[@"accountno"];
                if ([responseObject[@"td"] count]) {
                    dict[@"JykNo"] = responseObject[@"td"][@"JykNo"];
                } else {
                    dict[@"JykNo"] = @"";
                }
                success(dict);
            } else {
                fail(@"没有车辆详细信息请填写");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
+ (void)submitTruckBasicInfoWithParams:(NSMutableDictionary *)params successBlock:(void (^)(NSString *))success andWithFailBlock:(void (^)(NSString *))fail{
    [NetWorkingManager submitTruckBasicInfoWithParams:params successHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if (responseObject[@"errMsg"]) {
                success(responseObject[@"errMsg"]);
            } else {
                success(@"提交成功");
            }
        } else {
            if (responseObject[@"errMsg"]) {
                success(responseObject[@"errMsg"]);
            } else {
                success(@"提交失败");
            }

        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
