//
//  RYSearchResultTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYSearchResultTableViewCell.h"

@interface RYSearchResultTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabelFir;
@property (weak, nonatomic) IBOutlet UIView *telFirBotView;
@property (weak, nonatomic) IBOutlet UILabel *telLabelSec;
@property (weak, nonatomic) IBOutlet UIView *telSecBotView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *thySegControl;

@end

@implementation RYSearchResultTableViewCell

- (IBAction)respondToSegControl:(UISegmentedControl *)sender {
    if ([self.delegate respondsToSelector:@selector(searchCellSegClickWithSegIndex:and:)]) {
        [self.delegate searchCellSegClickWithSegIndex:sender.selectedSegmentIndex and:self.model];
    }
}

- (void)setModel:(RYSearchResult *)model {
    _model              = model;
    if ([_model.result_tel rangeOfString:@";"].location == NSNotFound) {
        _telLabelFir.text = _model.result_tel;
        _telLabelSec.text = @"";
    }
    else {
        NSArray *array = [_model.result_tel componentsSeparatedByString:@";"];
        _telLabelFir.text = [array firstObject];
        _telLabelFir.text = [array lastObject];
    }
    UIButton *butFir = [UIButton buttonWithType:UIButtonTypeCustom];
    butFir.backgroundColor = [UIColor clearColor];
    butFir.frame = _telLabelFir.frame;
    [butFir addTarget:self action:@selector(callPhoneNumberFir) forControlEvents:UIControlEventTouchUpInside];
    UIButton *butSec = [UIButton buttonWithType:UIButtonTypeCustom];
    butSec.backgroundColor = [UIColor clearColor];
    butSec.frame = _telLabelSec.frame;
    [butSec addTarget:self action:@selector(callPhoneNumberSec) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:butFir];
    [self.contentView addSubview:butSec];
    _nameLabel.text     = _model.result_name;
    _addressLabel.text  = _model.result_address;
    _distanceLabel.text = _model.result_distance > 1000 ? [NSString stringWithFormat:@"%.2f公里", (double)_model.result_distance / 1000.0f] : [NSString stringWithFormat:@"%lu米", _model.result_distance];
    _thySegControl.selectedSegmentIndex = -1;
}

- (void) callPhoneNumberFir {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.telLabelFir.text]]];
}

- (void) callPhoneNumberSec {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.telLabelSec.text]]];
}

- (void)awakeFromNib {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
