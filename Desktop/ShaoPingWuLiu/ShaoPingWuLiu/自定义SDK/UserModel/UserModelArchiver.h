//
//  UserModelArchiver.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/14.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModelArchiver : NSObject
+ (UserModel *)unarchiver;
+ (void)archiver;
+ (NSString *)archivePath;
@end
