//
//  WPUseDiscountCell.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/1.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPUseDiscountCell : UITableViewCell
@property (nonatomic, assign)NSInteger cellIndex;
@property (nonatomic, strong)UIImageView * discountImage;
@property (nonatomic, strong)UILabel * discountLabel;
@property (nonatomic, strong)UIButton * discountuseBtn;
@property (nonatomic, strong)UIViewController * pushViewController;
@end
