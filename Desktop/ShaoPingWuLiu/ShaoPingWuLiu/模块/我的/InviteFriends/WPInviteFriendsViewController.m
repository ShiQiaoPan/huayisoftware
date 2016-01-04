//
//  InviteFriendsViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPInviteFriendsViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "NetWorkingManager+OringKey.h"

#define BTNTAG 200
@interface WPInviteFriendsViewController ()
@property (nonatomic, strong) UILabel * inviteNumLabel;
@property (nonatomic, strong) UILabel * introLabel;
@property (nonatomic, strong) UILabel * InviteTitleLabel;
@property (nonatomic, strong) UIButton * qqBtn;
@property (nonatomic, strong) UIButton * weiXinBtn;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeDataSource];
}

#pragma mark - init
- (void)initializeDataSource {
    if ([UserDataStoreModel  readUserDataWithDataKey:@"orangKey"]) {
        return;
    }
    __weak typeof(self)weakself = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"获取邀请码中";
    [NetWorkingManager getOrangeWithSuccessHandler:^(id responseObject) {
        if (responseObject[@"prangekey"]) {
            hud.labelText = @"获取邀请码成功";
            hud.detailsLabelText = nil;
            weakself.inviteNumLabel.text = responseObject[@"prangekey"] == [NSNull null] ? @"请联系管理员分配邀请码":responseObject[@"prangkey"];
            [UserDataStoreModel saveUserDataWithDataKey:@"orangKey" andWithData:responseObject[@"prangekey"]  andWithReturnFlag:nil];
        } else {
            hud.labelText = @"网络数据错误";
            hud.detailsLabelText = nil;
        }
        [hud hide:YES afterDelay:1.0];

    } failureHandler:^(NSError *error) {
        hud.detailsLabelText = @"获取失败";
        [hud hide:YES afterDelay:2.0];
    }];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"邀请好友";
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.inviteNumLabel];
    [self.view addSubview:self.introLabel];
    [self.view addSubview:self.InviteTitleLabel];
    [self DrawLine];
    [self.view addSubview:self.qqBtn];
    [self.view addSubview:self.weiXinBtn];
}
#pragma mark - private methods
- (void)DrawLine {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, ORIGIN_HEIGHT), NO);
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path moveToPoint:DHFlexibleCenter(CGPointMake(10, 220))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(100, 220))];
    
    [path moveToPoint:DHFlexibleCenter(CGPointMake(220, 220))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(310, 220))];
    maskLayer.path = path.CGPath;
    [self.view.layer addSublayer:maskLayer];
}
#pragma mark - responds events
- (void)respondsToSharedBtn:(UIButton *)sender {
    if (sender.tag == BTNTAG) {
        [self QQShared];
        return;
    }
    [self wechatShared];
}
#pragma mark - private methods
- (void)QQShared {
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[IMAGE_CONTENT(@"扫描框@2x.png")];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://www.mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
    }
    
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self initializeAlertControllerWithMessage:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [self initializeAlertControllerWithMessage:[NSString stringWithFormat:@"分享失败\n%@",error]];
                break;
            }
            case SSDKResponseStateCancel:
            {
                [self initializeAlertControllerWithMessage:@"分享已取消"];
                break;
            }
            default:
                break;
        }
        
    }];

}
- (void)wechatShared {
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[IMAGE_CONTENT(@"扫描框@2x.png")];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                         images:nil
                                            url:[NSURL URLWithString:@"http://www.mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeText];
    }
    
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self initializeAlertControllerWithMessage:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [self initializeAlertControllerWithMessage:[NSString stringWithFormat:@"分享失败\n%@",error]];
                break;
            }
            case SSDKResponseStateCancel:
            {
                [self initializeAlertControllerWithMessage:@"分享已取消"];
                break;
            }
            default:
                break;
        }
        
    }];

}
#pragma mark - getter
- (UILabel *)inviteNumLabel {
    if (!_inviteNumLabel) {
        _inviteNumLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,320, 40) adjustWidth:NO];
            label.textColor = COLOR_RGB(252, 130, 59, 1);
            label.font = [UIFont systemFontOfSize:30];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [UserDataStoreModel  readUserDataWithDataKey:@"orangKey"];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
    }
    return _inviteNumLabel;
}
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 160,320, 40) adjustWidth:NO];
            label.textColor = COLOR_RGB(200, 201, 202, 1);
            label.text = @"邀请好友即可获得优惠劵";
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _introLabel;
}
- (UILabel *)InviteTitleLabel {
    if (!_InviteTitleLabel) {
        _InviteTitleLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200,320, 40) adjustWidth:NO];
            label.textColor = COLOR_RGB(200, 201, 202, 1);
            label.text = @"邀请您的好友";
            label.textAlignment = NSTextAlignmentCenter;
            label;

        });
    }
    return _InviteTitleLabel;
}
- (UIButton *)qqBtn {
    if (!_qqBtn) {
        _qqBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(88, 250, 60, 80), YES);
            [btn setImage:IMAGE_CONTENT(@"qq.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToSharedBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = BTNTAG;
            btn;
        });
    }
    return _qqBtn;
}
- (UIButton *)weiXinBtn{
    if (!_weiXinBtn) {
        _weiXinBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(180, 250, 60, 80), YES);
            [btn setImage:IMAGE_CONTENT(@"wechat.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToSharedBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = BTNTAG + 1;
            btn;
        });
    }
    return _weiXinBtn;
}
@end
