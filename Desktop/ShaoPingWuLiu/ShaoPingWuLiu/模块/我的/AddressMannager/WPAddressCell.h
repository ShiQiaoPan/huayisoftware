//
//  WPAddressCell.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/20.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAddressCell : UITableViewCell
@property (nonatomic, strong) UILabel * addTitleLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UIButton * selectBtn;

@end
