//
//  RYJudgeTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/23.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYJudgeTableViewCell.h"

@interface RYJudgeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderJudgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyJudgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastJudgeTimeLabel;


@end

@implementation RYJudgeTableViewCell

- (void)awakeFromNib {
    
}

- (void)setModel:(RYMyJudgeModel *)model {
    _model = model;
    self.detailOrderLabel.text = [NSString stringWithFormat:@"%@ %@件 %.1fkg", _model.articlename, [_model.number stringValue] , [model.weight floatValue]];
    self.orderIdLabel.text     = [NSString stringWithFormat:@"订单号：%@", _model.orderid];
    self.orderDateLabel.text   = [NSString stringWithFormat:@"日期：%@", [[_model.time mutableCopy] substringToIndex:10]];
    self.orderJudgeLabel.text  = _model.details;
    NSString *defaultStr = @"感谢您的好评，我们会继续努力，作最好的物流服务一定不会让你失望！";
    NSString *str = [NSString stringWithFormat:@"回复：%@", [_model.rdetails isEqualToString:@""] ? defaultStr : _model.rdetails];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(22, 98, 238, 1) range:NSMakeRange(0, 3)];
    
    self.replyJudgeLabel.attributedText = string;
    self.lastJudgeTimeLabel.text = _model.itime;
//    self.replyJudgeLabel.text  = _model.rdetails;
    self.lastJudgeTimeLabel.text = _model.rtime ? _model.rtime : _model.itime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
