//
//  WPLinkModelViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPLinkModelViewModel : NSObject
+ (void)getLinkModelWithSuccessBlock:(void(^)(NSDictionary * myInfo))infoBlock
                        failBlock:(void(^)(NSString * error))fail;

+ (void)deleteSingleLinkModelWithCardNum:(NSString *)cardNum
                       SuccessBlock:(void(^)(NSString * success))successBlock
                          failBlock:(void(^)(NSString * error))fail;
@end
