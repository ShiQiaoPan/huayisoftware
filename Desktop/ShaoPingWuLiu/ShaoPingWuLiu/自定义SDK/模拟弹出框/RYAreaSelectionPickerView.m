//
//  RYAreaSelectionPickerView.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYAreaSelectionPickerView.h"

@interface RYAreaSelectionPickerView ()
<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView * pickView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * determineButton;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, copy) void (^complete)(NSString *result);


@end

@implementation RYAreaSelectionPickerView

+ (RYAreaSelectionPickerView *)showViewWithcomplete:(void(^)(NSString *result))complete {
    RYAreaSelectionPickerView * pickview = [[RYAreaSelectionPickerView alloc]initWithComplete:complete];
    [pickview show];
    return pickview;
}
- (instancetype)initWithComplete:(void(^)(NSString *date))complete {
    self = [super init];
    if (self) {
        self.complete = complete;
        [self initDataSource];
        [self initalizeUserInterface];
    }
    return self;
}
- (void)initDataSource {
    
}
- (void)initalizeUserInterface {
    [self addSubview:self.titleLabel];
    [self addSubview:self.determineButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.pickView];
}
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - 50)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 50)];
    path.lineWidth = 2;
    UIColor *color = [UIColor orangeColor];
    [color setStroke];
    [path stroke];
}

#pragma mark - responds events
- (void)confirmation {
   
    _complete(@"12");
    [self hide];
}
#pragma mark---协议UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}
#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
            label.backgroundColor = [UIColor orangeColor];
            label.text = @"地址选择";
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithRed:232/255.0 green:233/255.0 blue:232/255.0 alpha:1];
            label;
        });
    }
    return _titleLabel;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelbutton.frame = CGRectMake(10, CGRectGetHeight(self.bounds) - 40, 50, 37);
            cancelbutton.backgroundColor = [UIColor orangeColor];
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelbutton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            cancelbutton;
        });
    }
    return _cancelButton;
}
- (UIButton *)determineButton {
    if (!_determineButton) {
        _determineButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60, CGRectGetHeight(self.bounds) - 40, 50, 37);
            button.backgroundColor = [UIColor orangeColor];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(confirmation) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _determineButton;
}
- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = ({
            UIPickerView * view = [[UIPickerView alloc]init];
            view.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.95, CGRectGetHeight(self.bounds) * 0.5);
            view.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
            view.dataSource = self;
            view.delegate = self;
            view.showsSelectionIndicator = NO;
            view;
        });
    }
    return _pickView;
}


@end
