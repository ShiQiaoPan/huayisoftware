//
//  WPAddAddressViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/13.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddAddressViewController.h"
#import "WPAddMangerViewModel.h"

@interface WPAddAddressViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UITextField * nameTextField;
@property (nonatomic, strong) UILabel * contactLabel;
@property (nonatomic, strong) UITextField * contactTextField;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UITextField * addressTextView;

- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"添加地址";
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.contactLabel];
    [self.view addSubview:self.contactTextField];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressTextView];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    if (self.nameTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入发货人姓名"];
        return;
    }
    if (self.contactTextField.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入联系方式"];
        return;
    }
    if (self.addressTextView.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入发货人地址"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = self.addIndex ? @"正在保存收货地址": @"正在保存发货地址";
    __weak typeof(self)weakself = self;
    if (self.addIndex == 0) {
        [WPAddMangerViewModel addSendAddressWithName:self.nameTextField.text phoneNum:self.contactTextField.text address:self.addressTextView.text SuccessBlock:^(NSString *success) {
            hud.labelText = success;
            hud.detailsLabelText = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [weakself.navigationController popViewControllerAnimated:YES];
                
            });
            
        } failBlock:^(NSString *error) {
            hud.labelText = @"网络错误保存失败";
            hud.detailsLabelText = error;
            [hud hide:YES afterDelay:2.0];
        }];
        return;
    }
    [WPAddMangerViewModel addReciveAddressWithName:self.nameTextField.text phoneNum:self.contactTextField.text address:self.addressTextView.text SuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakself.navigationController popViewControllerAnimated:YES];
            
        });

    } failBlock:^(NSString *error) {
        hud.labelText = @"网络错误保存失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - system protocol
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField) {
        if (textField.text.length > 40) {
            return NO;
        }
    }
    else if (textField == self.contactTextField) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    else if (textField == self.addressTextView) {
        if (textField.text.length > 80) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.nameTextField) {
        [self.nameTextField becomeFirstResponder];
    }
    else if (textField == self.addressTextView) {
        [self respondsToNavBarRightButton:nil];
    }
    return YES;
}
#pragma mark - getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 90, 35) adjustWidth:NO];
            label.text = self.addIndex == 0 ? @"发货人":@"收货人";
            label.textColor = COLOR_RGB(120, 121, 122, 1);
            label;
        });
    }
    return _nameLabel;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = ({
            UITextField * text  = [[UITextField alloc]initWithFrame:CGRectMake(80, 80, 230, 35) adjustWidth:NO];
            text.placeholder = @"请输入姓名";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.returnKeyType = UIReturnKeyNext;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _nameTextField;
}
- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame)/DHFlexibleVerticalMutiplier()+10, 90, 35) adjustWidth:NO];
            label.text = @"联系方式";
            label.textColor = COLOR_RGB(120, 121, 122, 1);
            label;
        });
    }
    return _contactLabel;
}
- (UITextField *)contactTextField {
    if (!_contactTextField) {
        _contactTextField = ({
            UITextField * text  = [[UITextField alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(self.nameLabel.frame)/DHFlexibleVerticalMutiplier()+10, 230, 35) adjustWidth:NO];
            text.placeholder = @"请输入联系方式";
            text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _contactTextField;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.contactLabel.frame)/DHFlexibleVerticalMutiplier()+10, 90, 35) adjustWidth:NO];
            label.text = @"详细地址";
            label.textColor = COLOR_RGB(120, 121, 122, 1);
            label;
        });
    }
    return _addressLabel;
}
- (UITextField *)addressTextView {
    if (!_addressTextView) {
        _addressTextView = ({
            UITextField * text  = [[UITextField alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(self.contactLabel.frame)/DHFlexibleVerticalMutiplier()+10, 230, 35) adjustWidth:NO];
            text.placeholder = @"请输入详细地址";
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _addressTextView;
}
@end
