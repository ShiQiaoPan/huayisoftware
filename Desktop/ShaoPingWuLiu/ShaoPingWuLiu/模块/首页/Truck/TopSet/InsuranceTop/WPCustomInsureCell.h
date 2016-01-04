//
//  WPCustomInsureCell.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCustomInsureCell : UITableViewCell
@property (nonatomic, strong) UILabel * insureTitleLabel;
@property (nonatomic, strong) UILabel * insureBuyTimeLabel;
@property (nonatomic, strong) UITextField * insureCountText;
@property (nonatomic, strong) UILabel * insureDetailLabel;
@property (nonatomic, strong) UILabel * insureStartTimeLabel;
@property (nonatomic, strong) UILabel * insureEndTimeLabel;
@property (nonatomic, strong) UITextField * nextInsureTimeText;
@end
