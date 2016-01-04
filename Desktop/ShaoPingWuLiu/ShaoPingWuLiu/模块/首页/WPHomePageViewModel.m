//
//  WPHomePageViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPHomePageViewModel.h"
#import "NetWorkingManager+TruckStatus.h"
@implementation WPHomePageViewModel
+ (void)getTruckStatusWithSuccsessBlock:(void (^)(NSString *))sucess andFailBlock:(void (^)(NSString *))failure {
    [NetWorkingManager getTruckStatusWithSuccessHandler:^(id responseObject) {
        if (responseObject[@"state"]) {
            [UserDataStoreModel saveUserDataWithDataKey:@"truckStatus" andWithData:responseObject[@"state"] andWithReturnFlag:nil];
            sucess(@"成功");
        } else {
            failure(@"失败");
        }
    } failureHandler:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}
@end
