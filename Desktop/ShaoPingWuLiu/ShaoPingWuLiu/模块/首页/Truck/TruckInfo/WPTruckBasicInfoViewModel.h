//
//  WPTruckBasicInfoViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTruckBasicInfoViewModel : NSObject
+ (void)getTruckBasicInfoWithSuccessBlock:(void (^)(NSDictionary * basicSuc))success
                         andWithFailBlock:(void (^)(NSString * error))fail;
+ (void)submitTruckBasicInfoWithParams:(NSMutableDictionary *)params
                          successBlock:(void (^)(NSString * basicSuc))success
                      andWithFailBlock:(void (^)(NSString * error))fail;
@end
