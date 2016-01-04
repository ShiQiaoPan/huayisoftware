//
//  WPChangeCashPwdViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/16.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPChangeCashPwdViewController.h"
#import "NetWorkingManager+CashPwd.h"

@interface WPChangeCashPwdViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * bfPwdText;
@property (nonatomic, strong) UIImageView * putInBackView;/**< 输入背景 */
@property (nonatomic, strong) UITextField * pwdTextField;/**< 电话号码输入框 */
@property (nonatomic, strong) UITextField * rePwdTextField;/**< 密码输入框 */
@property (nonatomic, strong) UIButton * changeBtn;/**< 注册按钮 */
@property (nonatomic, strong) UITextField * showPwdTextField;/**< 显示密码 */



- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPChangeCashPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"提现密码修改";
    [self.view addSubview:self.bfPwdText];
    [self.view addSubview:self.putInBackView];
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.rePwdTextField];
    [self.view addSubview: self.changeBtn];
    [self.view addSubview:self.showPwdTextField];
}
#pragma mark - responds ecents
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    [self.view endEditing:YES];
}
- (void)respondsToChangeBtn {
    if (self.bfPwdText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入旧密码"];
        return;
    }
    if (self.pwdTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入新密码"];
        return;
    }
    if (self.rePwdTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请再次输入新密码"];
        return;
    }
    if (![self.pwdTextField.text isEqualToString:self.rePwdTextField.text]) {
        [self initializeAlertControllerWithMessage:@"2次输入密码不一致"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在修改密码";
    __weak typeof(self)weakself = self;
    [NetWorkingManager updateCashPwdWithPassword:self.bfPwdText.text newpassword:self.pwdTextField.text affirm:self.rePwdTextField.text SuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]== 0) {
            if (responseObject[@"errMsg"]) {
                hud.labelText = responseObject[@"errMsg"];
                [weakself.navigationController popViewControllerAnimated:YES];
            } else {
                hud.labelText = @"网络数据错误";
            }
        } else {
            if (responseObject[@"errMsg"]) {
                hud.labelText = responseObject[@"errMsg"];
            } else {
                hud.labelText = @"网络数据错误";
            }        }
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
    } failureHandler:^(NSError *error) {
        hud.labelText = @"网络错误";
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:2.0];
    }];
    
}
- (void)respondsToShowPwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.bfPwdText.secureTextEntry = NO;
        self.pwdTextField.secureTextEntry = NO;
        self.rePwdTextField.secureTextEntry = NO;
    } else {
        self.bfPwdText.secureTextEntry = YES;
        self.pwdTextField.secureTextEntry = YES;
        self.rePwdTextField.secureTextEntry = YES;
    }
}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 16) {
        return NO;
    }
    if (textField == self.showPwdTextField) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.pwdTextField) {
        [self.rePwdTextField becomeFirstResponder];
    }
    if (textField == self.rePwdTextField) {
        [self respondsToChangeBtn];
    }
    return YES;
}

#pragma mark - getter
- (UITextField *)bfPwdText {
    if (!_bfPwdText) {
        _bfPwdText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 84, 300, 40) adjustWidth:NO];
            text.placeholder = @"请输入您以前的密码";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.secureTextEntry = YES;
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            text;
        });
    }
    return _bfPwdText;
}
- (UIImageView *)putInBackView {
    if (!_putInBackView) {
        _putInBackView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bfPwdText.frame)/DHFlexibleVerticalMutiplier() + 10, 300, 80) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"bg2.png");
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _putInBackView;
}
- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bfPwdText.frame)/DHFlexibleVerticalMutiplier()+10, 290, 40) adjustWidth:NO];
            text.placeholder = @"请填写您需要设置的密码";
            text.borderStyle = UITextBorderStyleNone;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyNext;
            text.secureTextEntry = YES;
            text.delegate = self;
            text;
        });
    }
    return _pwdTextField;
}
- (UITextField *)rePwdTextField {
    if (!_rePwdTextField) {
        _rePwdTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.pwdTextField.frame)/DHFlexibleVerticalMutiplier(), 290, 40) adjustWidth:NO];
            text.placeholder = @"请重复输入您的提现密码";
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyDone;
            text.delegate = self;
            text.secureTextEntry = YES;
            text;
        });
    }
    return _rePwdTextField;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.rePwdTextField.frame)/DHFlexibleVerticalMutiplier()+20, 300, 40) adjustWidth:YES];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToChangeBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _changeBtn;
}
- (UITextField *)showPwdTextField {
    if (!_showPwdTextField) {
        _showPwdTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.changeBtn.frame)/DHFlexibleVerticalMutiplier()+10, 290, 40) adjustWidth:NO];
            text.placeholder = @"显示密码";
            text.leftViewMode = UITextFieldViewModeAlways;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(10, 5, 20, 20), YES);
            [btn setImage:IMAGE_CONTENT(@"checked_1.png") forState:UIControlStateNormal];
            [btn setImage:IMAGE_CONTENT(@"checked.png") forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(respondsToShowPwdBtn:) forControlEvents:UIControlEventTouchUpInside];
            text.leftView = btn;
            text.delegate = self;
            text;
            
        });
    }
    return _showPwdTextField;
}
@end
