//
//  RYPayWaybillTableViewCell.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/20.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYPayWaybillModel.h"

@protocol PayWaybillDelegate <NSObject>

- (void) payBillWithMoney:(NSInteger) moeny;
- (void) trackingBill;

@end


@interface RYPayWaybillTableViewCell : UITableViewCell

@property (nonatomic, assign) id<PayWaybillDelegate> delegate;
@property (nonatomic, strong) RYPayWaybillModel *model;

@end
