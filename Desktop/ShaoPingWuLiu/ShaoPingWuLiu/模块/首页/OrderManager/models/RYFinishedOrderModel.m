//
//  RYFinishedOrderModel.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/11.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYFinishedOrderModel.h"

@implementation RYFinishedOrderModel

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.commitid = value;
    }
}

@end
