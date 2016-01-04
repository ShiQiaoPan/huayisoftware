//
//  WPMemberViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMemberViewController.h"
#import "WPJoinViewController.h"
#import "WPLoginViewController.h"
#import "WPMemberViewModel.h"
#import "DottedLineLabel.h"
#define MEMBERFONT [UIFont systemFontOfSize:13]

#define MODELINTRO @"目前大型货车比较短缺，车辆供应不过来！需要大批的车辆来源。    \n\n目前大型货车比较短缺，车辆供应不过来！需要大批的车辆来源。目前大型货车比较短缺，车辆供应不过来！需要大批的车辆来源。    \n\n目前大型货车比较短缺，车辆供应不过来！需要大批的车辆来源。目前大型货车比较短缺，车辆供应不过来！需要大批的车辆来源。    \n\n目前大型货车比较短缺，车辆供应不过来！需要大批的车辆来源。"
#define PATERNER @"《成都凯捷物流公司》\n《成都凯捷物流公司》\n《成都凯捷物流公司》\n《成都凯捷物流公司》\n《成都凯捷物流公司》\n《成都凯捷物流公司》\n《成都凯捷物流公司》"

#define CONTACTINTRO @"总部地址：成都金牛区五块石北城天街29栋9楼\n公司官网：www.spwlw.com\n服务热线：028-66000100/66006114 \r微信账号：cdspwl"

@interface WPMemberViewController ()
@property (nonatomic, strong) UIScrollView * memberScrollView;
@property (nonatomic, strong) DottedLineLabel * modelLabel;
@property (nonatomic, strong) UIImageView * modelImageView;
@property (nonatomic, strong) DottedLineLabel * memberLabel;
@property (nonatomic, strong) UIImageView * memberImageView;
@property (nonatomic, strong) DottedLineLabel * contactLabel;
@property (nonatomic, strong) UIImageView * contactImageView;
@property (nonatomic, strong) UIButton * joinBtn;/**< 加盟按钮 */

@property (nonatomic, strong) UIBezierPath * path;/**< 贝塞尔 */
- (void)initializeUserInterface; /**< 初始化用户界面 */


@end

@implementation WPMemberViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在获取网络数据";
    __weak typeof(self)weakself = self;
    [WPMemberViewModel getAllMemberWithSuccessBlock:^(NSDictionary * memberResult) {
        hud.labelText = @"获取网络数据成功";
        hud.detailsLabelText = @"刷新数据中...";
        [hud hide:YES afterDelay:1.0];
        [UserDataStoreModel saveUserDataWithDataKey:@"memberResult" andWithData:memberResult andWithReturnFlag:nil];
        for (UIView * view in weakself.memberScrollView.subviews) {
            [view removeFromSuperview];
        }
        weakself.modelLabel = nil;
        weakself.memberImageView = nil;
        weakself.memberLabel = nil;
        weakself.contactImageView = nil;
        weakself.contactLabel = nil;
        weakself.joinBtn = nil;
        CGFloat height = [self culculateHeightWithText:PATERNER font:MEMBERFONT];
        weakself.memberLabel.frame = CGRectMake(20, CGRectGetMaxY(self.memberImageView.frame) + 10, CGRectGetWidth(self.view.frame)-40, height);
        weakself.memberLabel.text = PATERNER;
        [weakself.memberScrollView addSubview:weakself.modelImageView];
        [weakself.memberScrollView addSubview:weakself.modelLabel];
        [weakself.memberScrollView addSubview:weakself.memberImageView];
        [weakself.memberScrollView addSubview:weakself.memberLabel];
        [weakself.memberScrollView addSubview:weakself.contactImageView];
        [weakself.memberScrollView addSubview:weakself.contactLabel];
        [weakself.memberScrollView addSubview:weakself.joinBtn];
        weakself.memberScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(weakself.joinBtn.frame)+100);
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"获取网络数据失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"盟商";
    [self.view addSubview:self.memberScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.memberScrollView addSubview:self.modelImageView];
    [self.memberScrollView addSubview:self.modelLabel];
    [self.memberScrollView addSubview:self.memberImageView];
    [self.memberScrollView addSubview:self.memberLabel];
    [self.memberScrollView addSubview:self.contactImageView];
    [self.memberScrollView addSubview:self.contactLabel];
    [self.memberScrollView addSubview:self.joinBtn];
    self.memberScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.joinBtn.frame)+100);
}
#pragma mark - respond events
- (void)respondsToJoinBtn {
    if (![UserModel defaultUser].needAutoLogin) {
        [self initializeAlertControllerWithMessage:@"请先登录" withHandelBlock:^(id action) {
            [[[ControllerManager sharedManager] rootViewController] pushViewController:[[WPLoginViewController alloc]init] animated:YES];
        }];
        return;
    }
    [self.navigationController pushViewController:[[WPJoinViewController alloc]init] animated:YES];
}
#pragma mark - private menthods
- (CGFloat) culculateHeightWithText :(NSString *) text font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.height;
}

#pragma mark - getter
- (UIScrollView *)memberScrollView {
    if (!_memberScrollView) {
        _memberScrollView = ({
            UIScrollView * view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, ORIGIN_HEIGHT - 64) adjustWidth:NO];
            view.showsVerticalScrollIndicator = YES;
            view.contentSize = CGSizeMake(0, 800);
            view.pagingEnabled = NO;
            view;
        });
    }
    return _memberScrollView;
}
- (UIImageView *)modelImageView {
    if (!_modelImageView) {
        _modelImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 170*DHFlexibleVerticalMutiplier(), 40*DHFlexibleVerticalMutiplier())];
            view.image = IMAGE_CONTENT(@"line1@2x.png");
            view;
        });
    }
    return _modelImageView;
}
- (DottedLineLabel *)modelLabel {
    if (!_modelLabel) {
        _modelLabel = ({
            NSString * way = [UserDataStoreModel readUserDataWithDataKey:@"memberResult"][@"joinWay"];
            if (!way) {
                way = @"暂无加盟信息";
            }
            CGFloat height = [self culculateHeightWithText:way font:MEMBERFONT];
            DottedLineLabel * lab =[[DottedLineLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.modelImageView.frame) + 10, CGRectGetWidth(self.view.frame)-40, height)];
            lab.text = way;
            lab.numberOfLines = 0;
            lab.font = MEMBERFONT;
            lab;
        });
    }
    return _modelLabel;
}
- (UIImageView *)memberImageView {
    if (!_memberImageView) {
        _memberImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.modelLabel.frame) + 20, 170*DHFlexibleVerticalMutiplier(), 40*DHFlexibleVerticalMutiplier())];
            view.image = IMAGE_CONTENT(@"line2@2x.png");
            view;
        });
    }
    return _memberImageView;
}
- (DottedLineLabel *)memberLabel {
    if (!_memberLabel) {
        _memberLabel = ({
            NSString * members = [UserDataStoreModel readUserDataWithDataKey:@"memberResult"][@"companys"];
            if (!members) {
                members = @"暂无同行信息";
            }
            CGFloat height = [self culculateHeightWithText:members font:MEMBERFONT];
            DottedLineLabel * lab =[[DottedLineLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.memberImageView.frame) + 10, CGRectGetWidth(self.view.frame)-40, height)];
            lab.text = members;
            lab.textColor = COLOR_RGB(242, 81, 45, 1);
            lab.font = MEMBERFONT;
            lab.numberOfLines = 0;
            lab;
        });
    }
    return _memberLabel;
}
- (UIImageView *)contactImageView {
    if (!_contactImageView) {
        _contactImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.memberLabel.frame) +20, 170*DHFlexibleVerticalMutiplier(), 40*DHFlexibleVerticalMutiplier()) ];
            view.image = IMAGE_CONTENT(@"line3@2x.png");
            view;

        });
    }
    return _contactImageView;
}
- (DottedLineLabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = ({
            NSString * way = [UserDataStoreModel readUserDataWithDataKey:@"memberResult"][@"contactWay"];
            if (!way) {
                way = @"暂无联系方式信息";
            }
            CGFloat height = [self culculateHeightWithText:way font:MEMBERFONT];
            DottedLineLabel * lab =[[DottedLineLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contactImageView.frame) + 10, CGRectGetWidth(self.view.frame)-40, height)];
            lab.text = way;
            lab.font = MEMBERFONT;
            lab.numberOfLines = 0;
            lab;
        });
    }
    return _contactLabel;
}
- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.contactLabel.frame)/DHFlexibleVerticalMutiplier() + 20, 300, 45) adjustWidth:NO];
            [btn setTitle:@"我要加盟" forState:UIControlStateNormal];
            btn.backgroundColor = COLOR_RGB(240, 81, 51, 1);
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToJoinBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;

        });
    }
    return _joinBtn;
}
- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}
@end
