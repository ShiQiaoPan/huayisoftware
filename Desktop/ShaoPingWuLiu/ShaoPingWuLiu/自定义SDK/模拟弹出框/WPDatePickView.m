//
//  WPDatePickView.m
//  LikeAlertView
//
//  Created by rimi on 15/9/7.
//  Copyright © 2015年 魏攀. All rights reserved.
//

#import "WPDatePickView.h"

@interface WPDatePickView ()
{
    NSString *_alertTitle;
    NSDate *_maxDate;
    NSDate *_minDate;
    UIDatePickerMode _pikerMode;
}
@property (nonatomic, copy) void (^complete)(NSDate *date);
@end
@implementation WPDatePickView

+ (WPDatePickView *)showViewWithTitle:(NSString *)title datePickerMode: (UIDatePickerMode) datePickerMode maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate complete:(void(^)(NSDate *date))complete {
    WPDatePickView * pickview = [[WPDatePickView alloc]initWithTitle:title datePickerMode: (UIDatePickerMode) datePickerMode maxDate:maxDate minDate:minDate complete:complete];
    [pickview show];
    return pickview;
}
- (instancetype)initWithTitle:(NSString *)title datePickerMode: (UIDatePickerMode) datePickerMode maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate complete:(void(^)(NSDate *date))complete {
    self = [super init];
    if (self) {
        _complete = complete;
        _alertTitle = title;
        _maxDate = maxDate;
        _minDate = minDate;
        _complete = complete;
        _pikerMode = datePickerMode;
        [self initalizeUserInterface];
    }
    return self;
}
- (void)initalizeUserInterface {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
    label.backgroundColor = REDBGCOLOR;
    label.text = _alertTitle;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60, CGRectGetHeight(self.bounds) - 40, 50, 37);
    button.backgroundColor = REDBGCOLOR;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmation) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(10, CGRectGetHeight(self.bounds) - 40, 50, 37);
    cancelbutton.backgroundColor = REDBGCOLOR;
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self addSubview:cancelbutton];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.95, CGRectGetHeight(self.bounds) * 0.5);
    _datePicker.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    _datePicker.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _datePicker.minimumDate = _minDate;
    _datePicker.maximumDate = _maxDate;
    _datePicker.datePickerMode = _pikerMode;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    [self addSubview:_datePicker];
    
}

- (void)confirmation {
    _complete(_datePicker.date);
    [self hide];
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - 50)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 50)];
    path.lineWidth = 2;
    UIColor *color = REDBGCOLOR;
    [color setStroke];
    
    [path stroke];
    
}

@end
