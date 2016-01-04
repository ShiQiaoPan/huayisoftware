//
//  ControllerManager.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHTabViewController.h"

@interface ControllerManager : NSObject
@property (nonatomic, strong, readonly) UINavigationController *rootViewController;
@property (nonatomic, readonly)DHTabViewController *mainTabController;

+ (ControllerManager *)sharedManager;
@end
