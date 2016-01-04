//
//  WPAddExamViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/7.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAddExamViewModel : NSObject
+ (void)getAllExamTopWithSuccessBlock:(void (^)(NSArray * examArr))success
                     andWithFailBlock:(void (^)(NSString * error))fail;
+ (void)addExamTopWithExamDate:(NSString *)examDte
                   nextTopDate:(NSString *)topDate
              WithSuccessBlock:(void(^)(NSString * success))suc
                     failBlock:(void(^)(NSString * error))fail;
@end
