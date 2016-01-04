//
//  CustomTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell ()

- (void)initializeUserInterface; /**< 初始化用户界面 */


@end
@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeUserInterface];
    }
    return self;
}
#pragma mark - init
- (void)initializeUserInterface {
    [self addSubview:self.headImageView];
    [self addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightLabel];
}
#pragma mark - private methods
- (void)addSeparateLine {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:DHFlexibleCenter(CGPointMake(80, 50))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, 50))];
    path.lineWidth = 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, 320, 200);
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}
#pragma mark - getter
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40*DHFlexibleHorizontalMutiplier(), 40*DHFlexibleHorizontalMutiplier()) ];
            view;
        });
    }
    return _headImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(80*DHFlexibleHorizontalMutiplier(), 0, 100*DHFlexibleHorizontalMutiplier(), 44*DHFlexibleHorizontalMutiplier())];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
    }
    return _titleLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100*DHFlexibleHorizontalMutiplier(), 0, 180*DHFlexibleHorizontalMutiplier(), 44*DHFlexibleHorizontalMutiplier()) ];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
    }
    return _rightLabel;
}
@end
