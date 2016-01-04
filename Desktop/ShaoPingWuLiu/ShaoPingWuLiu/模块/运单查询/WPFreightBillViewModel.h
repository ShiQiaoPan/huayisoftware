//
//  WPFreightBillViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/25.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPFreightBillViewModel : NSObject
+ (void)getFreightResultWithBillNum:(NSString *)billNum
                   WithSuccessBlock:(void(^)(NSArray * myInfo))infoBlock
                          failBlock:(void(^)(NSString * error))fail;
@end
