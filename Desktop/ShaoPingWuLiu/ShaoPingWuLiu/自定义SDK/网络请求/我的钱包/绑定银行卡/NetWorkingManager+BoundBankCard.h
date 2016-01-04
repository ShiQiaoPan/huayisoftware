//
//  NetWorkingManager+BoundBankCard.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/2.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (BoundBankCard)
+ (AFHTTPRequestOperation *)submitBoundBankCardWithCardNumber:(NSString *)cardNum
                                                     bankName:(NSString *)bankName
                                                  bindingname:(NSString *)personName
                                                          tel:(NSString *)phoneNum
                                               SuccessHandler:(SuccessBlock)success
                                         failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)getAllBankCardWithSuccessHandler:(SuccessBlock)success
                                              failureHandler:(FailureBlock)failure;
+ (AFHTTPRequestOperation *)deleteSingleBankCardWithBankcardNum:(NSString *)cardNum
                                                SuccessHandler:(SuccessBlock)success

                                                failureHandler:(FailureBlock)failure;
@end
