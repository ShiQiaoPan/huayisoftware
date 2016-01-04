//
//  WPInsureViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPInsureViewModel : NSObject
+ (void)getAllInsuranceWithSuccessBlock:(void (^)(NSArray * insuranceArr))success
                     andWithFailBlock:(void (^)(NSString * error))fail;
+ (void)addInsuranceWithBuyDate:(NSString *)buyDate
                insuranceDetail:(NSString *)detail
                      startTime:(NSString *)startDate
                        endTime:(NSString *)endDate
                   insurancePay:(NSString *)pay
                          nextTopDate:(NSString *)topDate
              WithSuccessBlock:(void(^)(NSString * success))suc
                     failBlock:(void(^)(NSString * error))fail;

@end
