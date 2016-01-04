//
//  RYSendDateSeclectView.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/18.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYSendDateSeclectView.h"
#import "WPDatePickView.h"

#define maxFont      17.0f
#define normalFont   15.0f
#define minFont      12.0f

#define mSpace       20.0f
#define normalHeight 30.0f

#define mBGColor     [UIColor colorWithWhite:0.66 alpha:1]
#define bTextColor   COLOR_RGB(110, 183, 234, 1)

#define defaultDateSelection @"点击选择日期"

@interface RYSendDateSeclectView ()

@property (nonatomic, strong) UILabel  *ryTitleLabel;       /**< 标题        */
@property (nonatomic, strong) UILabel  *beginDateLabel;     /**< 起始        */
@property (nonatomic, strong) UILabel  *endDateLabel;       /**< 结束        */
@property (nonatomic, strong) UIButton *beginDateButton;    /**< 选择起始日期 */
@property (nonatomic, strong) UIButton *endDateButton;      /**< 选择结束日期 */

@property (nonatomic, strong) UIView   *middleView;         /**< 分割的view  */
@property (nonatomic, strong) UILabel  *consigneeLabel;     /**< 收货人      */
@property (nonatomic, strong) UIButton *submitButton;       /**< 提交按钮    */
@property (nonatomic, strong) UILabel  *messageLabel;       /**< 提示信息    */
@property (nonatomic, strong) UIButton *cancelButton;       /**< 取消按钮    */
@property (nonatomic, strong) UITextField  *conTelTextField;/**< 收货人电话  */
@property (nonatomic, copy) void (^operation)(NSDictionary *select); /**< 回调词典  */

@end

@implementation RYSendDateSeclectView

+ (RYSendDateSeclectView *)showSendSelecionViewWithOperation:(void (^)(NSDictionary *))operation {
    RYSendDateSeclectView *vi = [[RYSendDateSeclectView alloc] initWithComplete:operation];
    [vi show];
    return vi;
}

#pragma mark - init

- (instancetype)initWithComplete:(void(^)(NSDictionary *result))operation {
    if (self = [super initWithSize:CGSizeMake(SCREEN_SIZE.width * 0.8, normalHeight * 6 + mSpace * 4 + 5)]) {
        self.operation = operation;
        [self initalizeUserInterface];
    }
    return self;
}

- (void)initalizeUserInterface {
    [self addSubview:self.ryTitleLabel];
    [self addSubview:self.beginDateLabel];
    [self addSubview:self.beginDateButton];
    [self addSubview:self.endDateLabel];
    [self addSubview:self.endDateButton];
    [self addSubview:self.middleView];
    [self addSubview:self.consigneeLabel];
    [self addSubview:self.conTelTextField];
    [self addSubview:self.submitButton];
    [self addSubview:self.messageLabel];
    [self addSubview:self.cancelButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - events responds
- (void) keyboardWillShow:(NSNotification *) sender {
    CGFloat hight;
    if (SCREEN_SIZE.width == 320) {
        hight = self.bounds.size.height / 2 + mSpace;
    }
    else {
        hight = self.bounds.size.height / 2 - mSpace;
    }
    CGRect rect    = self.frame;
    rect.origin.y -= hight;
    self.frame     = rect;
}
- (void) keyboardWillHide:(NSNotification *) sender {
    CGFloat hight;
    if (SCREEN_SIZE.width == 320) {
        hight = self.bounds.size.height / 2 + mSpace;
    }
    else {
        hight = self.bounds.size.height / 2 - mSpace;
    }
    CGRect rect    = self.frame;
    rect.origin.y += hight;
    self.frame     = rect;
}
- (void) respondsToDateBtuClicked:(UIButton *) sender {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [WPDatePickView showViewWithTitle:@"时间选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *destDateString = [dateFormatter stringFromDate:date];
            [sender setTitle:destDateString forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
        }];
}
- (void) respondsToSubmitButton:(UIButton *) sender {
    if ([self.beginDateButton.currentTitle isEqualToString:defaultDateSelection] || [self.endDateButton.currentTitle isEqualToString:defaultDateSelection] || [self.beginDateButton.currentTitle compare:self.endDateButton.currentTitle] == NSOrderedDescending) {
        self.operation(nil);
    }
    else {
        NSDictionary *dict = @{@"beginDateString":self.beginDateButton.currentTitle,
                               @"endDateString":self.endDateButton.currentTitle,
                               @"consigneeTele":self.conTelTextField.text};
        self.operation(dict);
    }
    [self hide];
}
- (void) respondsToCancelButton:(UIButton *) sender {
    [self hide];
}

#pragma mark - getter methods
- (UILabel *)ryTitleLabel {
    if (!_ryTitleLabel) {
        _ryTitleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(mSpace,mSpace, CGRectGetWidth(self.bounds) - mSpace * 2, normalHeight)];
        _ryTitleLabel.text = @"请选择日期：";
        _ryTitleLabel.font = [UIFont systemFontOfSize:maxFont];
    }
    return _ryTitleLabel;
}

- (UILabel *)beginDateLabel {
    if (!_beginDateLabel) {
        _beginDateLabel      = [[UILabel alloc] initWithFrame:CGRectMake(self.ryTitleLabel.frame.origin.x + mSpace / 2, CGRectGetMaxY(self.ryTitleLabel.frame), 70, normalHeight)];
        _beginDateLabel.text = @" 开始日期";
        _beginDateLabel.font = [UIFont systemFontOfSize:normalFont];
        _beginDateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _beginDateLabel;
}

- (UILabel *)endDateLabel {
    if (!_endDateLabel) {
        _endDateLabel      = [[UILabel alloc] initWithFrame:CGRectMake(self.beginDateLabel.frame.origin.x, CGRectGetMaxY(self.beginDateLabel.frame) + mSpace, self.beginDateLabel.frame.size.width, self.beginDateLabel.frame.size.height)];
        _endDateLabel.text = @"结束日期";
        _endDateLabel.font = [UIFont systemFontOfSize:normalFont];
        _endDateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _endDateLabel;
}

- (UIButton *)beginDateButton {
    if (!_beginDateButton) {
        _beginDateButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _beginDateButton.frame = CGRectMake(CGRectGetWidth(self.bounds) / 2, self.beginDateLabel.frame.origin.y, CGRectGetWidth(self.ryTitleLabel.frame) / 2, self.beginDateLabel.frame.size.height);
        _beginDateButton.titleLabel.font = [UIFont systemFontOfSize:normalFont];
        [_beginDateButton setTitle:defaultDateSelection forState:UIControlStateNormal];
        [_beginDateButton setTitleColor:mBGColor forState:UIControlStateNormal];
        [_beginDateButton addTarget:self action:@selector(respondsToDateBtuClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginDateButton;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.ryTitleLabel.frame.origin.x, CGRectGetMaxY(self.beginDateLabel.frame) + mSpace / 2)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.ryTitleLabel.frame), CGRectGetMaxY(self.beginDateLabel.frame) + mSpace / 2)];
    path.lineWidth     = 1;
    UIColor *color     = mBGColor;
    [color setStroke];
    [path stroke];
}

- (UIButton *)endDateButton {
    if (!_endDateButton) {
        _endDateButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _endDateButton.frame = CGRectMake(self.beginDateButton.frame.origin.x, self.endDateLabel.frame.origin.y, self.beginDateButton.frame.size.width, self.beginDateButton.frame.size.height);
        _endDateButton.titleLabel.font = [UIFont systemFontOfSize:normalFont];
        [_endDateButton setTitle:defaultDateSelection forState:UIControlStateNormal];
        [_endDateButton setTitleColor:mBGColor forState:UIControlStateNormal];
        [_endDateButton addTarget:self action:@selector(respondsToDateBtuClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    return _endDateButton;
}

- (UIView *)middleView {
    if (!_middleView) {
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(self.ryTitleLabel.frame.origin.x, CGRectGetMaxY(self.endDateLabel.frame) + mSpace / 2, self.ryTitleLabel.frame.size.width, 5)];
        _middleView.backgroundColor = mBGColor;
    }
    return _middleView;
}

- (UILabel *)consigneeLabel {
    if (!_consigneeLabel) {
        _consigneeLabel      = [[UILabel alloc] initWithFrame:CGRectMake(self.ryTitleLabel.frame.origin.x, CGRectGetMaxY(self.middleView.frame) + mSpace / 2, self.ryTitleLabel.frame.size.width / 2, normalHeight)];
        _consigneeLabel.text = @"收货人电话";
        _consigneeLabel.font = [UIFont systemFontOfSize:normalFont];
    }
    return _consigneeLabel;
}

- (UITextField *)conTelTextField {
    if (!_conTelTextField) {
        _conTelTextField              = [[UITextField alloc] initWithFrame:CGRectMake(self.endDateButton.frame.origin.x - 10, self.consigneeLabel.frame.origin.y, self.endDateButton.frame.size.width + 10, self.endDateButton.frame.size.height)];
        _conTelTextField.placeholder  = @"(可不填)";
        _conTelTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _conTelTextField;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(self.ryTitleLabel.frame.origin.x + mSpace / 2, CGRectGetMaxY(self.consigneeLabel.frame) + mSpace / 2, CGRectGetWidth(self.ryTitleLabel.frame) - mSpace, normalHeight);
        _submitButton.layer.cornerRadius  = 4;
        _submitButton.layer.masksToBounds = YES;
        _submitButton.titleLabel.font     = [UIFont systemFontOfSize:maxFont];
        [_submitButton addTarget:self action:@selector(respondsToSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:REDBGCOLOR];
    }
    return _submitButton;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel           = [[UILabel alloc] initWithFrame:CGRectMake(self.ryTitleLabel.frame.origin.x, CGRectGetMaxY(_submitButton.frame) + mSpace / 2, 200, normalHeight)];
        _messageLabel.text      = @"可查选最近6个月信息";
        _messageLabel.font      = [UIFont systemFontOfSize:minFont];
        _messageLabel.textColor = bTextColor;
    }
    return _messageLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(CGRectGetMaxX(self.ryTitleLabel.frame) - 60, self.messageLabel.frame.origin.y, 60, normalHeight);
        [_cancelButton addTarget:self action:@selector(respondsToCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:normalFont];
        [_cancelButton setTitleColor:bTextColor forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
