//
//  WPAddExamTopViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddExamTopViewController.h"
#import "WPDatePickView.h"
#import "WPAddExamViewModel.h"

@interface WPAddExamTopViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * titleText;
@property (nonatomic, strong) UITextField * yearDayText;
@property (nonatomic, strong) UIView * nextTopView;
@property (nonatomic, strong) UILabel * topDateLabel;
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPAddExamTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.titleLable.text = @"新增年审提醒";
    UIBezierPath * path = [UIBezierPath bezierPath];
    [self.view addSubview:self.titleText];
    [self addLineWithYPosition:110 andWithPath:path];
    [self.view addSubview:self.yearDayText];
    [self.view addSubview:self.nextTopView];
    [self addLineWithYPosition:200 andWithPath:path];
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
    if (self.yearDayText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请选择年审日期"];
        return;
    }
    if (self.topDateLabel.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请选择下次提醒日期"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在保存记录";
    __weak typeof(self)weakself = self;
    [WPAddExamViewModel addExamTopWithExamDate:self.yearDayText.text nextTopDate:self.topDateLabel.text WithSuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText= nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakself.navigationController popViewControllerAnimated:YES];
        });

    } failBlock:^(NSString *error) {
        hud.labelText = @"保存失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        textField.text = destDateString;
    }];
    return NO;
}
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
            text.text = @"请填写您的年审信息";
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _titleText;
}
- (UITextField *)yearDayText {
    if (!_yearDayText) {
        _yearDayText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 110, 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"年审日期:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = GARYTextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.placeholder = @"请选择年审日期";
            text.adjustsFontSizeToFitWidth = YES;
            text.delegate = self;
            text;
            
        });
    }
    return _yearDayText;
}
- (UIView *)nextTopView {
    if (!_nextTopView) {
        _nextTopView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 160, 320, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
            label.adjustsFontSizeToFitWidth = YES;
            label.text = @"下次年审提醒日期:";
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
            label.text = @"下次年审提醒日期";
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
