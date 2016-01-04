//
//  WPBoundBankCardViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBoundBankCardViewModel.h"
#import "NetWorkingManager+BoundBankCard.h"
@implementation WPBoundBankCardViewModel
+ (void)getBankCardsWithSuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllBankCardWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
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
+ (void)delegeteBankCardWithCardNum:(NSString *)cardNum SuccessBlock:(void (^)(NSString *))successBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager deleteSingleBankCardWithBankcardNum:cardNum SuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            successBlock(@"成功");
        } else {
            fail(@"失败");
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
