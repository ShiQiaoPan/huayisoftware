//
//  RYPayBillFootView.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYPayBillFootView.h"

@interface RYPayBillFootView ()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic, strong) RYPayBillModel *model;


@end

@implementation RYPayBillFootView

- (instancetype) secFootView {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RYPayBillFootView" owner:self options:nil];
    return [array lastObject];
}

- (instancetype) initSecFootViewWithOrderModel:(RYPayBillModel *)model {
    RYPayBillFootView *secV      = [self secFootView];
    secV.totalPriceLabel.text     = [NSString stringWithFormat:@"%.2f", [model.totalMoney floatValue]];
    secV.model                   = model;
    [secV.payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return secV;
}

- (void) payButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(payBillWithOrderModel:)]) {
        [self.delegate payBillWithOrderModel:self.model];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
