//
//  WPMyWalletViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMyWalletViewController.h"
#import "CustomTableViewCell.h"
#import "WPDetailWalletViewController.h"
#import "WPMoreWallletViewController.h"
#import "WPMoreDiscountViewController.h"
#import "WPFirstCashPwdViewController.h"
#import "WPChangeCashPwdViewController.h"
#import "WPMyWalletViewModel.h"
#import "WPCashViewController.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
@interface WPMyWalletViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * walletTableView;
@property (nonatomic, strong) NSArray * walletDataSource;
@property (nonatomic, strong) NSArray * nextViewControllersArr;/**< 下一个界面数组 */
@property (nonatomic, strong) UIView * walletView;
@property (nonatomic, strong) UIImageView * myWalletImageView;
@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UILabel * balanceIntroLabel;
@property (nonatomic, strong) UIView * discountView;
@property (nonatomic, strong) UIImageView * discountImageView;
@property (nonatomic, strong) UILabel * discountLabel;
@property (nonatomic, strong) UILabel * discountIntroLabel;
@property (nonatomic, copy) NSString * haveBound;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self)weakself = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"获取钱包信息中";
    [WPMyWalletViewModel getMyWalletWithSuccessBlock:^(NSDictionary *myWallet) {
        hud.labelText = @"获取钱包信息成功";
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
        weakself.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", [myWallet[@"money"] floatValue]];
        weakself.discountLabel.text = [NSString stringWithFormat:@"%ld张", [myWallet[@"number"] integerValue]];
        [UserDataStoreModel saveUserDataWithDataKey:@"myWallet" andWithData:myWallet andWithReturnFlag:nil];
        [weakself.walletTableView reloadData];
    } failBlock:^(NSString *error) {
        hud.labelText = @"获取钱包信息失败";
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - init
- (void)initializeDataSource {
    self.walletDataSource = @[@[@[@"绑定银行卡", @"card.png"]],
                             @[@[@"充值", @"charg.png"],
                               @[@"提现", @"money.png"]],
                              @[@[@"提现密码修改", @"change_cash.png"]]];
    self.nextViewControllersArr = @[@[@"WPBoundBankCardViewController"],
                                    @[@"WPTopupViewController",
                                      @"WPCashViewController"],
                                    @[@"WPFirstCashPwdViewController"]];
    NSDictionary * mywallet = [UserDataStoreModel readUserDataWithDataKey:@"myWallet"];
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", [mywallet[@"money"] floatValue]];
    self.discountLabel.text = [NSString stringWithFormat:@"%ld张", [mywallet[@"number"] integerValue]];
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    self.titleLable.text = @"我的钱包";
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.rightButton setTitle:@"明细" forState:UIControlStateNormal];
    [self.view addSubview:self.walletView];
    [self.view addSubview:self.myWalletImageView];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.balanceIntroLabel];
    [self.view addSubview:self.discountView];
    [self.view addSubview:self.discountImageView];
    [self.view addSubview:self.discountLabel];
    [self.view addSubview:self.discountIntroLabel];
    [self addLine];
    [self.view addSubview:self.walletTableView];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    UIViewController * VC = [[WPDetailWalletViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)respondsToMyWallet {
    WPMoreWallletViewController * moreWalletVC = [[WPMoreWallletViewController alloc]init];
    moreWalletVC.balance = [[self.balanceLabel.text substringFromIndex:1] floatValue];
    [self.navigationController pushViewController:moreWalletVC animated:YES];

}
- (void)respondsToMyDiscount {
    WPMoreDiscountViewController * VC = [[WPMoreDiscountViewController alloc]init];
    VC.discountCount = [[self.discountLabel.text substringToIndex:self.discountLabel.text.length - 1 ] integerValue];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.walletDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.walletDataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = IMAGE_CONTENT(self.walletDataSource[indexPath.section][indexPath.row][1]);
    cell.titleLabel.text = self.walletDataSource[indexPath.section][indexPath.row][0];
    if (indexPath.section == 0) {
        cell.rightLabel.text = [[UserDataStoreModel readUserDataWithDataKey:@"myWallet"][@"bankcard"] integerValue]? @"":@"您还没绑定银行卡";
        cell.rightLabel.font = [UIFont systemFontOfSize:12];
        cell.rightLabel.textColor = COLOR_RGB(171, 172, 173, 1);
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.rightLabel.text = @"(微信支付、支付宝支付)";
        cell.rightLabel.font = [UIFont systemFontOfSize:12];
        cell.rightLabel.textColor = COLOR_RGB(171, 172, 173, 1);
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * DHFlexibleVerticalMutiplier();
}
//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        if (![UserDataStoreModel readUserDataWithDataKey:@"myWallet"][@"cashpwd"]) {
            WPFirstCashPwdViewController * firstVC = [[WPFirstCashPwdViewController alloc]init];
            [self.navigationController pushViewController:firstVC animated:YES];
        } else {
            WPChangeCashPwdViewController * changeVC = [[WPChangeCashPwdViewController alloc]init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }
        return;
    }
    if (indexPath.section == 1&& indexPath.row == 1) {
        if ([UserDataStoreModel readUserDataWithDataKey:@"myWallet"][@"cashpwd"]) {
            WPCashViewController * cashVC = [[WPCashViewController alloc]init];
            cashVC.moneyBalance = [self.balanceLabel.text substringFromIndex:1];
            [self.navigationController pushViewController:cashVC animated:YES];
        } else {
            WPFirstCashPwdViewController * firstVC = [[WPFirstCashPwdViewController alloc]init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }
        return;
    }
    Class  class = NSClassFromString(self.nextViewControllersArr[indexPath.section][indexPath.row]);
    UIViewController * VC = [[class alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - private methods
- (void)addLine {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMinY(self.walletView.frame)))];
    [path addLineToPoint:(CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.walletView.frame)))];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.walletView.frame))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.view.frame), CGRectGetMaxY(self.walletView.frame))];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.view.frame;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = GARYTextColor.CGColor;
    layer.path = path.CGPath;
    layer.lineWidth = 1.2;
    [self.view.layer addSublayer:layer];
    
}

#pragma mark - gettet
- (UIView *)walletView {
    if (!_walletView) {
        _walletView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 160, 120) adjustWidth:NO];
            view.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToMyWallet)];
            [view addGestureRecognizer:ges];
            view;
        });
    }
    return _walletView;
}
- (UIImageView *)myWalletImageView {
    if (!_myWalletImageView) {
        _myWalletImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(60, 84, 40, 40) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"money.png");
            view;
        });
    }
    return _myWalletImageView;
}
- (UIImageView *)discountImageView {
    if (!_discountImageView) {
        _discountImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(220, 84, 40, 40) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"ticket.png");
            view;

        });
    }
    return _discountImageView;
}
- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 124, 160, 30) adjustWidth:YES];
            label.textColor = COLOR_RGB(241, 109, 88, 1);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"￥0.00";
            label;
        });
    }
    return _balanceLabel;
}
- (UIView *)discountView {
    if (!_discountView) {
        _discountView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(160, 64, 160, 120) adjustWidth:NO];
            view.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToMyDiscount)];
            [view addGestureRecognizer:ges];
            view;

        });
    }
    return _discountView;
}
- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(160, 124, 160, 30) adjustWidth:YES];
            label.textColor = COLOR_RGB(241, 109, 88, 1);
            label.textAlignment = NSTextAlignmentCenter;
            label.text= @"0张";
            label;
        });
    }
    return _discountLabel;
}
- (UILabel *)balanceIntroLabel {
    if (!_balanceIntroLabel) {
        _balanceIntroLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 154, 160, 30) adjustWidth:YES];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"我的余额";
            label;
        });
    }
    return _balanceIntroLabel;
}
- (UILabel *)discountIntroLabel {
    if (!_discountIntroLabel) {
        _discountIntroLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(160, 154, 160, 30) adjustWidth:YES];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"优惠劵";
            label;
        });
    }
    return _discountIntroLabel;
}
- (UITableView *)walletTableView {
    if (!_walletTableView) {
        _walletTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 184, ORIGIN_WIDTH, ORIGIN_HEIGHT - 128), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = COLOR_RGB(210, 211, 212, 1);
            tableview.scrollEnabled = NO;
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _walletTableView;
}
@end
