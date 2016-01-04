//
//  WPMoreDiscountViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMoreDiscountViewModel.h"
#import "NetWorkingManager+Discount.h"

@implementation WPMoreDiscountViewModel
+ (void)getDiscountDetailWithSuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getDiscountDetailWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if ([responseObject[@"datas"]count] == 0) {
                infoBlock([NSArray array]);
            } else {
                infoBlock(responseObject[@"datas"]);
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
