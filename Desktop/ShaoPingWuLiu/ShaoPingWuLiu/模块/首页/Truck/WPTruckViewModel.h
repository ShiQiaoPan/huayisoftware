//
//  WPTruckViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/28.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTruckViewModel : NSObject
+ (void)getTruckNeedWithSuccessBlock:(void(^)(NSArray * truckNeeds))infoBlock
                        failBlock:(void(^)(NSString * error))fail;
@end
