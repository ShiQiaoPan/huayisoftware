//
//  WPCashViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPCashViewController.h"
#import "WKAlertView.h"
#import "WPBankPickView.h"
#import "WPFindCashViewController.h"
#import "WPBoundBankCardViewModel.h"
#import "WPAddBankCardViewController.h"
#import "NetWorkingManager+DrawCash.h"

@interface WPCashViewController ()<UITextFieldDelegate>{
    NSArray * _bankNames;
}
@property (nonatomic, strong) UIWindow * topWindow;
@property (nonatomic, strong) UITextField * bankNameText;
@property (nonatomic, strong) UILabel * bankNameLabel;
@property (nonatomic, strong) UITextField * cashCountText;
@property (nonatomic, strong) UITextField * cashPwdText;
@property (nonatomic, strong) UIButton * cashBtn;
@property (nonatomic, strong) UIButton * forgetPwdBtn;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) NSMutableDictionary * cardInfo;

- (void)initializeUserInterface; /**< 初始化用户界面 */
@end

@implementation WPCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"提现";
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.bankNameText];
    [self.view addSubview:self.cashCountText];
    [self.view addSubview:self.cashPwdText];
    [self.view addSubview:self.cashBtn];
    [self.view addSubview:self.forgetPwdBtn];
}
#pragma mark - repsonds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToCashBtn {
    if ([self.bankNameLabel.text isEqualToString:@"请选择银行卡号"]) {
        [self initializeAlertControllerWithMessage:@"请选择银行卡"];
        return;
    }
    if (self.cashCountText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入提现金额"];
        return;
    }
    if (self.cashPwdText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入提现密码"];
        return;
    }
    self.hud.labelText = @"请稍候";
    self.hud.detailsLabelText = @"申请提交中";
    __weak typeof(self)weakself = self;
    [self.cardInfo removeObjectForKey:@"bankcard"];
    [NetWorkingManager submitDrawCashWithCardInfo:self.cardInfo money:self.cashCountText.text password:self.cashPwdText.text successHandler:^(id responseObject) {
        [weakself.hud hide:YES];
        if ([responseObject[@"code"] integerValue] == 0) {
            weakself.topWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleSuccess title:@"申请提交成功" detail:nil canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
                weakself.topWindow.hidden = YES;
                weakself.topWindow = nil;
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            weakself.topWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"申请提交失败" detail:responseObject[@"errMsg"] canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
                weakself.topWindow.hidden = YES;
                weakself.topWindow = nil;
            }];
        }
        
    } failureHandler:^(NSError *error) {
        [weakself.hud hide:YES];
        weakself.topWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"申请提交失败" detail:nil canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
            weakself.topWindow.hidden = YES;
            weakself.topWindow = nil;
        }];
    }];
    
}
- (void)respondsToForgetPwdBtn {
    [self.navigationController pushViewController:[[WPFindCashViewController alloc]init] animated:YES];
}
- (void)respondsToBankName {
    [self.view endEditing:YES];
    NSArray * banks = [UserDataStoreModel readUserDataWithDataKey:@"cardDataSource"];
    __weak typeof(self)weakself = self;
    if (banks.count) {
        [WPBankPickView showViewWithDataSources:banks complete:^(NSMutableDictionary *date) {
            if (date.count == 0) {
                [weakself.navigationController pushViewController:[WPAddBankCardViewController new] animated:YES];
            } else {
                weakself.bankNameLabel.text = date[@"bankAndCard"];
                weakself.cardInfo = date;
            }
        }];
        return;
    }
    MBProgressHUD * bankhud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    bankhud.color = [UIColor grayColor];
    bankhud.labelText = @"请稍候";
    bankhud.detailsLabelText = @"获取银行卡列表中";
    [WPBoundBankCardViewModel getBankCardsWithSuccessBlock:^(NSArray *bankCards) {
        bankhud.labelText = @"获取银行卡列表成功";
        bankhud.detailsLabelText = nil;
        [bankhud hide:YES afterDelay:1.0];
        [WPBankPickView showViewWithDataSources:bankCards complete:^(NSMutableDictionary *date) {
            if (date.count == 0) {
                [weakself.navigationController pushViewController:[WPAddBankCardViewController new] animated:YES];
            } else {
                weakself.bankNameLabel.text = date[@"bankAndCard"];
                weakself.cardInfo = date;
            }
        }];
    } failBlock:^(NSString *error) {
        bankhud.labelText = @"获取列表失败";
        bankhud.detailsLabelText = nil;
        [bankhud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.cashCountText&&textField.text.length > 10) {
        return NO;
    }
    if (textField == self.cashPwdText&&textField.text.length > 15) {
        return NO;
    }
    return YES;
}
#pragma mark - getter
- (UITextField *)bankNameText {
    if (!_bankNameText) {
        _bankNameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 80, 320, 40) adjustWidth:NO];
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 40) adjustWidth:NO];
            UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(70, 0, 250, 40) adjustWidth:NO];
            UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 40) adjustWidth:NO];
            leftLabel.text = @"银行卡";
            leftLabel.adjustsFontSizeToFitWidth = YES;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(210, 5, 30, 30), YES);
            [btn setImage:IMAGE_CONTENT(@"triangle.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToBankName) forControlEvents:UIControlEventTouchUpInside];
            [leftView addSubview:leftLabel];
            [rightView addSubview:self.bankNameLabel];
            [rightView addSubview:btn];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.rightViewMode = UITextFieldViewModeAlways;
            text.leftView = leftView;
            text.rightView = rightView;
            text.backgroundColor = [UIColor whiteColor];
            text;
            
        });
    }
    return _bankNameText;
}
- (UILabel *)bankNameLabel {
    if (!_bankNameLabel) {
        _bankNameLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 210, 40) adjustWidth:NO];
            label.text = @"请选择银行卡号";
            label.textColor = COLOR_RGB(108, 143, 246, 1);
            label.textAlignment = NSTextAlignmentRight;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToBankName)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label;
        });
    }
    return _bankNameLabel;
}
- (UITextField *)cashCountText {
    if (!_cashCountText) {
        _cashCountText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bankNameText.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 40) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40) adjustWidth:NO];
            lab.text = @"提现金额（元）";
            lab.adjustsFontSizeToFitWidth = YES;
            [view addSubview:lab];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.placeholder = [NSString stringWithFormat:@"可提现金额%@元", self.moneyBalance];
            text.textAlignment = NSTextAlignmentCenter;
            text.backgroundColor = [UIColor whiteColor];
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _cashCountText;
}
- (UITextField *)cashPwdText {
    if (!_cashPwdText) {
        _cashPwdText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cashCountText.frame)/DHFlexibleVerticalMutiplier()+20, 320, 40) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 40) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40) adjustWidth:NO];
            lab.text = @"提现密码";
            [view addSubview:lab];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.placeholder = @"请输入您的提现密码";
            text.backgroundColor = [UIColor whiteColor];
            text.secureTextEntry = YES;
            text.delegate = self;
            text;
        });
    }
    return _cashPwdText;
}
- (UIButton *)cashBtn {
    if (!_cashBtn) {
        _cashBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(10, CGRectGetMaxY(self.cashPwdText.frame)/DHFlexibleVerticalMutiplier() + 20, 300, 40), NO) ;
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn setTitle:@"提现" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToCashBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _cashBtn;
}
- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(10, CGRectGetMaxY(self.cashBtn.frame)/DHFlexibleVerticalMutiplier()+10, 300, 40), NO) ;
            btn.layer.cornerRadius = 10;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToForgetPwdBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;

        });
    }
    return _forgetPwdBtn;
}
- (MBProgressHUD *)hud {
    if (!_hud) {
         _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.color = [UIColor grayColor];
    }
    return _hud;
}

@end
