//
//  WPAddInsTopViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddInsTopViewController.h"
#import "WPDatePickView.h"
#import "WPInsureViewModel.h"

@interface WPAddInsTopViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * titleText;
@property (nonatomic, strong) UIView * budDayView;
@property (nonatomic, strong) UILabel * budDayLabel;
@property (nonatomic, strong) UIView * startDayView;
@property (nonatomic, strong) UILabel * startDayLabel;
@property (nonatomic, strong) UIView * endDayView;
@property (nonatomic, strong) UILabel * endDayLabel;
@property (nonatomic, strong) UIView * topDateView;
@property (nonatomic, strong) UILabel * topDateLabel;
@property (nonatomic, strong) UITextField * numText;
@property (nonatomic, strong) UITextField * detailText;

@end

@implementation WPAddInsTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.titleLable.text = @"新增保险提醒";
    UIBezierPath * path = [UIBezierPath bezierPath];
    [self.view addSubview:self.titleText];
    [self addLineWithYPosition:110 andWithPath:path];
    [self.view addSubview:self.budDayView];
    [self.view addSubview:self.numText];
    [self addLineWithYPosition:150 andWithPath:path];
    [self.view addSubview:self.detailText];
    [self addLineWithYPosition:190 andWithPath:path];
    [self.view addSubview:self.startDayView];
    [self addLineWithYPosition:230 andWithPath:path];
    [self.view addSubview:self.endDayView];
    [self.view addSubview:self.topDateView];
    [self addLineWithYPosition:320 andWithPath:path];

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
    if (self.budDayLabel.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请选择购买日期"];
        return;
    }
    if (self.numText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"输入保险金额"];
        return;
    }
    if (self.detailText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写保险内容"];
        return;
    }
    if (self.startDayLabel.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请选择开始日期"];
        return;
    }
    if (self.endDayLabel.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请选择结束日期"];
        return;
    }
    if (self.topDateLabel.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请选择下次提醒日期"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在保存";
    __weak typeof(self)weakself = self;
    [WPInsureViewModel addInsuranceWithBuyDate:self.budDayLabel.text insuranceDetail:self.detailText.text startTime:self.startDayLabel.text endTime:self.endDayLabel.text insurancePay:self.numText.text nextTopDate:self.topDateLabel.text WithSuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSString *error) {
        hud.labelText = @"保存失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}
- (void)respondsToBuyDayDate {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.budDayLabel.text = destDateString;
    }];
    
}

- (void)respondsToStartDayDate {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.startDayLabel.text = destDateString;
    }];
    
}

- (void)respondsToEndDayDate {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.endDayLabel.text = destDateString;
    }];
}
- (void)respondsToTopDate {
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
            text.text = @"请填写您的保险信息";
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _titleText;
}
- (UIView *)budDayView {
    if (!_budDayView) {
        _budDayView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 180, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"购买日期:";
            [view addSubview:label];
            [view addSubview:self.budDayLabel];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _budDayView;
}
- (UILabel *)budDayLabel {
    if (!_budDayLabel) {
        _budDayLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 90, 40)];
            label.text = @"请选择购买日期";
            label.textColor = GARYTextColor;
            label.adjustsFontSizeToFitWidth = YES;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToBuyDayDate)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label;
        });
    }
    return _budDayLabel;
}
- (UITextField *)numText {
    if (!_numText) {
        _numText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(160, 110, 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"保险金额:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = GARYTextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.placeholder = @"请填写保险金额";
            text.adjustsFontSizeToFitWidth = YES;
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
            label.text = @"保险内容:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = GARYTextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.placeholder = @"请填写保险内容";
            text.returnKeyType = UIReturnKeyNext;
            text.adjustsFontSizeToFitWidth = YES;
            text.delegate = self;
            text;
        });
    }
    return _detailText;
}
- (UIView *)startDayView {
    if (!_startDayView) {
        _startDayView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 190, 320, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"保险开始日期:";
            [view addSubview:label];
            [view addSubview:self.startDayLabel];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            view;
        });
    }
    return _startDayView;
}
- (UILabel *)startDayLabel {
    if (!_startDayLabel) {
        _startDayLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 170, 40)];
            label.text = @"请选择保险开始日期";
            label.textColor = GARYTextColor;
            label.adjustsFontSizeToFitWidth = YES;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToStartDayDate)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label;
        });
    }
    return _startDayLabel;
}
- (UIView *)endDayView {
    if (!_endDayView) {
        _endDayView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 230, 320, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"保险结束日期:";
            [view addSubview:label];
            [view addSubview:self.endDayLabel];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            view;

        });
    }
    return _endDayView;
}
- (UILabel *)endDayLabel {
    if (!_endDayLabel) {
        _endDayLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 170, 40)];
            label.text = @"请选择保险结束日期";
            label.textColor = GARYTextColor;
            label.adjustsFontSizeToFitWidth = YES;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToEndDayDate)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label;
        });
    }
    return _endDayLabel;
}
- (UIView *)topDateView {
    if (!_topDateView) {
        _topDateView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 280, 320, 40) adjustWidth:NO];
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
    return _topDateView;
}
- (UILabel *)topDateLabel {
    if (!_topDateLabel) {
        _topDateLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 160, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"下次保养提醒日期";
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToTopDate)];
            [label addGestureRecognizer:ges];
            label.userInteractionEnabled = YES;
            label.textColor = COLOR_RGB(0, 175, 224, 1);
            label;
        });
    }
    return _topDateLabel;
}


@end
