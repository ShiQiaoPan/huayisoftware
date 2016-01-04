//
//  WPHomePageViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPHomePageViewModel : NSObject
+ (void)getTruckStatusWithSuccsessBlock:(void(^)(NSString *succ))sucess
                           andFailBlock:(void(^)(NSString * fail))failure;
@end
