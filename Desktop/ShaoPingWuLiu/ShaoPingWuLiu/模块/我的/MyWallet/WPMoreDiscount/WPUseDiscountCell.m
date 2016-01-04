//
//  WPUseDiscountCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/1.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPUseDiscountCell.h"
@interface WPUseDiscountCell ()
- (void)initializeAppearance;

@end
@implementation WPUseDiscountCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    [self addSubview:self.discountImage];
    [self addSubview:self.discountuseBtn];
    [self addSubview:self.discountLabel];
}
#pragma mark - responds events
- (void)respondsToUseBtn:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"discountUse"]) {
        if (![[NSUserDefaults standardUserDefaults]integerForKey:@"index"]) {
            sender.selected = !sender.selected;
            sender.backgroundColor = sender.selected ? COLOR_RGB(250, 126, 51, 1):REDBGCOLOR;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"discountUse"];
            [[NSUserDefaults standardUserDefaults]setInteger:self.cellIndex forKey:@"index"];
            return;
        }
    } else {
        if (self.cellIndex != [[NSUserDefaults standardUserDefaults]integerForKey:@"index"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"优惠劵每次仅限使用一张哦" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self.pushViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            sender.selected = !sender.selected;
            sender.backgroundColor = sender.selected ? COLOR_RGB(250, 126, 51, 1):REDBGCOLOR;
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"discountUse"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"index"];
        }
    }
}
#pragma mark - private methods
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMinX(self.discountImage.frame), CGRectGetMaxY(self.discountImage.frame)+10*DHFlexibleVerticalMutiplier())];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(self.discountImage.frame)+10*DHFlexibleVerticalMutiplier())];
    path.lineWidth = 1;
    UIColor *color = GARYTextColor;
    [color setStroke];
    
    [path stroke];
    
}
#pragma mark - getter
- (UIImageView *)discountImage {
    if (!_discountImage) {
        _discountImage = ({
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85, 50) adjustWidth:YES];
            image;
        });
    }
    return _discountImage;
}
- (UIButton *)discountuseBtn {
    if (!_discountuseBtn) {
        _discountuseBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(200, CGRectGetMidY(self.bounds)/DHFlexibleVerticalMutiplier()-10, 100, 40), NO);
            [btn setBackgroundColor:REDBGCOLOR];
            [btn setTitle:@"使用" forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(respondsToUseBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _discountuseBtn;
}
- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = ({
            UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.bounds)/DHFlexibleVerticalMutiplier()-10, 320, 40) adjustWidth:NO];
            countLabel.textColor = COLOR_RGB(239, 86, 59, 1);
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel;
        });
    }
    return _discountLabel;
}
@end
