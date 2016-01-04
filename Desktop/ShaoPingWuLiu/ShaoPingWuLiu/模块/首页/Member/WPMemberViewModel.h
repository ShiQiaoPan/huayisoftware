//
//  WPMemberViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WPMemberViewModel : NSObject
+ (void)getAllMemberWithSuccessBlock:(void (^)(NSDictionary * memberResult))success
                    andWithFailBlock:(void (^)(NSString * error))fail;
@end
