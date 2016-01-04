//
//  RYsecHeadView.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYFinishedOrderModel.h"

@protocol  OrderSectionDelegate<NSObject>

- (void) orderSectionFlexibleButClickedWithIndex:(NSInteger) index;
- (void) orderSectionCommentButClickedWithModel:(RYFinishedOrderModel *) model;

@end

@interface RYsecHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *flexibleButton;     /**< 展开按钮  */
@property (nonatomic, assign)   NSInteger      sectionIndex;       /**< sec索引  */
@property (nonatomic, assign) id<OrderSectionDelegate> delegate;   /**< 代理     */
@property (nonatomic, readonly)   NSInteger      size;             /**< 显示运单数 */
@property (nonatomic, strong)   NSArray       *waybills;           /**<  运单    */

- (instancetype) initSecHeadViewWithOrderModel:(RYFinishedOrderModel *) model;

@end
