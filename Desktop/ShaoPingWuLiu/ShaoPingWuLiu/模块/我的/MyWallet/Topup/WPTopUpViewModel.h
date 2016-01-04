//
//  WPTopUpViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTopUpViewModel : NSObject
+ (void)submitTopUpWithBalance:(NSString *)balance
              WithSuccessBlock:(void(^)(NSString * success))infoBlock
                     failBlock:(void(^)(NSString * error))fail;

@end
