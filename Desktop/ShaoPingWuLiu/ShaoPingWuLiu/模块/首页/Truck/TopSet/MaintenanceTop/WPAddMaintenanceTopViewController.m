//
//  WPAddYearTopViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddMaintenanceTopViewController.h"
#import "WPDatePickView.h"
#import "WPMaintenanceViewModel.h"

@interface WPAddMaintenanceTopViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * titleText;
@property (nonatomic, strong) UIView * dateView;
@property (nonatomic, strong) UILabel * dateIntroLabel;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UITextField * numText;
@property (nonatomic, strong) UITextField * detailText;
@property (nonatomic, strong) UIView * nextTopView;
@property (nonatomic, strong) UILabel * topIntroLabel;
@property (nonatomic, strong) UILabel * topDateLabel;
@end

@implementation WPAddMaintenanceTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.titleLable.text = @"新增保养提醒";
    UIBezierPath * path = [UIBezierPath bezierPath];
    [self.view addSubview:self.titleText];
    [self addLineWithYPosition:110 andWithPath:path];
    [self.view addSubview:self.dateView];
    [self.view addSubview:self.numText];
    [self addLineWithYPosition:150 andWithPath:path];
    [self.view addSubview:self.detailText];
    [self.view addSubview:self.nextTopView];
    [self addLineWithYPosition:240 andWithPath:path];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 800), NO);
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    if (self.dateLabel.text.length == 4) {
        [self initializeAlertControllerWithMessage:@"请选择保养日期"];
        return;
    }
    if (self.numText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写保养金额"];
        return;
    }
    if (self.detailText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写保养内容"];
        return;
    }
    if (self.topDateLabel.text.length == 8) {
        [self initializeAlertControllerWithMessage:@"请选择提醒日期"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在保存保养记录";
    __weak typeof(self)weakself = self;
    [WPMaintenanceViewModel addMaintenanceWithInsuranceDate:self.dateLabel.text andInsuranceDetail:self.detailText.text andInsurancePay:self.numText.text nextTopDate:self.topDateLabel.text WithSuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakself.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSString *error) {
        hud.labelText = @"保存失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}
- (void)respondsToData {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
       self.dateLabel.text = destDateString;
    }];
}
- (void)respondsToTopData {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.topDateLabel.text = destDateString;
    }];

}
#pragma mark - system protocol
#pragma mark - private methods
- (void)addLineWithYPosition :(CGFloat)y andWithPath:(UIBezierPath *)path{
    [path moveToPoint:DHFlexibleCenter(CGPointMake(0, y))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, y))];
    path.lineWidth = 1;
}
#pragma mark - getter
- (UITextField *)titleText {
    if (!_titleText) {
        _titleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 70, 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
            text.leftView = view;
            text.text = @"请填写您的保养信息";
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _titleText;
}
- (UIView *)dateView {
    if (!_dateView) {
        _dateView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 180, 40) adjustWidth:NO];
            [view addSubview:self.dateIntroLabel];
            [view addSubview:self.dateLabel];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _dateView;
}
- (UILabel *)dateIntroLabel {
    if (!_dateIntroLabel) {
        _dateIntroLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40) adjustWidth:NO];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"保养日期:";
            label;
        });
    }
    return _dateIntroLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 80, 40) adjustWidth:NO];
            label.text = @"请选择保养日期";
            label.textColor = GARYTextColor;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToData)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
    }
    return _dateLabel;
}
- (UITextField *)numText {
    if (!_numText) {
        _numText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(160, 110, 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"保养金额:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = GARYTextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.placeholder = @"请填写保养金额";
            text.adjustsFontSizeToFitWidth = YES;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text;
        });
    }
    return _numText;
}
- (UITextField *)detailText {
    if (!_detailText) {
        _detailText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 150, 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"保养内容:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = GARYTextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.placeholder = @"请填写保养内容";
            text.returnKeyType = UIReturnKeyNext;
            text.adjustsFontSizeToFitWidth = YES;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _detailText;
}
- (UIView *)nextTopView {
    if (!_nextTopView) {
        _nextTopView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"下次保养提醒日期:";
            [view addSubview:label];
            [view addSubview:self.topDateLabel];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _nextTopView;
}
- (UILabel *)topDateLabel {
    if (!_topDateLabel) {
        _topDateLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 160, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"下次保养提醒日期";
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToTopData)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label.textColor = COLOR_RGB(0, 175, 224, 1);
            label;
        });
    }
    return _topDateLabel;
}


@end
