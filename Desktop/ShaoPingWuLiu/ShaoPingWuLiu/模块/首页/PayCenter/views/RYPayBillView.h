//
//  RYPayBillView.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/21.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYPayBillModel.h"

@protocol PayBillDelegate <NSObject>

- (void) flexibleWayBillWithBillIndex:(NSInteger) index;

@end

@interface RYPayBillView : UIView

@property (weak, nonatomic) IBOutlet UIButton *flexibleButton; /**< 伸缩按钮  */
@property (nonatomic, readonly) NSInteger      size;           /**< 显示运单  */
@property (nonatomic, assign) id<PayBillDelegate> delegate;    /**< 代理     */
@property (nonatomic, assign)   NSInteger      sectionIndex;   /**< sec索引  */
@property (nonatomic, strong)   NSArray       *waybills;       /**< 所有运单  */

- (instancetype) initSecHeadViewWithOrderModel:(RYPayBillModel *)model;

@end
