//
//  UserDataStore.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/21.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "UserDataStoreModel.h"

@implementation UserDataStoreModel
+ (void)saveUserDataWithDataKey:(NSString *)key andWithData:(id)data andWithReturnFlag:(void (^)(NSInteger))complete {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSMutableDictionary * existData = nil;
    if ([manager fileExistsAtPath:[self userDataPath]]) {
        existData = [NSMutableDictionary dictionaryWithContentsOfFile:[self userDataPath]];
    } else {
        existData = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    [existData setObject:data forKey:key];
    if ([existData writeToFile:[self userDataPath] atomically:YES]) {
        if (complete) {
            complete(1);
        }
    } else {
        if (complete) {
            complete(0);
        }
    }
}
+ (id)readUserDataWithDataKey:(NSString *)dataKey {
    NSMutableDictionary * existData = [NSMutableDictionary dictionaryWithContentsOfFile:[self userDataPath]];
    NSArray * keys = existData.allKeys;
    for (NSString * key in keys) {
        if ([key isEqualToString:dataKey]) {
            return existData[dataKey];
        }
    }
    return nil;
}
+ (void)clearUserData {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self userDataPath]]) {
        [manager removeItemAtPath:[self userDataPath] error:nil];
    }
}
+ (NSString *)userDataPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"userData.plist"];
    return fullPathToFile;
}

@end
