//
//  WPLinkModelViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPLinkModelViewModel.h"
#import "NetWorkingManager+LinkModel.h"

@implementation WPLinkModelViewModel
+ (void)getLinkModelWithSuccessBlock:(void (^)(NSDictionary *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllPersonWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"]integerValue]== 0&&responseObject[@"datas"]) {
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
+ (void)deleteSingleLinkModelWithCardNum:(NSString *)cardNum SuccessBlock:(void (^)(NSString *))successBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager deleteLinkPersonWithLinkPersonId:cardNum successHandler:^(id responseObject) {
        if ([responseObject[@"code"]integerValue] == 0) {
            if (responseObject[@"errMsg"]) {
                successBlock(responseObject[@"errMsg"]);
            } else {
                successBlock(@"删除关联联系人成功");
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
