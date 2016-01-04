//
//  WPWalletDetailViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPWalletDetailViewModel : NSObject
+ (void)getAllWalletDateWitSuccessBlock:(void(^)(NSArray * detailArr))success
                              failBlock:(void(^)(NSString * error))fail;
+ (void)getMyWalletDetailWithTradetype:(NSString *)type
                                  date:(NSString *)date
                          SuccessBlock:(void(^)(NSArray * myWallet))infoBlock
                             failBlock:(void(^)(NSString * error))fail;

@end
