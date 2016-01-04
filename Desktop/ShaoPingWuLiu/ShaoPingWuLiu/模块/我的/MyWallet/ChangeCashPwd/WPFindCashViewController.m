//
//  WPFindCashViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/19.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPFindCashViewController.h"
#import "NetWorkingManager+GetCode.h"
#import "NetWorkingManager+CashPwd.h"

@interface WPFindCashViewController ()<UITextFieldDelegate>{
    NSInteger _timeCount;
}
@property (nonatomic, strong) UITextField * phoneTextField;/**< 电话号码输入框 */
@property (nonatomic, strong) UITextField * passwordTextField;/**< 密码输入框 */
@property (nonatomic, strong) UIImageView * testNumBg;/**< 验证码背景 */
@property (nonatomic, strong) UITextField * testNumTextField;/**< 验证码输入框 */
@property (nonatomic, strong) UIButton * getTestNumBtn;/**< 获取验证码 */
@property (nonatomic, strong) UIImageView * pwdBgImageView;/**< 输入密码背景 */
@property (nonatomic, strong) UITextField * pwdTextField;/**< 新密码 */
@property (nonatomic, strong) UITextField * rePwdTextField;/**< 再次输入新密码 */
@property (nonatomic, strong) UIButton * getPwdBtn;/**< 重置密码 */
@property (nonatomic, strong) NSTimer * timer;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPFindCashViewController

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
    self.titleLable.text = @"忘记提现密码";
    self.titleLable.textColor = [UIColor whiteColor];
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.testNumBg];
    [self.testNumBg addSubview:self.testNumTextField];
    [self.testNumBg addSubview:self.getTestNumBtn];
    self.testNumBg.layer.masksToBounds = YES;
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.rePwdTextField];
    [self.view addSubview:self.getPwdBtn];
    
}
#pragma mark - reponds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToGetTestNumBtn:(UIButton *)sender {
    if (self.phoneTextField.text == 0 || ![ConfirmMobileNumber isMobileNumber:self.phoneTextField.text]) {
        [self initializeAlertControllerWithMessage:@"请输入正确的电话号码"];
        return;
    }
    [sender setTitle:@"60s再次获取" forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor clearColor];
    [self.timer setFireDate:[NSDate distantPast]];
    _timeCount = 60;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍等";
    hud.detailsLabelText = @"正在发送验证码...";
    __weak typeof(self)weakself = self;
    [NetWorkingManager getCodeWithPhone:self.phoneTextField.text successHandler:^(id responseObject) {
        [weakself.timer setFireDate:[NSDate distantFuture]];
        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
        sender.backgroundColor = REDBGCOLOR;
        if ([responseObject[@"code"] integerValue]== 0) {
            if (responseObject[@"errMsg"]) {
                hud.labelText = responseObject[@"errMsg"]
                ;
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
        [weakself.timer setFireDate:[NSDate distantFuture]];
        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
        sender.backgroundColor = REDBGCOLOR;
    }];
}
- (void)respondsToTimeCount {
    _timeCount--;
    NSString * timeStr = [NSString stringWithFormat:@"%lds再次获取", (long)_timeCount];
    [self.getTestNumBtn setTitle:timeStr forState:UIControlStateNormal];
    if (_timeCount == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.getTestNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getTestNumBtn.enabled = YES;
        self.getTestNumBtn.backgroundColor = COLOR_RGB(240, 81, 51, 1);
    }
}
- (void)respondsToGetPwdBtn {
    if (self.phoneTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入手机号码"];
        return;
    }
    if (self.testNumTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入验证码"];
        return;
    }
    if (self.pwdTextField.text == 0) {
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
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍等";
    hud.detailsLabelText = @"正在重置密码...";
    __weak typeof(self)weakself = self;
    [NetWorkingManager findCashPwdWithName:self.phoneTextField.text withCode:self.testNumTextField.text newpassword:self.pwdTextField.text newpassword2:self.rePwdTextField.text SuccessHandler:^(id responseObject) {
            if ([responseObject[@"success"] integerValue]) {
                if (responseObject[@"errMsg"]) {
                    hud.labelText = @"密码修改成功";
                    hud.detailsLabelText = @"即将跳转上一界面";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        [weakself.navigationController popViewControllerAnimated:YES];
                    });
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
#pragma mark - UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    else if (textField == self.testNumTextField) {
        if (textField.text.length > 5) {
            return NO;
        }
    }
    else if (textField == self.passwordTextField) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    else if (textField == self.rePwdTextField) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.pwdTextField) {
        [self.rePwdTextField becomeFirstResponder];
    }
    else if (textField == self.rePwdTextField) {
        [self respondsToGetPwdBtn];
    }
    return YES;
}
#pragma mark - getter
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 84, 300, 45) adjustWidth:NO];
            text.placeholder = @"请输入您的手机号码";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            text;
        });
    }
    return _phoneTextField;
}
- (UIImageView *)testNumBg {
    if (!_testNumBg) {
        _testNumBg = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 140, 300, 45) adjustWidth:NO];
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
- (UIButton *)getTestNumBtn {
    if (!_getTestNumBtn) {
        _getTestNumBtn = ({
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
    return _getTestNumBtn;
}
- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 195, 300, 45) adjustWidth:NO];
            text.placeholder = @"请输入您的新密码";
            text.borderStyle = UITextBorderStyleRoundedRect;
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
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 240, 300, 45) adjustWidth:NO];
            text.placeholder = @"请再次输入新密码";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyDone;
            text.secureTextEntry = YES;
            text.delegate = self;
            text;
            
        });
    }
    return _rePwdTextField;
}
-(UIButton *)getPwdBtn {
    if (!_getPwdBtn) {
        _getPwdBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(10, 295, 300, 45), NO);
            [btn setTitle:@"重置密码" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToGetPwdBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _getPwdBtn;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(respondsToTimeCount) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
