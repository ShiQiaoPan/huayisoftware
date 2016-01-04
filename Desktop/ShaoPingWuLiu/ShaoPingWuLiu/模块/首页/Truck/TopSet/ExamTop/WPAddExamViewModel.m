//
//  WPAddExamViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/7.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddExamViewModel.h"
#import "NetWorkingManager+truckExam.h"

@implementation WPAddExamViewModel
+ (void)getAllExamTopWithSuccessBlock:(void (^)(NSArray *))success andWithFailBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllTruckExamWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if ([responseObject[@"datas"]count]) {
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
+ (void)addExamTopWithExamDate:(NSString *)examDte nextTopDate:(NSString *)topDate WithSuccessBlock:(void (^)(NSString *))suc failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager submitTruckExamWithEstarttime:examDte remindtime:topDate successHandler:^(id responseObject) {
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
