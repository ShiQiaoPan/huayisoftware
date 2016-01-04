//
//  WPChangedPwdViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/11.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPChangedPwdViewController.h"
#import "NetWorkingManager+ChangeLoginPwd.h"
#import "WPLoginViewController.h"

@interface WPChangedPwdViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * bfPwdTextField;
@property (nonatomic, strong) UIImageView * putInBackView;/**< 新密码输入背景 */
@property (nonatomic, strong) UITextField * pwdTextField;
@property (nonatomic, strong) UITextField * rePwdTextField;
@property (nonatomic, strong) UIButton * determineBtn;/**< 确定按钮 */
@property (nonatomic, strong) UITextField * showPwdTextField;/**< 显示密码 */
- (void)initializeUserInterface; /**< 初始化用户界面 */


@end

@implementation WPChangedPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.titleLable.text = @"修改密码";
    self.rightButton.hidden = YES;
    self.view.backgroundColor = COLOR_RGB(243, 244, 245, 1);
    
    [self.view addSubview:self.bfPwdTextField];
    [self.view addSubview:self.putInBackView];
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.rePwdTextField];
    [self.view addSubview:self.determineBtn];
    [self.view addSubview:self.showPwdTextField];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToDetermineBtn {
    if (self.bfPwdTextField.text.length == 0) {
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
    if (![self.rePwdTextField.text isEqualToString:self.pwdTextField.text]) {
        [self initializeAlertControllerWithMessage:@"2次输入密码不一致"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"密码修改中";
    __weak typeof(self)weakself = self;
    [NetWorkingManager changeLoginPwdWithPassword:self.bfPwdTextField.text newpassword:self.pwdTextField.text affirm:self.rePwdTextField.text successHandler:^(id responseObject) {
        if ([responseObject[@"success"] integerValue]) {
            hud.labelText = @"登录密码修改成功";
            hud.detailsLabelText = @"即将跳转登录界面";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [weakself.navigationController pushViewController:[[WPLoginViewController alloc]init] animated:YES];
            });
        } else {
            hud.labelText = responseObject[@"errMsg"]? responseObject[@"errMsg"]:@"登录密码修改失败";
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:2.0];
        }
    } failureHandler:^(NSError *error) {
        hud.labelText = @"密码修改失败";
        [hud hide:YES afterDelay:2.0];
    }];
}
- (void)respondsToShowPwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.bfPwdTextField.secureTextEntry = NO;
        self.pwdTextField.secureTextEntry = NO;
        self.rePwdTextField.secureTextEntry = NO;
    } else {
        self.bfPwdTextField.secureTextEntry = YES;
        self.pwdTextField.secureTextEntry = YES;
        self.rePwdTextField.secureTextEntry = YES;
    }
}
#pragma mark - system protocol
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.showPwdTextField) {
        return NO;
    }
    return YES;
}
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
    if (textField == self.bfPwdTextField) {
        [self.pwdTextField becomeFirstResponder];
    }
    if (textField == self.pwdTextField) {
        [self.rePwdTextField becomeFirstResponder];
    }
    if (textField == self.rePwdTextField) {
        [self respondsToDetermineBtn];
    }
    return YES;
}
#pragma mark - getter
- (UITextField *)bfPwdTextField {
    if (!_bfPwdTextField) {
        _bfPwdTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 290, 40) adjustWidth:NO];
            text.placeholder = @"请输入旧密码";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.keyboardType = UIKeyboardTypeDefault;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            text.secureTextEntry = YES;
            text;
        });
    }
    return _bfPwdTextField;
}
- (UIImageView *)putInBackView {
    if (!_putInBackView) {
        _putInBackView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 150, 290, 80) adjustWidth:NO];
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
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(15, 150, 290, 40) adjustWidth:NO];
            text.placeholder = @"请输入新密码";
            text.keyboardType = UIKeyboardTypeDefault;
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
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(15, 190, 290, 40) adjustWidth:NO];
            text.placeholder = @"请再次输入新密码";
            text.keyboardType = UIKeyboardTypeDefault;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyDone;
            text.secureTextEntry = YES;
            text.delegate = self;
            text;
        });
    }
    return _rePwdTextField;
}
- (UIButton *)determineBtn {
    if (!_determineBtn) {
        _determineBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 45) adjustWidth:NO];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToDetermineBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _determineBtn;
}
- (UITextField *)showPwdTextField {
    if (!_showPwdTextField) {
        _showPwdTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(15, 355, 290, 40) adjustWidth:NO];
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
