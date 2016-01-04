//
//  WPTransportBeanViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTransportBeanViewModel : NSObject
+ (void)getBeanCountWithSuccessBlock:(void(^)(NSInteger  count))infoBlock
                           failBlock:(void(^)(NSString * error))fail;

+ (void)getBeanConversionWithSuccessBlock:(void(^)(NSString * success))infoBlock
                                failBlock:(void(^)(NSString * error))fail;
+ (void)changeBeanWithBeanCount:(NSString *)beanCount
                   SuccessBlock:(void(^)(NSString * success))infoBlock
                      failBlock:(void(^)(NSString * error))fail;



@end
