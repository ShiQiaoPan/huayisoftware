//
//  RegisterViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/6.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPRegisterViewController.h"
#import "NetWorkingManager+GetCode.h"
#import "NetWorkingManager+Register.h"
#import "ConfirmMobileNumber.h"

@interface WPRegisterViewController ()<UITextFieldDelegate>{
    int _timeCount;/**< 倒计时 */
    MBProgressHUD * _hud;
}
@property (nonatomic, strong) UIImageView * putInBackView;/**< 输入背景 */
@property (nonatomic, strong) UITextField * phoneTextField;/**< 电话号码输入框 */
@property (nonatomic, strong) UITextField * passwordTextField;/**< 密码输入框 */
@property (nonatomic, strong) UIImageView * testNumBg;/**< 验证码背景 */
@property (nonatomic, strong) UITextField * testNumTextField;/**< 验证码输入框 */
@property (nonatomic, strong) UIButton * getTestNum;/**< 倒计时 */
@property (nonatomic, strong) UITextField * inviteNumTextField;/**< 邀请码输入 */
@property (nonatomic, strong) UIButton * registerBtn;/**< 注册按钮 */
@property (nonatomic, strong) NSTimer * timer;/**< 倒计时 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPRegisterViewController

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
    self.titleLable.text = @"注册账号";
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.putInBackView];
    [self.putInBackView addSubview:self.phoneTextField];
    [self.putInBackView addSubview:self.passwordTextField];
    [self.view addSubview:self.testNumBg];
    [self.testNumBg addSubview:self.testNumTextField];
    [self.testNumBg addSubview:self.getTestNum];
    [self.view addSubview:self.inviteNumTextField];
    [self.view addSubview:self.registerBtn];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToGetTestNumBtn:(UIButton *)sender {
    if (self.phoneTextField.text.length == 0 || ![ConfirmMobileNumber isMobileNumber:self.phoneTextField.text]) {
        [self initializeAlertControllerWithMessage:@"请输入正确格式的手机号码"];

    } else {
        [sender setTitle:@"60s再次获取" forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor clearColor];
        [self.timer setFireDate:[NSDate distantPast]];
        _timeCount = 60;
        __weak typeof(self)weakself = self;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor grayColor];
        hud.labelText = @"请稍等";
        hud.detailsLabelText = @"正在发送验证码...";
        [NetWorkingManager getCodeWithPhone:self.phoneTextField.text successHandler:^(id responseObject) {
            [weakself.timer setFireDate:[NSDate distantFuture]];
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            sender.backgroundColor = REDBGCOLOR;
            if ([responseObject[@"success"] integerValue]== 0) {
                if (responseObject[@"errMsg"]) {
                    hud.labelText = responseObject[@"errMsg"];
                } else {
                    hud.labelText = @"发送失败";
                }
            } else {
                if (responseObject[@"errMsg"]) {
                    hud.labelText = responseObject[@"errMsg"];
                } else {
                    hud.labelText = @"发送成功";
                }        }
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
        } failureHandler:^(NSError *error) {
            hud.labelText = @"发送失败";
            hud.detailsLabelText = error.localizedDescription;
            [weakself.timer setFireDate:[NSDate distantFuture]];
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            sender.backgroundColor = REDBGCOLOR;
        }];
    }
    
}
- (void)respondsToRegisterBtn {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length == 0||![ConfirmMobileNumber isMobileNumber:self.phoneTextField.text]) {
        [self initializeAlertControllerWithMessage:@"请输入正确格式的手机号码"];
    }
    else if (self.passwordTextField.text == 0) {
        [self initializeAlertControllerWithMessage:@"请输入密码"];
    }
    else if (self.testNumTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入验证码"];
    }
    else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.color = [UIColor grayColor];
        _hud.removeFromSuperViewOnHide = YES;
        _hud.labelText = @"请稍候";
        _hud.detailsLabelText = @"注册中...";
        __weak typeof(self)weakself = self;
        [NetWorkingManager registerWithName:self.phoneTextField.text password:self.passwordTextField.text code:self.testNumTextField.text orangeKey:self.inviteNumTextField.text successHandler:^(id responseObject) {
            [_hud hide:YES];
            if ([responseObject[@"code"] integerValue]==0) {
                [_hud hide:YES];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        [weakself.navigationController popViewControllerAnimated:YES];

                    }];
                });
            } else {
                if (responseObject[@"errMsg"]) {
                    _hud.labelText = responseObject[@"errMsg"];
                } else {
                    _hud.labelText = @"注册失败";
                }
                _hud.detailsLabelText = nil;
                [_hud hide:YES afterDelay:1.0];
            }
        } failureHandler:^(NSError *error) {
            _hud.labelText = @"注册失败";
            _hud.detailsLabelText = error.localizedDescription;
            [_hud hide:YES afterDelay:2.0];
        }];
    }
}
- (void)respondsToTimeCount {
    _timeCount--;
    NSString * timeStr = [NSString stringWithFormat:@"%ds再次获取", _timeCount];
    [self.getTestNum setTitle:timeStr forState:UIControlStateNormal];
    if (_timeCount == 0) {
        [_hud hide:YES];
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.getTestNum setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getTestNum.enabled = YES;
        self.getTestNum.backgroundColor = COLOR_RGB(240, 81, 51, 1);;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    else if (textField == self.passwordTextField) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    else if (textField == self.testNumTextField) {
        if (textField.text.length > 5) {
            return NO;
        }
    }
    else if (textField == self.inviteNumTextField) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.passwordTextField) {
        [self.testNumTextField becomeFirstResponder];
    }
    else if (textField == self.inviteNumTextField) {
        [self respondsToRegisterBtn];
    }
    return YES;
}
#pragma mark - getter
- (UIImageView *)putInBackView {
    if (!_putInBackView) {
        _putInBackView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 84, 300, 90) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"bg2.png");
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _putInBackView;
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 290, 45) adjustWidth:NO];
            text.placeholder = @"请输入11位手机号码";
            text.borderStyle = UITextBorderStyleNone;
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _phoneTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 45, 290, 45) adjustWidth:NO];
            text.placeholder = @"请输入您的密码";
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            text.secureTextEntry = YES;
            text;
        });
    }
    return _passwordTextField;
}
- (UIImageView *)testNumBg {
    if (!_testNumBg) {
        _testNumBg = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 190, 300, 45) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"get.png");
            view.userInteractionEnabled = YES;
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = YES;
            view;
        });
    }
    return _testNumBg;
}
- (UITextField *)testNumTextField {
    if (!_testNumTextField) {
        _testNumTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 190, 45) adjustWidth:NO];
            text.placeholder = @"请输入验证码";
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _testNumTextField;
}
- (UIButton *)getTestNum {
    if (!_getTestNum) {
        _getTestNum = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(200, 0, 100, 45), NO);
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(respondsToGetTestNumBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            btn.backgroundColor = COLOR_RGB(240, 81, 51, 1);
            btn;
        });
    }
    return _getTestNum;
}
- (UITextField *)inviteNumTextField {
    if (!_inviteNumTextField) {
        _inviteNumTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 245, 300, 45) adjustWidth:NO];
            text.placeholder = @"请输入您的邀请码，没有请为空";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyDone;
            text.delegate = self;
            text;
        });
    }
    return _inviteNumTextField;
}
- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 45) adjustWidth:YES];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _registerBtn;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(respondsToTimeCount) userInfo:nil repeats:YES];
    }
    return _timer;
}
@end
