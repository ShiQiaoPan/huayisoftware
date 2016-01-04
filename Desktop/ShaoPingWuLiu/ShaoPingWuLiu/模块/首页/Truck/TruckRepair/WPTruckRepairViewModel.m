//
//  WPTruckRepairViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTruckRepairViewModel.h"
#import "NetWorkingManager+TruckRepair.h"

@implementation WPTruckRepairViewModel
+ (void)getAllRepairRecordWithSuccessBlock:(void (^)(NSArray *))success andWithFailBlock:(void (^)(NSString *))fail {
 [NetWorkingManager getAllRepairWithSuccessHandler:^(id responseObject) {
     if ([responseObject[@"code"]integerValue] == 0) {
         if ([responseObject[@"datas"] count] == 0) {
             success([NSArray array]);
         } else {
             NSMutableArray * datas = [NSMutableArray arrayWithArray:responseObject[@"datas"]];
             for (int j = 0; j < datas.count; j++) {
                 NSDictionary * dic = datas[j];
                 NSArray * keys = dic.allKeys;
                 NSMutableDictionary * resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
                 for (NSString * key in keys) {
                     if ([key isEqualToString:@"mcontents"]) {
                         NSMutableArray * contentArr = [NSMutableArray arrayWithArray:dic[@"mcontents"]];
                         for (int i = 0; i < contentArr.count; i++) {
                             NSDictionary * contentDic = contentArr[i];
                             NSArray * contentKeys = contentDic.allKeys;
                             NSMutableDictionary * contentResultDic = [NSMutableDictionary dictionaryWithCapacity:0];
                             for (NSString * contentKey in contentKeys) {
                                 id content = contentDic[contentKey] == [NSNull null] ? @"":contentDic[contentKey];
                                 [contentResultDic setObject:content forKey:contentKey];
                             }
                             [contentArr replaceObjectAtIndex:i withObject:contentResultDic];
                         }
                         [resultDic setObject:contentArr forKey:key];
                         continue;
                     }
                     id info = dic[key]==[NSNull null]? @"":dic[key];
                     [resultDic setObject:info forKey:key];
                     [datas replaceObjectAtIndex:j withObject:resultDic];
                 }
             }
             success(datas);
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
+ (void)addRepairRecordWithRepairDate:(NSString *)repairDate repairManName:(NSString *)repairManName repairMoneyCount:(NSString *)moneyCount repairDetailsArr:(NSArray *)detailsArr WithSuccessBlock:(void (^)(NSString *))suc failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager submitRepairWithFfdate:repairDate serviceman:repairManName sercivemoney:moneyCount servicecontent:detailsArr successHandler:^(id responseObject) {
        if ([responseObject[@"code"]integerValue]== 0) {
            if (responseObject[@"errMsg"]) {
                suc(responseObject[@"errMsg"]);
            } else {
                suc(@"提交成功");
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
