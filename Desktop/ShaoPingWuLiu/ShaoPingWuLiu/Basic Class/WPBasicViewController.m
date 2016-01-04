//
//  BasicViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/5.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBasicViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "WPLoginViewController.h"

@interface WPBasicViewController ()

@end

@implementation WPBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customBaseNavigationBar];
    [self.view addSubview:self.baseNavigationBar];
    [self checkNetWork];
}
#pragma mark - init
- (void)customBaseNavigationBar {
    self.baseNavigationBar = [[UIView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 0, ORIGIN_WIDTH, 64), NO)];
    self.baseNavigationBar.backgroundColor = COLOR_RGB(240, 81, 51, 1);
    [self.baseNavigationBar addSubview:self.leftButton];
    [self.baseNavigationBar addSubview:self.rightButton];
    [self.baseNavigationBar addSubview:self.titleLable];
    [self.leftButton addTarget:self action:@selector(respondsToNavBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(respondsToNavBarRightButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeAlertControllerWithMessage:(NSString *)msg {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)initializeAlertControllerWithMessageAndDismiss:(NSString *)msg {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)initializeAlertControllerWithMessage:(NSString *)msg withHandelBlock:(void(^)(id action)) action {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:action]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - respondsToButton
- (void)respondsToNavBarLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = DHFlexibleFrame(CGRectMake(0, 24, 65, 40), YES);
            [button setImage:IMAGE_NAME(@"返回按钮.png") forState:UIControlStateNormal];
            button;
        });
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = DHFlexibleFrame(CGRectMake(255, 24, 65, 40), YES);
            button.titleLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
            button;
        });
    }
    return _rightButton;
}
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = ({
            UILabel * lable = [[UILabel alloc]initWithFrame:DHFlexibleFrame(CGRectMake(50, 24, 220, 40), YES)];
            lable.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            lable;
        });
    }
    return _titleLable;
}

#pragma mark - 检测网络
- (void)checkNetWork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,未知
         AFNetworkReachabilityStatusNotReachable     = 0,没有
         AFNetworkReachabilityStatusReachableViaWWAN = 1,要钱
         AFNetworkReachabilityStatusReachableViaWiFi = 2,不要钱
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网络
                [self initializeAlertControllerWithMessageAndDismiss:@"网络连接断开，请检查网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //   [self showAVwithString:@"您使用的是 2G/3G/4G 网络,确定要继续吗？"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //   [self showAVwithString:@"您使用的是wifi"];
            }
                break;
            default:
                break;
        }
        
    }];
}
- (BOOL) loginStatus {
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"]) {
        [self.navigationController pushViewController:[WPLoginViewController new] animated:YES];
    }
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
}
@end
