//
//  DottedLine.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/18.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "DottedLineLabel.h"

@implementation DottedLineLabel
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    CAShapeLayer * layer = [CAShapeLayer layer];
    
    layer.frame = rect;
    layer.fillColor = [UIColor clearColor].CGColor;
    [layer setLineWidth:1];
    [layer setLineJoin:kCALineJoinRound];
    [layer setLineDashPattern:[NSArray arrayWithObjects:@(5), @(6), nil]];
    layer.path = path.CGPath;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = REDBGCOLOR.CGColor;          /**< 画笔颜色 */
    [self.layer addSublayer:layer];
}

@end
