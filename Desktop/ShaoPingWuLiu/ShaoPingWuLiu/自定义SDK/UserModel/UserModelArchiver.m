//
//  UserModelArchiver.m
//  813DeepBreathing
//
//  Created by rimi on 15/8/14.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import "UserModelArchiver.h"

@implementation UserModelArchiver
+ (void)archiver {
    BOOL flag = [NSKeyedArchiver archiveRootObject:[UserModel defaultUser] toFile:[self archivePath]];
    if (!flag) {
        
    }
}
+ (UserModel *)unarchiver {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
}
+ (NSString *)archivePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = paths.count > 0 ? paths.firstObject :nil;
    return [basePath stringByAppendingString:@"/UserModel.date"];
}
@end
