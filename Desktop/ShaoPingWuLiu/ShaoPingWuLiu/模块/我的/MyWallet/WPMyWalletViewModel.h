//
//  WPMyWalletViewModel.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMyWalletViewModel : NSObject
+ (void)getMyWalletWithSuccessBlock:(void(^)(NSDictionary * myWallet))infoBlock
                        failBlock:(void(^)(NSString * error))fail;
@end
