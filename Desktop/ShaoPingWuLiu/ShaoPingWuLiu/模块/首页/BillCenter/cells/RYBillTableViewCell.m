//
//  RYBillTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/20.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYBillTableViewCell.h"

@interface RYBillTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consignTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *agencyFundLabel;

@end


@implementation RYBillTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBModel:(RYReceivingCargoModel *)bModel {
    _bModel = bModel;
    self.orderNumberLabel.text   = [NSString stringWithFormat:@"订单号：%@", _bModel.orderid];
    self.orderDateLabel.text     = [NSString stringWithFormat:@"日期：%@", _bModel.time];
    self.consigneeNameLabel.text = [NSString stringWithFormat:@"收货方：%@", _bModel.dname];
    self.consignTelLabel.text    = [NSString stringWithFormat:@"%@", _bModel.dphone];
    self.freightLabel.text       = [NSString stringWithFormat:@"%@", _bModel.carriage];
    self.agencyFundLabel.text    = [NSString stringWithFormat:@"%@", _bModel.proxycarriage];
}

- (IBAction)trackingButClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(billTrackingButtonClicked)]) {
        [self.delegate billTrackingButtonClicked];
    }
}

- (void)setCModel:(RYSendingCargoModel *)cModel {
    _cModel = cModel;
    self.orderNumberLabel.text   = [NSString stringWithFormat:@"运单号：%@", _cModel.Consigner];
    self.orderDateLabel.text     = [[cModel.YDate mutableCopy] substringToIndex:10];
    self.consigneeNameLabel.text = [NSString stringWithFormat:@"发货方：%@", _cModel.Consigner];
    self.consignTelLabel.text    = [NSString stringWithFormat:@"%@", _cModel.FHPhone];
    self.freightLabel.text       = [NSString stringWithFormat:@"%@", _cModel.TotalAmount];
    self.agencyFundLabel.text    = [NSString stringWithFormat:@"%@", _cModel.DSMoney];
}

@end
