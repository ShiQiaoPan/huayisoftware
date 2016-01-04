//
//  BasicViewController.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/5.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPBasicViewController : UIViewController
@property (nonatomic, strong)UIView *baseNavigationBar;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UILabel * titleLable;
@property (nonatomic, strong) UIButton * rightButton;

- (void)respondsToNavBarLeftButton;
- (void)respondsToNavBarRightButton:(UIButton *)sender;
- (void)initializeAlertControllerWithMessage:(NSString *)msg;
- (void)initializeAlertControllerWithMessageAndDismiss:(NSString *)msg;
- (void)initializeAlertControllerWithMessage:(NSString *)msg withHandelBlock:(void(^)(id action)) action;
//- (void) checkNetwork;
- (BOOL) loginStatus;
@end
