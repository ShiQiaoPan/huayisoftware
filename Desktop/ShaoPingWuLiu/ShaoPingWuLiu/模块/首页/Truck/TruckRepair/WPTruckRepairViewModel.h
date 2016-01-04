//
//  WPTruckRepairViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTruckRepairViewModel : NSObject
+ (void)getAllRepairRecordWithSuccessBlock:(void (^)(NSArray * repairArr))success
                          andWithFailBlock:(void (^)(NSString * error))fail;
+ (void)addRepairRecordWithRepairDate:(NSString *)repairDate
                        repairManName:(NSString *)repairManName
                     repairMoneyCount:(NSString *)moneyCount
                     repairDetailsArr:(NSArray *)detailsArr
                     WithSuccessBlock:(void(^)(NSString * success))suc
                            failBlock:(void(^)(NSString * error))fail;

@end
