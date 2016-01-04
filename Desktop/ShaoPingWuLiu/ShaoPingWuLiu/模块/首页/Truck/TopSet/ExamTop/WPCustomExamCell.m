//
//  WPCustomExamCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPCustomExamCell.h"


@interface WPCustomExamCell ()
@property (nonatomic, strong) UIBezierPath * path;
- (void)initializeAppearance;

@end
@implementation WPCustomExamCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    [self addSubview:self.examTitleLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.examTitleLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.examTimeLabel];
    [self addLineWithYPosition:CGRectGetMaxY(self.examTimeLabel.frame)/DHFlexibleVerticalMutiplier()];
    [self addSubview:self.nextExamTimeText];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 300), NO);
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
- (UILabel *)examTitleLabel {
    if (!_examTitleLabel) {
        _examTitleLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 40) adjustWidth:NO];
            lab;
        });
    }
    return _examTitleLabel;
}
- (UILabel *)examTimeLabel {
    if (!_examTimeLabel) {
        _examTimeLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.examTitleLabel.frame)/DHFlexibleVerticalMutiplier(), 310, 40) adjustWidth:NO];
            lab.textColor = GARYTextColor;
            lab;
        });
    }
    return _examTimeLabel;
}
- (UITextField *)nextExamTimeText {
    if (!_nextExamTimeText) {
        _nextExamTimeText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.examTimeLabel.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 40) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 40)adjustWidth:NO];
            lab.text = @"下次年审提醒时间：";
            lab.textAlignment = NSTextAlignmentLeft;
            lab.adjustsFontSizeToFitWidth = YES;
            [leftView addSubview:lab];
            text.leftView = leftView;
            text.adjustsFontSizeToFitWidth = YES;
            text.userInteractionEnabled = NO;
            text.textColor = COLOR_RGB(0, 175, 224, 1);
            text;
        });
    }
    return _nextExamTimeText;
}
- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}
@end
