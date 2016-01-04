//
//  UserModel.m
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import "UserModel.h"
#import "UserModelArchiver.h"
@implementation UserModel 
/**< 线程安全的单例创建 */
+ (UserModel *)defaultUser {
    static UserModel * model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [UserModelArchiver unarchiver];
        if (!model) {
            model = [[UserModel alloc]init];
        }
    });
    return model;
}
#pragma mark - getter
- (BOOL)needAutoLogin {
    BOOL need = [[NSUserDefaults standardUserDefaults]boolForKey:@"AutoLogin"];
    return need;
}

#pragma mark - NSCoding(归档)
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.userID = [aDecoder decodeObjectForKey:@"userId"];
    self.phoneNumber = [aDecoder decodeObjectForKey:@"phone"];
    self.password = [aDecoder decodeObjectForKey:@"password"];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userID forKey:@"userId"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phone"];
    [aCoder encodeObject:self.password forKey:@"password"];
}
@end
