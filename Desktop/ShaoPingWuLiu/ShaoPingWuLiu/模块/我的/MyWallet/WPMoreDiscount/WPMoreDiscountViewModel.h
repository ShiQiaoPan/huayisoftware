//
//  WPMoreDiscountViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMoreDiscountViewModel : NSObject
+ (void)getDiscountDetailWithSuccessBlock:(void(^)(NSArray * discount))infoBlock
                          failBlock:(void(^)(NSString * error))fail;
@end
