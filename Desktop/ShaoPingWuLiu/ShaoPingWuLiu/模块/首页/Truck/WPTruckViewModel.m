//
//  WPTruckViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/28.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTruckViewModel.h"
#import "NetWorkingManager+TruckNeed.h"

@implementation WPTruckViewModel
+ (void)getTruckNeedWithSuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getTruckTodayNeedWithSuccessHandler:^(id responseObject) {
        if ([responseObject count]) {
            NSMutableArray * resultArr = [NSMutableArray array];
            for (int i = 0; i < [responseObject count]-1; i++) {
                NSString * need = responseObject[i][@"xq"];
                [resultArr addObject:need];
            }
            if ([responseObject[[responseObject count] - 1] integerValue] == 3) {
                [UserDataStoreModel saveUserDataWithDataKey:@"status" andWithData:@(1) andWithReturnFlag:nil];
            } else {
                [UserDataStoreModel saveUserDataWithDataKey:@"status" andWithData:@(0) andWithReturnFlag:nil];
            }
            infoBlock(resultArr);
        } else {
            fail(@"暂无数据");
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
