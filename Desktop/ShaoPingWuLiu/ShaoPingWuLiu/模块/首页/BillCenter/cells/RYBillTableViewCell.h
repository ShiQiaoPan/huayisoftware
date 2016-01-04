//
//  RYBillTableViewCell.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/20.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYReceivingCargoModel.h"
#import "RYSendingCargoModel.h"
@protocol BillTrackingDelegate <NSObject>

- (void) billTrackingButtonClicked;

@end


@interface RYBillTableViewCell : UITableViewCell

@property (nonatomic, strong) RYReceivingCargoModel *bModel;

@property (nonatomic, strong) RYSendingCargoModel *cModel;

@property (nonatomic, assign) id<BillTrackingDelegate> delegate;

@end

