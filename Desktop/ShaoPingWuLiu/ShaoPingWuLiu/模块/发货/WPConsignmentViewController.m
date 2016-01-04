//
//  ConsignmentViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/5.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPConsignmentViewController.h"

@interface WPConsignmentViewController ()
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPConsignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.baseNavigationBar removeFromSuperview];
    [self addMask];
}
#pragma mark - private methods
- (void)addMask {
    CAGradientLayer * grafientLayer = [CAGradientLayer layer];
    grafientLayer.frame = DHFlexibleFrame(CGRectMake(0, ORIGIN_HEIGHT - 60, 320, 60), NO);
    grafientLayer.startPoint = CGPointMake(0, 0);
    grafientLayer.endPoint = CGPointMake(0, 1);
    grafientLayer.backgroundColor = [UIColor whiteColor].CGColor
    ;
    [self.view.layer addSublayer:grafientLayer];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 60), NO);
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path moveToPoint:DHFlexibleCenter(CGPointMake(0, 10))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(140, 10))];/**<r = 29 */
    [path addArcWithCenter:DHFlexibleCenter(CGPointMake(160, 29)) radius:28
     *DHFlexibleVerticalMutiplier() startAngle:M_PI*1.3 endAngle:M_PI*1.75 clockwise:YES];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, 10))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, 60))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(0, 60))];
    
    maskLayer.path = path.CGPath;
    grafientLayer.mask = maskLayer;
    [grafientLayer addSublayer:maskLayer];
    
}
@end
