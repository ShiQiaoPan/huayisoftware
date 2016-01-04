//
//  WPFreightAskViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPFreightAskViewModel.h"
#import "NetWorkingManager+Freight.h"

@implementation WPFreightAskViewModel
+ (void)askFreshWithDate:(NSString *)date SuccessBlock:(void (^)(NSArray *))success andWithFailBlock:(void (^)(NSString *))fail {
    [NetWorkingManager freightAskWithDate:date successHandler:^(id responseObject) {
        if ([responseObject count] >0) {
            success([NSArray arrayWithObject:responseObject]);
        } else {
            fail(@"没有数据");
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
