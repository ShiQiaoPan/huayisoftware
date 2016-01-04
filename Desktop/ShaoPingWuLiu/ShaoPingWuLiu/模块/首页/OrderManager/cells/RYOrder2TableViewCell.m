//
//  RYOrder2TableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/16.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYOrder2TableViewCell.h"

@interface RYOrder2TableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *waybillIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *waybillDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeCityLabel;

@end

@implementation RYOrder2TableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RYFinishedWaybillModel *)model {
    _model = model;
//    self.waybillIdLabel.text   = [NSString stringWithFormat:@"运单号：%@", _model.YBillNo];
    self.waybillDateLabel.text = [NSString stringWithFormat:@"日期：%@", [[_model.YDate mutableCopy] substringToIndex:10]];
    self.consigneeNameLabel.text = [NSString stringWithFormat:@"收货方：%@", _model.Consignee];
    self.consigneeCityLabel.text = [NSString stringWithFormat:@"城市：%@", _model.City];
    
}

- (IBAction)trackingButClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(respondsToWaybillTrackingButtonWithModel:)]) {
        [self.delegate respondsToWaybillTrackingButtonWithModel:self.model];
    }
}


@end
