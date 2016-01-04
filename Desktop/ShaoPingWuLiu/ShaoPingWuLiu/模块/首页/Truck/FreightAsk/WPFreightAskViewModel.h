//
//  WPFreightAskViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPFreightAskViewModel : NSObject
+ (void)askFreshWithDate:(NSString *)date
            SuccessBlock:(void (^)(NSArray * freightArr))success
        andWithFailBlock:(void (^)(NSString * error))fail;
@end
