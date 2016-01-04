//
//  ControllerManager.m
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import "ControllerManager.h"

@interface ControllerManager ()
@property (nonatomic, strong)UINavigationController *rootViewController;
@property (nonatomic, strong)DHTabViewController *mainTabController;

@end
@implementation ControllerManager
+ (ControllerManager *)sharedManager {
    /**< 线程安全的单例创建 */
        static ControllerManager *manager;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[ControllerManager alloc]init];
        });
        return manager;
}
#pragma mark - getter
- (UINavigationController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [[UINavigationController alloc]initWithRootViewController:self.mainTabController];
        _rootViewController.navigationBarHidden = YES;
        _rootViewController.toolbarHidden = YES;
    }
    return _rootViewController;
}
- (DHTabViewController *)mainTabController {
    if (!_mainTabController) {
        NSArray * controllerClassNames =@[@"WPHomePageViewController",
                                          @"WPConsignmentViewController",
                                          @"WPMyInfoViewController"];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
        [controllerClassNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Class class = NSClassFromString(obj);
//            *stop = YES;/**< 停止遍历 */
            UIViewController *controller = [[class alloc]init];
            [viewControllers addObject:controller];
        }];
        NSArray *tabItemImages = @[@"home2.png",
                                          @"send.png",
                                          @"me1.png"];;
        NSArray *tabItemSelectedImages = @[@"home.png",
                                                  @"send.png",
                                                  @"me2.png"];
        // 生成tabController
        _mainTabController = ({
            DHTabViewController * controller = [[DHTabViewController alloc] initWithViewControllers:viewControllers barItemImages:tabItemImages barItemSelectedImages:tabItemSelectedImages];
            controller;
        });
    }
    return _mainTabController;
}
@end
