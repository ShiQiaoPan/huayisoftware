//
//  WPAddPhoneViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/19.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddPhoneViewController.h"
#import "NetWorkingManager+LinkModel.h"

@interface WPAddPhoneViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * introLabel;
@property (nonatomic, strong) UITextField * nameText;
@property (nonatomic, strong) UITextField * phoneText;

- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPAddPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    self.titleLable.text = @"添加关联号";
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:self.introLabel];
    [self.view addSubview:self.nameText];
    [self.view addSubview:self.phoneText];
    [self addLine];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    if (self.nameText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入姓名"];
        return;
    }
    if (![ConfirmMobileNumber isMobileNumber:self.phoneText.text ]) {
        [self initializeAlertControllerWithMessage:@"请输入正确的电话号码"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在保存联系人";
    __weak typeof(self)weakself = self;
    [NetWorkingManager addLinkPersonWithName:self.nameText.text phone:self.phoneText.text successHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0 && responseObject[@"errMsg"]) {
            hud.labelText = responseObject[@"errMsg"];
            hud.detailsLabelText = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES afterDelay:1.0];
                [weakself.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
            hud.labelText = @"网络数据错误";
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
        }
    } failureHandler:^(NSError *error) {
        hud.detailsLabelText = error.localizedDescription;
        hud.labelText = nil;
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 10) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.nameText) {
        [self.phoneText becomeFirstResponder];
    }
    return YES;
}
#pragma mark - private methods
- (void)addLine {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.introLabel.frame))];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, CGRectGetMaxY(self.introLabel.frame))];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.nameText.frame))];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, CGRectGetMaxY(self.nameText.frame))];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.phoneText.frame))];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, CGRectGetMaxY(self.phoneText.frame))];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.view.frame;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = GARYTextColor.CGColor;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}

#pragma mark - getter
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 310, 30) adjustWidth:YES];
            label.textColor = COLOR_RGB(171, 172, 173, 1);
            label.text = @"请输入您要关联的联系方式";
            label;
        });
    }
    return _introLabel;
}
- (UITextField *)nameText {
    if (!_nameText) {
        _nameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introLabel.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40) adjustWidth:NO];
            label.text = @"联系人姓名";
            label.adjustsFontSizeToFitWidth = YES;
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.placeholder = [NSString stringWithFormat:@"姓名"];
            text.returnKeyType = UIReturnKeyNext;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text;
        });
    }
    return _nameText;
}
- (UITextField *)phoneText {
    if (!_phoneText) {
        _phoneText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameText.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40) adjustWidth:NO];
            label.text = @"联系号码";
            label.adjustsFontSizeToFitWidth = YES;
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.placeholder = [NSString stringWithFormat:@"电话号码"];
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text;
        });
    }
    return _phoneText;
}
@end
