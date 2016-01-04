//
//  WPFreightBillViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/25.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPFreightBillViewModel.h"
#import "NetWorkingManager+FreightBillAsk.h"

@implementation WPFreightBillViewModel
+ (void)getFreightResultWithBillNum:(NSString *)billNum WithSuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getFreightBillWithBillNO:billNum SuccessHandler:^(id responseObject) {
        if ([responseObject count]) {
            infoBlock(responseObject[@"yd"]);
        } else {
            fail(@"暂无数据");
        }
    } FailureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
