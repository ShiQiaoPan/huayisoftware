//
//  WPAddBankCardViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddBankCardViewController.h"
#import "NetWorkingManager+BoundBankCard.h"
#import "ConfirmBankCardNumber.h"

@interface WPAddBankCardViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * introLabel;
@property (nonatomic, strong) UITextField * nameTextField;
@property (nonatomic, strong) UITextField * cardNumTextField;
@property (nonatomic, strong) UITextField * bankNameTextField;
@property (nonatomic, strong) UILabel * phoneNumLabel;
@property (nonatomic, strong) UITextField * phoneNumTextField;
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (BOOL)checkWirte;/**< 检查输入 */
@end

@implementation WPAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    self.titleLable.text = @"添加银行卡";
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:self.introLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.cardNumTextField];
    [self.view addSubview:self.bankNameTextField];
    [self.view addSubview:self.phoneNumLabel];
    [self.view addSubview:self.phoneNumTextField];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    if (![self checkWirte]) {
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在提交申请";
    __weak typeof(self)weakself = self;
    [NetWorkingManager submitBoundBankCardWithCardNumber:self.cardNumTextField.text bankName:self.bankNameTextField.text bindingname:self.nameTextField.text tel:self.phoneNumTextField.text SuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            hud.labelText = @"银行卡绑定成功";
            hud.detailsLabelText = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        } else {
            hud.labelText = responseObject[@"errMsg"]?responseObject[@"errMsg"]:@"绑定失败";
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
        }
    } failureHandler:^(NSError *error) {
        hud.labelText = @"提交失败";
        hud.detailsLabelText = @"网络错误";
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - system protocol
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.cardNumTextField && textField.text.length > 0) {
        NSString * msg = [ConfirmBankCardNumber isBankCardNum:self.cardNumTextField.text];
        self.bankNameTextField.text = msg;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField || textField == self.cardNumTextField ) {
        if (textField.text.length > 18) {
            return NO;
        }
    }
    if (textField == self.phoneNumTextField && textField.text.length > 10) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}
#pragma mark - private menthods
- (BOOL)checkWirte {
    if (self.nameTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入持卡人姓名"];
        return NO;
    }
    if (self.cardNumTextField.text.length == 0 || [[ConfirmBankCardNumber isBankCardNum:self.cardNumTextField.text] isEqualToString:@"不是正确格式的银行卡"]|| [[ConfirmBankCardNumber isBankCardNum:self.cardNumTextField.text] isEqualToString:@"银行卡位数不正确"]) {
        [self initializeAlertControllerWithMessage:@"请输入正确的银行卡号"];
        return NO;
    }
    if (self.bankNameTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入银行名称"];
        return NO;
    }
    if (self.phoneNumTextField.text.length == 0 || ![ConfirmMobileNumber isMobileNumber:self.phoneNumTextField.text]) {
        [self initializeAlertControllerWithMessage:@"请输入正确的电话号码"];
        return NO;
    }
    return YES;
}
#pragma mark - getter
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 310, 30) adjustWidth:YES];
            label.textColor = COLOR_RGB(171, 172, 173, 1);
            label.text = @"请绑定本人卡号";
            label;
        });
    }
    return _introLabel;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 320, 40) adjustWidth:NO];
            text.placeholder = @"请输入持卡人姓名";
            text.borderStyle = UITextBorderStyleNone;
            text.keyboardType = UIKeyboardTypeDefault;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40) adjustWidth:YES];
            label.text = @"持卡人";
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:YES];
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.backgroundColor = [UIColor whiteColor];
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1) adjustWidth:NO];
            line.backgroundColor = COLOR_RGB(210, 211, 212, 1);
            [text addSubview:line];
            text.delegate = self;
            text;
        });
    }
    return _nameTextField;
}
- (UITextField *)cardNumTextField {
    if (!_cardNumTextField) {
        _cardNumTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 140, 320, 40) adjustWidth:NO];
            text.placeholder = @"请输入银行卡卡号";
            text.borderStyle = UITextBorderStyleNone;
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40) adjustWidth:YES];
            label.text = @"卡号";
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:YES];
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.backgroundColor = [UIColor whiteColor];
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1) adjustWidth:NO];
            line.backgroundColor = COLOR_RGB(210, 211, 212, 1);
            [text addSubview:line];
            text.delegate = self;
            text;
        });
    }
    return _cardNumTextField;
}
- (UITextField *)bankNameTextField {
    if (!_bankNameTextField) {
        _bankNameTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 180, 320, 40) adjustWidth:NO];
            text.placeholder = @"请输入银行名称";
            text.borderStyle = UITextBorderStyleNone;
            text.keyboardType = UIKeyboardTypeDefault;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40) adjustWidth:YES];
            label.text = @"所属银行";
            label.adjustsFontSizeToFitWidth = YES;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:YES];
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.backgroundColor = [UIColor whiteColor];
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1) adjustWidth:NO];
            line.backgroundColor = COLOR_RGB(210, 211, 212, 1);
            [text addSubview:line];
            UIView * lineDownd = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1) adjustWidth:NO];
            lineDownd.backgroundColor = COLOR_RGB(210, 211, 212, 1);
            [text addSubview:lineDownd];
            text.delegate = self;
            text;
        });
    }
    return _bankNameTextField;
}
- (UILabel *)phoneNumLabel {
    if (!_phoneNumLabel) {
        _phoneNumLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 230, 310, 30) adjustWidth:NO];
            label.text = @"请填写您的电话号码";
            label;
        });
    }
    return _phoneNumLabel;
}
- (UITextField *)phoneNumTextField {
    if (!_phoneNumTextField) {
        _phoneNumTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 260, 320, 40) adjustWidth:NO];
            text.placeholder = @"请输入您的手机号";
            text.borderStyle = UITextBorderStyleNone;
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40) adjustWidth:YES];
            label.text = @"手机号";
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:YES];
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.returnKeyType = UIReturnKeyDone;
            text.delegate = self;
            text.backgroundColor = [UIColor whiteColor];
            UIView * lineUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1) adjustWidth:NO];
            lineUp.backgroundColor = COLOR_RGB(210, 211, 212, 1);
            [text addSubview:lineUp];
            UIView * lineDownd = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1) adjustWidth:NO];
            lineDownd.backgroundColor = COLOR_RGB(210, 211, 212, 1);
            [text addSubview:lineDownd];
            text.delegate = self;
            text;
        });
    }
    return _phoneNumTextField;
}
@end
