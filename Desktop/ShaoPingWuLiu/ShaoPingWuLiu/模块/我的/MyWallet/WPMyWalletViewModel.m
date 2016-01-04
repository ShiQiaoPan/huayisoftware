//
//  WPMyWalletViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMyWalletViewModel.h"
#import "NetWorkingManager+Balance.h"

@implementation WPMyWalletViewModel
+ (void)getMyWalletWithSuccessBlock:(void (^)(NSDictionary *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getWalletWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]&&responseObject[@"datas"]) {
            infoBlock(responseObject[@"datas"]);
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
