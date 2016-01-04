//
//  WPCustomMaintenanceCell.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCustomMaintenanceCell : UITableViewCell
@property (nonatomic, strong) UILabel * maintencenanceTitleLabel;
@property (nonatomic, strong) UILabel * maintencenanceTimeLabel;
@property (nonatomic, strong) UITextField * maintencenanceText;
@property (nonatomic, strong) UILabel * maintencenanceDetailLabel;
@property (nonatomic, strong) UITextField * nextMaintenanceTimeText;
@end
