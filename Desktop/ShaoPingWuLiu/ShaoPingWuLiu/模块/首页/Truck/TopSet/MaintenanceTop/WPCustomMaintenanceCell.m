//
//  WPCustomMaintenanceCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPCustomMaintenanceCell.h"

@interface WPCustomMaintenanceCell ()
@property (nonatomic, strong) UIBezierPath * path;
- (void)initializeAppearance;
@end
@implementation WPCustomMaintenanceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.maintencenanceTitleLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.maintencenanceTitleLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.maintencenanceTimeLabel];
    [self addSubview:self.maintencenanceText];
    [self addLineWithYPosition:CGRectGetMaxY(self.maintencenanceTimeLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.maintencenanceDetailLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.maintencenanceDetailLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.nextMaintenanceTimeText];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 800), NO);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = GARYTextColor.CGColor;/**< 画笔颜色 */
    layer.path = self.path.CGPath;
    [self.layer addSublayer:layer];
}
#pragma mark - private methods

- (void)addLineWithYPosition :(CGFloat)y {
    [self.path moveToPoint:DHFlexibleCenter(CGPointMake(0, y))];
    [self.path addLineToPoint:DHFlexibleCenter(CGPointMake(320, y))];
    self.path.lineWidth = 1;
}

#pragma mark - getter
- (UILabel *)maintencenanceTitleLabel {
    if (!_maintencenanceTitleLabel) {
        _maintencenanceTitleLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0 ,310, 40) adjustWidth:NO];
            lab;
        });
    }
    return _maintencenanceTitleLabel;
}
- (UILabel *)maintencenanceTimeLabel {
    if (!_maintencenanceTimeLabel) {
        _maintencenanceTimeLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.maintencenanceTitleLabel.frame)/DHFlexibleVerticalMutiplier(), 155, 40) adjustWidth:NO];
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textColor = GARYTextColor;
            lab;
        });
    }
    return _maintencenanceTimeLabel;
}
- (UITextField *)maintencenanceText {
    if (!_maintencenanceText) {
        _maintencenanceText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.maintencenanceTimeLabel.frame)/DHFlexibleHorizontalMutiplier(), CGRectGetMaxY(self.maintencenanceTitleLabel.frame)/DHFlexibleVerticalMutiplier(), 155, 40) adjustWidth:NO];
            UILabel * leftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 40) adjustWidth:NO];
            leftLab.textColor = GARYTextColor;
            leftLab.text = @"保险金额：";
            leftLab.adjustsFontSizeToFitWidth = YES;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = leftLab;
            text.textColor = COLOR_RGB(238, 95, 71, 1);
            text.enabled = NO;
            text;
        });
    }
    return _maintencenanceText;
}
- (UILabel *)maintencenanceDetailLabel {
    if (!_maintencenanceDetailLabel) {
        _maintencenanceDetailLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.maintencenanceTimeLabel.frame)/DHFlexibleVerticalMutiplier(), 310, 40) adjustWidth:NO];
            lab.textColor = GARYTextColor;
            lab;
        });
    }
    return _maintencenanceDetailLabel;
}
- (UITextField *)nextMaintenanceTimeText {
    if (!_nextMaintenanceTimeText) {
        _nextMaintenanceTimeText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.maintencenanceDetailLabel.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 40) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 40)adjustWidth:NO];
            lab.text = @"下次保养提醒时间：";
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textAlignment = NSTextAlignmentLeft;
            [leftView addSubview:lab];
            text.leftView = leftView;
            text.adjustsFontSizeToFitWidth = YES;
            text.userInteractionEnabled = NO;
            text.textColor = COLOR_RGB(0, 175, 224, 1);
            text;
            
        });
    }
    return _nextMaintenanceTimeText;
}
- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}
@end
