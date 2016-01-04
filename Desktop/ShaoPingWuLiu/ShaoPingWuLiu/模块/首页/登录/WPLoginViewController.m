//
//  LoginViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/5.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPRegisterViewController.h"
#import "WPFindPwdViewController.h"
#import "NetWorkingManager+Login.h"
#import "UserModelArchiver.h"

@interface WPLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * putInBackView;/**< 输入背景 */
@property (nonatomic, strong) UITextField * phoneTextField;/**< 电话号码输入框 */
@property (nonatomic, strong) UITextField * passwordTextField;/**< 密码输入框 */
@property (nonatomic, strong) UIButton    * loginButton;/**< 登陆按钮 */
@property (nonatomic, strong) UIButton    * forgetPwdBtn;/**< 忘记密码按钮 */


- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPLoginViewController

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
    self.titleLable.text = @"登录";
    self.titleLable.textColor = [UIColor whiteColor];
    [self.rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:self.putInBackView];
    [self.putInBackView addSubview:self.phoneTextField];
    [self.putInBackView addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.forgetPwdBtn];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    self.phoneTextField.text = @"";
    self.passwordTextField.text = @"";
    [self.navigationController pushViewController:[[WPRegisterViewController alloc]init] animated:YES];
}
- (void)respondsToLoginBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入11位手机号码"];
        return;
    }
    if (![ConfirmMobileNumber isMobileNumber:self.phoneTextField.text]) {
        [self initializeAlertControllerWithMessage:@"请输入正确格式的11位的手机号码"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入您的密码"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在登陆";
    __weak typeof(self)weakself = self;
    [NetWorkingManager loginWithName:self.phoneTextField.text password:self.passwordTextField.text successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            hud.labelText = responseObject[@"errMsg"] ? responseObject[@"errMsg"]:@"登录失败";
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
        }
        else {
            hud.labelText = responseObject[@"errMsg"] ? responseObject[@"errMsg"]:@"登录成功";
            hud.detailsLabelText = nil;
            [UserModel defaultUser].userID = responseObject[@"datas"][@"id"];
            [UserModel defaultUser].phoneNumber = self.phoneTextField.text;
            [UserModel defaultUser].password = self.passwordTextField.text;
            [UserModelArchiver archiver];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AutoLogin"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [[ControllerManager sharedManager].mainTabController resetController];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            });
        }        
    } failureHandler:^(NSError *error) {
        hud.labelText = @"登录失败";
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:2.0];
    }];
}
- (void)respondsToForgetPwdBtn {
    [self.navigationController pushViewController:[[WPFindPwdViewController alloc]init] animated:YES];
}
#pragma mark - UITextViewDelegate
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
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self respondsToLoginBtn:nil];
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
            text.delegate = self;
            text.returnKeyType = UIReturnKeyDone;
            text.secureTextEntry = YES;
            text;
        });
    }
    _passwordTextField.delegate = self;
    return _passwordTextField;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 300, 45) adjustWidth:NO];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _loginButton;
}
- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 250, 300, 45) adjustWidth:YES];
            [btn setTitle:@"忘记密码？" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
            [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToForgetPwdBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _forgetPwdBtn;
}
@end
