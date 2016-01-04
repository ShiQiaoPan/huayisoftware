//
//  UserDataStore.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/21.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataStoreModel : NSObject
+ (void)saveUserDataWithDataKey:(NSString *)key andWithData:(id) data andWithReturnFlag:(void(^)(NSInteger flag))complete;
+ (id)readUserDataWithDataKey:(NSString *)dataKey;
+ (void)clearUserData;
@end
