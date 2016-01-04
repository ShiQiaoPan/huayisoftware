//
//  MyInfoViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfoViewModel : NSObject
+ (void)getMyInfoWithSuccessBlock:(void(^)(NSDictionary * myInfo))infoBlock
                        failBlock:(void(^)(NSString * error))fail;
+ (void)submitHeadImageWithImageFile:(NSString *)imageFile
                        andImageData:(NSData *)imageData
                        successBlock:(void(^)(NSString * success))success
                           failBlock:(void(^)(NSString * error))fail;
@end
