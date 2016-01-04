//
//  RYOrder1TableViewCell.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/16.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYUnfinishedOrderModel.h"

@protocol CancelBillDelegate <NSObject>

- (void) cancelBillButtonClickedWithModel:(RYUnfinishedOrderModel *) model;

@end

@interface RYOrder1TableViewCell : UITableViewCell

@property (nonatomic, strong) RYUnfinishedOrderModel *model;
@property (nonatomic, assign) id<CancelBillDelegate> delegate;

@end
