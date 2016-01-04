//
//  WPMaintenanceViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMaintenanceViewModel : NSObject
+ (void)getAllMaintenaceWithSuccessBlock:(void (^)(NSArray * maintenanceArr))success
                        andWithFailBlock:(void (^)(NSString * error))fail;
+ (void)addMaintenanceWithInsuranceDate:(NSString *)insuranceDate
                     andInsuranceDetail:(NSString *)insuranceDetail
                        andInsurancePay:(NSString *)pay
                            nextTopDate:(NSString *)topDate
                       WithSuccessBlock:(void(^)(NSString * success))suc
                              failBlock:(void(^)(NSString * error))fail;

@end
