//
//  WPAnyPickView.m
//  LikeAlertView
//
//  Created by rimi on 15/9/7.
//  Copyright © 2015年 魏攀. All rights reserved.
//

#import "WPSendSelectionView.h"

@interface WPSendSelectionView ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * homeServiceLabel;
@property (nonatomic, strong) UIButton * homeServiceBtn;/**< 上门取货 */
@property (nonatomic, strong) UILabel * netSendLabel;
@property (nonatomic, strong) UIButton * netSendBtn;/**< 网点发货 */
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, copy) void (^complete)(NSInteger result);
@end
@implementation WPSendSelectionView

+ (WPSendSelectionView *)showSendSelecionViewWithSize:(CGSize) size Complete:(void (^)(NSInteger))complete {
    WPSendSelectionView * view = [[WPSendSelectionView alloc]initWithWithSize:size Complete:complete];
    [view show];
    return view;
}
- (instancetype)initWithWithSize:(CGSize) size Complete:(void(^)(NSInteger result))complete {
    self = [super initWithSize:size];
    if (self) {
        self.complete = complete;
        [self initalizeUserInterface];
    }
    return self;
}
- (void)initalizeUserInterface {
    [self addSubview:self.titleLabel];
    [self addSubview:self.homeServiceLabel];
    [self addSubview:self.homeServiceBtn];
    [self addSubview:self.netSendLabel];
    [self addSubview:self.netSendBtn];
    [self addSubview:self.cancelButton];
}
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPointMake(10, 90))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-20, 90)];
    path.lineWidth = 1;
    UIColor * color = COLOR_RGB(210, 211, 212, 1);
    [color setStroke];
    [path stroke];
}
#pragma mark - responds events
- (void)respondsToSelectionBtn:(UIButton *)sender {
    self.complete(sender.tag - 220);
    [self hide];
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds), 44)];
            label.text = @"请选择发货方式:";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:18];
            label;
        });
    }
    return _titleLabel;
}
- (UILabel *)homeServiceLabel {
    if (!_homeServiceLabel) {
        _homeServiceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, CGRectGetWidth(self.bounds) - 55, 30)];
            label.text = @"上门接货";
            label.textColor = [UIColor blackColor];
            label;
        });
    }
    return _homeServiceLabel;
}
- (UIButton *)homeServiceBtn {
    if (!_homeServiceBtn) {
        _homeServiceBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 60, 50, 30, 30);
            [btn setImage:IMAGE_CONTENT(@"checked_1.png") forState:UIControlStateNormal];
            [btn setImage:IMAGE_CONTENT(@"checked.png") forState:UIControlStateHighlighted];
            btn.tag = 220;
            [btn addTarget:self action:@selector(respondsToSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _homeServiceBtn;
}
- (UILabel *)netSendLabel {
    if (!_netSendLabel) {
        _netSendLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, CGRectGetWidth(self.bounds), 30)];
            label.text = @"网点发货";
            label.textColor = [UIColor blackColor];
            label;
        });
    }
    return _netSendLabel;
}
- (UIButton *)netSendBtn {
    if (!_netSendBtn) {
        _netSendBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 60, 100, 30, 30);
            [btn setImage:IMAGE_CONTENT(@"checked_1.png") forState:UIControlStateNormal];
            [btn setImage:IMAGE_CONTENT(@"checked.png") forState:UIControlStateHighlighted];
            btn.tag = 221;
            [btn addTarget:self action:@selector(respondsToSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _netSendBtn;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelbutton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 60, CGRectGetHeight(self.bounds) - 40, 50, 37);
            [cancelbutton setTitleColor:COLOR_RGB(110, 183, 234, 1) forState:UIControlStateNormal];
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelbutton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            cancelbutton;
        });
    }
    return _cancelButton;
}

@end
