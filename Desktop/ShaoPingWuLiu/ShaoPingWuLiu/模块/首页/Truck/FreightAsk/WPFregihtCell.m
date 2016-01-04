//
//  WPFregiCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/17.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPFregihtCell.h"

@interface WPFregihtCell ()
- (void)initializeAppearance;

@end
@implementation WPFregihtCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    [self addSubview:self.dataLabel];
    [self addSubview:self.addLabel];
    [self addSubview:self.fregihtText];
    [self addSubview:self.oilCardText];
    [self addSubview:self.transferText];
    [self addSubview:self.stateText];
}
#pragma mark - private methods
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.fregihtText.frame))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(self.fregihtText.frame))];
    path.lineWidth = 1;
    UIColor *color = GARYTextColor;
    [color setStroke];
    
    [path stroke];
    
}
#pragma mark - getter
- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetMidX(self.bounds), 40)];
            lab.adjustsFontSizeToFitWidth = YES;
            lab;
        });
    }
    return _dataLabel;
}
- (UILabel *)addLabel {
    if (!_addLabel) {
        _addLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dataLabel.frame), 0, CGRectGetWidth(self.bounds), 40)];
            lab.adjustsFontSizeToFitWidth = YES;
            lab;
        });
    }
    return _addLabel;
}
- (UITextField *)fregihtText {
    if (!_fregihtText) {
        _fregihtText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dataLabel.frame), CGRectGetWidth(self.bounds)/3, 40)];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
            label.text = @"运费:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = COLOR_RGB(244, 148, 138, 1);
            text.enabled = NO;
            text.adjustsFontSizeToFitWidth = YES;
            text;
        });
    }
    return _fregihtText;
}
- (UITextField *)oilCardText {
    if (!_oilCardText) {
        _oilCardText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.fregihtText.frame), CGRectGetMaxY(self.dataLabel.frame), CGRectGetWidth(self.bounds)/3, 40)];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
            label.text = @"油卡:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = COLOR_RGB(244, 148, 138, 1);
            text.enabled = NO;
            text.adjustsFontSizeToFitWidth = YES;
            text;
        });
    }
    return _oilCardText;
}
- (UITextField *)transferText {
    if (!_transferText) {
        _transferText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oilCardText.frame), CGRectGetMaxY(self.dataLabel.frame), CGRectGetWidth(self.bounds)/3, 40)];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
            label.text = @"转账:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = COLOR_RGB(244, 148, 138, 1);
            text.enabled = NO;
            text.adjustsFontSizeToFitWidth = YES;
            text;
        });
    }
    return _transferText;
}
- (UITextField *)stateText {
    if (!_stateText) {
        _stateText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.fregihtText.frame), CGRectGetWidth(self.bounds), 40)];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
            label.text = @"运费状态:";
            [view addSubview:label];
            text.leftView = view;
            text.textColor = COLOR_RGB(59, 165, 251, 1);
            text.enabled = NO;
            text.adjustsFontSizeToFitWidth = YES;
            text;
        });
    }
    return _stateText;
}
@end
