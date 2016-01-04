//
//  WPTransportBeanViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTransportBeanViewModel.h"
#import "NetWorkingManager+GetBean.h"

@implementation WPTransportBeanViewModel
+ (void)getBeanCountWithSuccessBlock:(void (^)(NSInteger))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getBeanCountWithsuccessHandler:^(id responseObject) {
        if (responseObject[@"transportbean"]) {
            infoBlock( [responseObject[@"transportbean"] integerValue]);
        } else {
            if (responseObject[@"errMsg"]) {
                fail(responseObject[@"errMsg"]);
            } else {
                fail(@"数据出错");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
+ (void)getBeanConversionWithSuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail{
    [NetWorkingManager getBeanConversionWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"datas"] count] > 0) {
                NSInteger proportion = [responseObject[@"datas"][@"proportion"] integerValue];
                infoBlock([NSString stringWithFormat:@"%ld", proportion]);
            } else {
                infoBlock(responseObject[@"errMsg"]);
            }
        } else {
            if (responseObject[@"errMsg"]) {
                fail(responseObject[@"errMsg"]);
            } else {
                fail(@"获取失败");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
+ (void)changeBeanWithBeanCount:(NSString *)beanCount SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager payBeanWithBeanCount:beanCount successHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"提交成功");
            }
        } else {
            if (responseObject[@"errMsg"]) {
                fail(responseObject[@"errMsg"]);
            } else {
                fail(@"提交失败");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
