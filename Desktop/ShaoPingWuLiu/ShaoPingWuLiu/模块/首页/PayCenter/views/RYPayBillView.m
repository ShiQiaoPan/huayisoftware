//
//  RYPayBillView.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/21.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYPayBillView.h"

@interface RYPayBillView ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consignorName;
@property (weak, nonatomic) IBOutlet UILabel *consignorTel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeName;
@property (weak, nonatomic) IBOutlet UILabel *consigneeTel;

@property (nonatomic, strong) RYPayBillModel *model;


@end

@implementation RYPayBillView

- (instancetype) secHView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RYPayBillView" owner:self options:nil];
    return [arr lastObject];
}

- (instancetype) initSecHeadViewWithOrderModel:(RYPayBillModel *)model {
    RYPayBillView *secHV      = [self secHView];
    secHV.model               = model;
        secHV.orderIdLabel.text   = [NSString stringWithFormat:@"订单号：%@", model.orderid];
    secHV.orderDateLabel.text = [NSString stringWithFormat:@"日期：%@", model.time];
        secHV.consignorName.text  = [NSString stringWithFormat:@"发货方：%@", model.iname];
        secHV.consignorTel.text   = model.iphone;
        secHV.consigneeName.text  = [NSString stringWithFormat:@"收货方：%@", model.dname];
        secHV.consigneeTel.text   = model.dphone;
    [secHV.flexibleButton addTarget:self action:@selector(respondsToFleBut:) forControlEvents:UIControlEventTouchUpInside];
    secHV.flexibleButton.selected = NO;
    return secHV;
}

- (NSInteger)size {
    return self.flexibleButton.selected ? self.waybills.count : 0;
}

- (void) respondsToFleBut:(UIButton *) sender {
    if ([self.delegate respondsToSelector:@selector(flexibleWayBillWithBillIndex:)]) {
        [self.delegate flexibleWayBillWithBillIndex:self.sectionIndex];
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
