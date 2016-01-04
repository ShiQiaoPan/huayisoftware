//
//  WPBoundBankCardViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPBoundBankCardViewModel : NSObject
+ (void)getBankCardsWithSuccessBlock:(void(^)(NSArray * bankCards))infoBlock
                           failBlock:(void(^)(NSString * error))fail;
+ (void)delegeteBankCardWithCardNum:(NSString *)cardNum
                       SuccessBlock:(void(^)(NSString * success))successBlock
                          failBlock:(void(^)(NSString * error))fail;
@end
