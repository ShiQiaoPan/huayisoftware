//
//  WPMemberViewModel.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMemberViewModel.h"
#import "NetWorkingManager+Member.h"

@implementation WPMemberViewModel

+ (void)getAllMemberWithSuccessBlock:(void (^)(NSDictionary *))success andWithFailBlock:(void (^)(NSString *))fail {
    [NetWorkingManager getAllMemberWithSuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"]integerValue] == 0) {
            NSMutableString * company = [NSMutableString new];
            NSMutableString * joinWay = [NSMutableString new];
            NSMutableString * contactWay = [NSMutableString new];
            NSArray * modelWays = responseObject[@"datas"][0][@"s"];
            for (int i = 0; i < modelWays.count; i++) {
                [joinWay appendString:modelWays[i]];
                if (i != modelWays.count - 1) {
                    [joinWay appendString:@"\n"];
                }
            }
            NSArray * members = responseObject[@"datas"][1][@"m"];
            for (int i = 0; i < members.count; i++) {
                NSMutableString * sigleCompany = [NSMutableString stringWithString:members[i]];
                [sigleCompany insertString:@"《" atIndex:0];
                [sigleCompany insertString:@"》" atIndex:sigleCompany.length];
                [company appendString:sigleCompany];
                if (i != modelWays.count - 1) {
                    [company appendString:@"\n"];
                }
            }
            NSArray * contactWays = responseObject[@"datas"][2][@"lx"];
            for (int i = 0; i < contactWays.count; i++) {
                [contactWay appendString:modelWays[i]];
                if (i != modelWays.count - 1) {
                    [contactWay appendString:@"\n"];
                }
            }
            NSDictionary * resultDic = @{@"joinWay":joinWay, @"contactWay":contactWay, @"company":company};
            success(resultDic);
        } else {
            fail(@"网络数据错误");
        }
    } failureHandler:^(NSError *error) {
        fail(error.localizedDescription);
    }];
}

@end
