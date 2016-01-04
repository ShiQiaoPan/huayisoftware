//
//  WPAddMangerViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddMangerViewModel.h"
#import "NetWorkingManager+SendADD.h"
#import "NetWorkingManager+SaveADD.h"

@implementation WPAddMangerViewModel
+ (void)getAllSendAddressWithSuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllSendADDWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            
            if ([responseObject[@"datas"] count] > 0) {
                infoBlock(responseObject[@"datas"]);
            } else {
                infoBlock([NSArray array]);
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
+ (void)getAllReciveAddressWithSuccessBlock:(void (^)(NSArray *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllReciveADDWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"success"]integerValue]) {
            if ([responseObject[@"datas"] count] > 0) {
                infoBlock(responseObject[@"datas"]);
            } else {
                infoBlock([NSArray array]);
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
+ (void)deleteSigleSendAddressWithAddId:(NSString *)addId SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager deleteSendADDWithAddId:addId successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"删除地址成功");
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
+ (void)deleteSigleReciveAddressWithAddId:(NSString *)addId SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager deleteReciveADDWithAddId:addId successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"删除地址成功");
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
+ (void)addSendAddressWithName:(NSString *)personName phoneNum:(NSString *)phoneNum address:(NSString *)addrese SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager saveSendADDWithName:personName phone:phoneNum site:addrese successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"添加地址成功");
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
+ (void)addReciveAddressWithName:(NSString *)personName phoneNum:(NSString *)phoneNum address:(NSString *)addrese SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager saveReciveADDWithName:personName phone:phoneNum site:addrese successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"添加地址成功");
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
+ (void)setDefaultSendAddressWithAddId:(NSString *)addId SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager setDefaultSendADDWithAddID:addId successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"设置默认地址成功");
            }
        } else {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"设置默认地址失败");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
+ (void)setDefaultGetAddressWithAddId:(NSString *)addId SuccessBlock:(void (^)(NSString *))infoBlock failBlock:(void (^)(NSString *))fail {
    [NetWorkingManager setDefaultReciveADDWithAddId:addId successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"设置默认地址成功");
            }
        } else {
            if (responseObject[@"errMsg"]) {
                infoBlock(responseObject[@"errMsg"]);
            } else {
                infoBlock(@"设置默认地址失败");
            }
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}
@end
