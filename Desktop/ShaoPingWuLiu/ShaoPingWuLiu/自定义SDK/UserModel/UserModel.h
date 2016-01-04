//
//  UserModel.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>
@property (nonatomic, assign) BOOL needAutoLogin;
@property (nonatomic, strong) NSString * userID;
/**< 用户基本信息在网络请求会用 */
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * token;/**< 判断用户各种状态 */
+ (UserModel *)defaultUser;
@end
