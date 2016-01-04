//
//  WPTopUpViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTopUpViewModel.h"
#import "NetWorkingManager+TopUp.h"

@implementation WPTopUpViewModel
+ (void)submitTopUpWithBalance:(NSString *)balance WithSuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager submitTopupWithBalance:balance WithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            
        } else {
            fail(@"充值失败");
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
