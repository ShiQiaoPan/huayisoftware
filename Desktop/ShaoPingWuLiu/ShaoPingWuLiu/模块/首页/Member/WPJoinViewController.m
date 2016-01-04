//
//  WPJoinViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPJoinViewController.h"
#import "WKAlertView.h"
#import "NetWorkingManager+Member.h"

@interface WPJoinViewController ()<UITextFieldDelegate> {
    UIWindow * _topWindow;
}
@property (nonatomic, strong) UILabel * joinLabel;
@property (nonatomic, strong) UITextField * companyNameText;
@property (nonatomic, strong) UITextField * nameText;
@property (nonatomic, strong) UITextField * contactText;
@property (nonatomic, strong) UILabel * introLabel;
@property (nonatomic, strong) UIButton * doneBtn;

- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    [self.rightButton removeFromSuperview];
    self.view.backgroundColor = BGCOLOR;UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    backLabel.adjustsFontSizeToFitWidth = YES;
    [self.baseNavigationBar addSubview:backLabel];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [self.view addSubview:self.joinLabel];
    [self.view addSubview:self.companyNameText];
    [self addLineWithYPosition:170 andWithPath:path];
    [self.view addSubview:self.nameText];
    [self addLineWithYPosition:220 andWithPath:path];
    [self.view addSubview:self.contactText];
    [self addLineWithYPosition:270 andWithPath:path];
    [self.view addSubview:self.doneBtn];
    [self.view addSubview:self.introLabel];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 800), NO);
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToDoneBtn {
    if (self.nameText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写您的姓名"];
        return;
    }
    if (self.contactText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写您的联系方式"];
        return;
    }
    [self.view endEditing:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.labelText = @"请申请";
    hud.labelColor = [UIColor blackColor];
    hud.detailsLabelText = @"正在提交申请";
    hud.detailsLabelColor = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor blackColor];
    __weak typeof(self)weakself = self;
    [NetWorkingManager submitMemberWithName:self.nameText.text tel:self.contactText.text company:self.companyNameText.text successHandler:^(id responseObject) {
        if ([responseObject[@"codel"] integerValue] != 0) {
            hud.labelText = @"提交失败";
        } else {
            _topWindow = [WKAlertView showAlertViewWithTitle:@"提交申请成功" detail:@"我们会尽快联系您" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
                _topWindow.hidden = YES;
                _topWindow = nil;
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }
        [hud hide:YES afterDelay:1.0];
        
    } failureHandler:^(NSError *error) {
        [self initializeAlertControllerWithMessage:error.localizedDescription];
        [hud hide:YES];
    }];
}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.companyNameText && textField.text.length > 30) {
        return NO;
    }
    if (textField == self.nameText && textField.text.length > 20) {
        return NO;
    }
    if (textField == self.contactText && textField.text.length > 15) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.companyNameText) {
        [self.nameText becomeFirstResponder];
    }
    else if (textField == self.nameText) {
        [self.contactText becomeFirstResponder];
    }
    else if (textField == self.contactText) {
        [self respondsToDoneBtn];
    }
    return YES;
}
#pragma mark - private menthods
- (void)addLineWithYPosition :(CGFloat)y andWithPath:(UIBezierPath *)path{
    [path moveToPoint:DHFlexibleCenter(CGPointMake(20, y))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(280, y))];
    path.lineWidth = 1;
}

#pragma mark - getter
- (UILabel *)joinLabel {
    if (!_joinLabel) {
        _joinLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 310, 40) adjustWidth:NO];
            label.text = @"我要加盟";
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _joinLabel;
}
- (UITextField *)companyNameText {
    if (!_companyNameText) {
        _companyNameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(20, 130, 280, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"公司名称:";
            text.leftView = label;
            text.placeholder = @"(可不填)";
            text.adjustsFontSizeToFitWidth = YES;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            text;
        });
    }
    return _companyNameText;
}
- (UITextField *)nameText {
    if (!_nameText) {
        _nameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(20, 180, 280, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"您的姓名:";
            text.leftView = label;
            text.placeholder = @"(必填)";
            text.adjustsFontSizeToFitWidth = YES;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyNext;
            text.delegate = self;
            text;
        });
    }
    return _nameText;
}
- (UITextField *)contactText {
    if (!_contactText) {
        _contactText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, 280, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"联系电话:";
            text.leftView = label;
            text.placeholder = @"(必填)";
            text.adjustsFontSizeToFitWidth = YES;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            text.delegate = self;
            text;
        });
    }
    return _contactText;
}
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 310, 30) adjustWidth:NO];
            lab.text = @"请如实填写您的信息，以便我们联系您";
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = COLOR_RGB(121, 185, 251, 1);
            lab;
        });
    }
    return _introLabel;
}
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 330, 300, 45) adjustWidth:YES];
            [btn setTitle:@"提交" forState:UIControlStateNormal];
            btn.backgroundColor = COLOR_RGB(240, 81, 51, 1);
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToDoneBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _doneBtn;
}
@end
