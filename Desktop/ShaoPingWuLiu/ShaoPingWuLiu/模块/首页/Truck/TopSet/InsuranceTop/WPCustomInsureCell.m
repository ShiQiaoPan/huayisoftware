//
//  WPCustomInsureCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPCustomInsureCell.h"

@interface WPCustomInsureCell ()
@property (nonatomic, strong) UIBezierPath * path;
- (void)initializeAppearance;

@end

@implementation WPCustomInsureCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.insureTitleLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.insureTitleLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.insureBuyTimeLabel];
    [self addSubview:self.insureCountText];
    [self addLineWithYPosition:CGRectGetMaxY(self.insureCountText.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.insureDetailLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.insureDetailLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.insureStartTimeLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.insureStartTimeLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.insureEndTimeLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.insureEndTimeLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.nextInsureTimeText];
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
- (UILabel *)insureTitleLabel {
    if (!_insureTitleLabel) {
        _insureTitleLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0 ,310, 40) adjustWidth:NO];
            lab;
        });
    }
    return _insureTitleLabel;
}
- (UILabel *)insureBuyTimeLabel {
    if (!_insureBuyTimeLabel) {
        _insureBuyTimeLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.insureTitleLabel.frame)/DHFlexibleVerticalMutiplier(), 150, 40) adjustWidth:NO];
            lab.textColor = GARYTextColor;
            lab.adjustsFontSizeToFitWidth = YES;
            lab;
        });
    }
    return _insureBuyTimeLabel;
}
- (UITextField *)insureCountText {
    if (!_insureCountText) {
        _insureCountText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.insureBuyTimeLabel.frame)/DHFlexibleHorizontalMutiplier(), CGRectGetMaxY(self.insureTitleLabel.frame)/DHFlexibleVerticalMutiplier(), 155, 40) adjustWidth:NO];
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
    return _insureCountText;
}
- (UILabel *)insureDetailLabel {
    if (!_insureDetailLabel) {
        _insureDetailLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.insureBuyTimeLabel.frame)/DHFlexibleVerticalMutiplier(), 310, 40) adjustWidth:NO];
            lab.textColor = GARYTextColor;
            lab;
        });
    }
    return _insureDetailLabel;
}
- (UILabel *)insureStartTimeLabel {
    if (!_insureStartTimeLabel) {
        _insureStartTimeLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.insureDetailLabel.frame)/DHFlexibleVerticalMutiplier(), 310, 40) adjustWidth:NO];
            label.textColor = GARYTextColor;
            label;
        });
    }
    return _insureStartTimeLabel;
}
- (UILabel *)insureEndTimeLabel {
    if (!_insureEndTimeLabel) {
        _insureEndTimeLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.insureStartTimeLabel.frame)/DHFlexibleVerticalMutiplier(), 310, 40) adjustWidth:NO];
            lab.textColor = GARYTextColor;
            lab;
        });
    }
    return _insureEndTimeLabel;
}
- (UITextField *)nextInsureTimeText {
    if (!_nextInsureTimeText) {
        _nextInsureTimeText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.insureEndTimeLabel.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 40) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 40)adjustWidth:NO];
            lab.text = @"下次保险提醒时间：";
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
    return _nextInsureTimeText;
}
- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}
@end
