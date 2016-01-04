//
//  WPMoreWallletViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/19.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMoreWallletViewController.h"

@interface WPMoreWallletViewController ()
@property (nonatomic, strong) UIImageView * walletImage;
@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UILabel * introLabel;
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPMoreWallletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"我的钱包";
    [self.rightButton removeFromSuperview];
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    backLabel.adjustsFontSizeToFitWidth = YES;
    [self.baseNavigationBar addSubview:backLabel];
    [self.view addSubview:self.walletImage];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.introLabel];
    [self addLine];
}
#pragma mark - private methods 
- (void)addLine {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:DHFlexibleCenter(CGPointMake(0, CGRectGetMaxY(self.introLabel.frame)/DHFlexibleVerticalMutiplier()- CGRectGetHeight(self.introLabel.frame)/DHFlexibleVerticalMutiplier()/2))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(80, CGRectGetMaxY(self.introLabel.frame)/DHFlexibleVerticalMutiplier()- CGRectGetHeight(self.introLabel.frame)/DHFlexibleVerticalMutiplier()/2))];
    [path moveToPoint:DHFlexibleCenter(CGPointMake(240, CGRectGetMaxY(self.introLabel.frame)/DHFlexibleVerticalMutiplier()- CGRectGetHeight(self.introLabel.frame)/DHFlexibleVerticalMutiplier()/2))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, CGRectGetMaxY(self.introLabel.frame)/DHFlexibleVerticalMutiplier()- CGRectGetHeight(self.introLabel.frame)/DHFlexibleVerticalMutiplier()/2))];
    path.lineWidth = 1;
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.view.frame;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = GARYTextColor.CGColor;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}
#pragma mark - getter
- (UIImageView *)walletImage {
    if (!_walletImage) {
        _walletImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(135, 90, 50, 64) adjustWidth:YES];
            view.image = IMAGE_CONTENT(@"Wallet3.png");
            view;
        });
    }
    return _walletImage;
}
- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.walletImage.frame)/DHFlexibleVerticalMutiplier(), 320, 50) adjustWidth:NO];
            lab.textColor = COLOR_RGB(239, 86, 59, 1);
            lab.font = [UIFont systemFontOfSize:40];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = [NSString stringWithFormat:@"%.2f", self.balance];
            lab;
        });
    }
    return _balanceLabel;
}
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.balanceLabel.frame) + 20 , 320, 80) adjustWidth:NO];
            lab.numberOfLines = 0;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = @"您还有余额可供使用\n也可用于提现";
            lab.textColor = GARYTextColor;
            lab;
        });
    }
    return _introLabel;
}
@end
