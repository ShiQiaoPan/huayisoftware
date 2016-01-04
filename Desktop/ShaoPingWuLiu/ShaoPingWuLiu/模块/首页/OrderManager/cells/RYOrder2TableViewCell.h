//
//  RYOrder2TableViewCell.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/16.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYFinishedWaybillModel.h"

@protocol WayBillTrackingDelegate <NSObject>

- (void) respondsToWaybillTrackingButtonWithModel:(RYFinishedWaybillModel *) model;

@end

@interface RYOrder2TableViewCell : UITableViewCell

@property (nonatomic, assign) id<WayBillTrackingDelegate> delegate;
@property (nonatomic, strong) RYFinishedWaybillModel *model;

@end
