//
//  RYPayWaybillTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/20.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYPayWaybillTableViewCell.h"

@interface RYPayWaybillTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigniorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigniorTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *cargoInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *agencyFundLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *freightButton;
@property (weak, nonatomic) IBOutlet UIButton *agencyFundButton;

@end


@implementation RYPayWaybillTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(RYPayWaybillModel *)model {
    _model = model;
    self.freightButton.selected = NO;
    self.freightButton.selected = NO;
}

- (IBAction)freightButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sender.selected ? [self.totalPriceLabel.text floatValue] + [self.freightLabel.text floatValue] : [self.totalPriceLabel.text floatValue] - [self.freightLabel.text floatValue]];
}
- (IBAction)agencyFundButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sender.selected ? [self.totalPriceLabel.text floatValue] + [self.agencyFundLabel.text floatValue] : [self.totalPriceLabel.text floatValue] - [self.agencyFundLabel.text floatValue]];
}
- (IBAction)payOrderButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(payBillWithMoney:)]) {
        [self.delegate payBillWithMoney:[self.totalPriceLabel.text integerValue]];
    }
}
- (IBAction)orderTrackingButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(trackingBill)]) {
        [self.delegate trackingBill];
    }
}


@end
