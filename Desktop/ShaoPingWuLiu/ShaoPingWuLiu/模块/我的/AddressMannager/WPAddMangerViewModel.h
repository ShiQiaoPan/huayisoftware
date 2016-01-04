//
//  WPAddMangerViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAddMangerViewModel : NSObject
+ (void)getAllSendAddressWithSuccessBlock:(void(^)(NSArray * myInfo))infoBlock
                                failBlock:(void(^)(NSString * error))fail;
+ (void)addSendAddressWithName:(NSString *)personName
                      phoneNum:(NSString *)phoneNum
                       address:(NSString *)addrese
                  SuccessBlock:(void(^)(NSString * success))infoBlock
                     failBlock:(void(^)(NSString * error))fail;
+ (void)deleteSigleSendAddressWithAddId:(NSString *)addId
                           SuccessBlock:(void(^)(NSString * success))infoBlock
                        failBlock:(void(^)(NSString * error))fail;
+ (void)setDefaultSendAddressWithAddId:(NSString *)addId
                           SuccessBlock:(void(^)(NSString * success))infoBlock
                              failBlock:(void(^)(NSString * error))fail;

+ (void)getAllReciveAddressWithSuccessBlock:(void(^)(NSArray * myInfo))infoBlock
                                failBlock:(void(^)(NSString * error))fail;
+ (void)addReciveAddressWithName:(NSString *)personName
                      phoneNum:(NSString *)phoneNum
                       address:(NSString *)addrese
                  SuccessBlock:(void(^)(NSString * success))infoBlock
                     failBlock:(void(^)(NSString * error))fail;
+ (void)deleteSigleReciveAddressWithAddId:(NSString *)addId
                           SuccessBlock:(void(^)(NSString * success))infoBlock
                              failBlock:(void(^)(NSString * error))fail;
+ (void)setDefaultGetAddressWithAddId:(NSString *)addId
                          SuccessBlock:(void(^)(NSString * success))infoBlock
                             failBlock:(void(^)(NSString * error))fail;
@end
