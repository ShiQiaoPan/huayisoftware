//
//  RYPayBillFootView.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYPayBillModel.h"

@protocol RYBillPayingDelegate <NSObject>

- (void) payBillWithOrderModel:(RYPayBillModel *) model;

@end

@interface RYPayBillFootView : UIView

@property (nonatomic, assign) id<RYBillPayingDelegate> delegate; /**< 代理     */
@property (nonatomic, assign)   NSInteger      sectionIndex;     /**< sec索引  */

- (instancetype) initSecFootViewWithOrderModel:(RYPayBillModel *)model;

@end
