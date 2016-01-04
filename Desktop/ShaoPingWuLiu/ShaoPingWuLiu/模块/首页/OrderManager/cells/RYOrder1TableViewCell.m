//
//  RYOrder1TableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/16.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYOrder1TableViewCell.h"


@interface RYOrder1TableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigniorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigniorTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *agencyFundLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;


@end

@implementation RYOrder1TableViewCell


- (void) setModel:(RYUnfinishedOrderModel *)model {
    _model = model;
    self.orderIdLabel.text        = [NSString stringWithFormat:@"订单号：%@", _model.orderid];;
    self.orderDateLabel.text      = [NSString stringWithFormat:@"日期：%@", model.time];
    self.consigniorNameLabel.text = [NSString stringWithFormat:@"发货方：%@", model.iname];
    self.consigniorTelLabel.text  = _model.iphone;
    self.consigneeNameLabel.text  = [NSString stringWithFormat:@"收货方：%@", model.dname];
    self.consigneeTelLabel.text   = _model.dphone;
    self.statusLabel.text         = [NSString stringWithFormat:@"%@", _model.state];
    self.freightLabel.text        = [NSString stringWithFormat:@"%.2f", [_model.carriage floatValue]];
    self.agencyFundLabel.text     = [NSString stringWithFormat:@"%.2f", [_model.proxycarriage floatValue]];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)cancelOrderButClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cancelBillButtonClickedWithModel:)]) {
        [self.delegate cancelBillButtonClickedWithModel:self.model];
    }
}



@end
