//
//  NetWorkingManager+DrawCash.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager+DrawCash.h"

@implementation NetWorkingManager (DrawCash)
+ (AFHTTPRequestOperation *)submitDrawCashWithCardInfo:(NSDictionary *)cardDic money:(NSString *)moneyCount password:(NSString *)pwd successHandler:(SuccessBlock)success failureHandler:(FailureBlock)failure{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:cardDic];
    params[@"username"] = [UserModel defaultUser].phoneNumber;
    params[@"money"] = @([moneyCount integerValue]);
    params[@"password"] = pwd;
    AFHTTPRequestOperation * operation = [self postWithUrl:@"withdraw/save" requestParams:params SuccessHandler:success failureHandler:failure];
    return operation;
}
@end
