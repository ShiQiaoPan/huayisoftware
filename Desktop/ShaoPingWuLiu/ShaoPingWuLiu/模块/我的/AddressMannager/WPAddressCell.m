//
//  WPAddressCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/20.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddressCell.h"
#import "WPAddMangerViewModel.h"

@interface WPAddressCell ()
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView * pinImageView;
- (void)initializeAppearance;

@end
@implementation WPAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.pinImageView];
    [self addSubview:self.addTitleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.selectBtn];
    [self addSubview:self.deleteBtn];
    [self addDottedLine];
}

#pragma mark - private menthods
- (void)addDottedLine {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPointMake(0, 0))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bgView.bounds), 0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bgView.bounds), CGRectGetHeight(self.bgView.bounds))];
    [path addLineToPoint:CGPointMake(0, CGRectGetMaxY(self.bgView.bounds))];
    [path addLineToPoint:CGPointMake(0, 0)];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.bgView.bounds;
    layer.fillColor = [UIColor clearColor].CGColor;
    [layer setLineWidth:2];
    [layer setLineJoin:kCALineJoinRound];
    layer.path = path.CGPath;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = REDBGCOLOR.CGColor;/**< 画笔颜色 */
    [layer setLineDashPattern:[NSArray arrayWithObjects:@(10), @(5), nil]];
    [self.bgView.layer addSublayer:layer];
}


#pragma mark - getter
- (UIImageView *)pinImageView {
    if (!_pinImageView) {
        _pinImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 24, 30)];
            view.image = IMAGE_CONTENT(@"order_marker.png");
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _pinImageView;
}
- (UILabel *)addTitleLabel {
    if (!_addTitleLabel) {
        _addTitleLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pinImageView.frame)+10, 30, CGRectGetMaxX(self.frame)*DHFlexibleVerticalMutiplier()-CGRectGetMaxX(self.pinImageView.frame)*DHFlexibleVerticalMutiplier()-20, 30)];
            lab.backgroundColor = [UIColor whiteColor];
            lab;
        });
    }
    return _addTitleLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pinImageView.frame)+10, CGRectGetMaxY(self.addTitleLabel.frame), CGRectGetMaxX(self.frame)*DHFlexibleVerticalMutiplier()-CGRectGetMaxX(self.pinImageView.frame)*DHFlexibleVerticalMutiplier()-20, 30)];
            lab.numberOfLines = 0;
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textColor = GARYTextColor;
            lab.backgroundColor = [UIColor whiteColor];
            lab;
        });
    }
    return _nameLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pinImageView.frame)+10, CGRectGetMaxY(self.nameLabel.frame), CGRectGetMaxX(self.frame)*DHFlexibleVerticalMutiplier()-CGRectGetMaxX(self.pinImageView.frame)*DHFlexibleVerticalMutiplier()-20, 60)];
            lab.adjustsFontSizeToFitWidth = YES;
            lab.numberOfLines = 0;
            lab.textColor = GARYTextColor;
            lab.backgroundColor = [UIColor whiteColor];
            lab;
        });
    }
    return _addressLabel;
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = ({
            UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            setBtn.frame = CGRectMake(CGRectGetMaxX(self.frame)*DHFlexibleHorizontalMutiplier()- 50, 30, 30, 30);
            [setBtn setImage:IMAGE_CONTENT(@"checked_1.png") forState:UIControlStateNormal];
            [setBtn setImage:IMAGE_CONTENT(@"checked.png") forState:UIControlStateSelected];
            setBtn;
        });
    }
    return _selectBtn;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)*DHFlexibleHorizontalMutiplier() - 60, CGRectGetMinY(self.addressLabel.frame)+40, 40, 30)];
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn;
        });
    }
    return _deleteBtn;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 300 * DHFlexibleHorizontalMutiplier(), 150)];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _bgView;
}
@end
