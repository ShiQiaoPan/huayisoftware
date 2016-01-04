//
//  RYPayOrderTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/20.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYPayOrderTableViewCell.h"

@interface RYPayOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *agencyFundLabel;


@end

@implementation RYPayOrderTableViewCell

- (void)setModel:(RYPayBillWaybillModel *)model {
    _model = model;
    self.orderIdLabel.text       = [NSString stringWithFormat:@"运单号：%@", _model.YBillNo];
    self.orderDateLabel.text     = [NSString stringWithFormat:@"日期：%@", [[_model.YDate mutableCopy] substringToIndex:10]];
    self.consigneeNameLabel.text = [NSString stringWithFormat:@"收货方：%@", _model.Consignee];
    self.consigneeCityLabel.text = [NSString stringWithFormat:@"城市：%@", _model.City];
    self.freightLabel.text       = [NSString stringWithFormat:@"%.2f", [_model.TotalAmount floatValue]];
    self.agencyFundLabel.text    = [NSString stringWithFormat:@"%.2f", [_model.DSMoney floatValue]];
}


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
