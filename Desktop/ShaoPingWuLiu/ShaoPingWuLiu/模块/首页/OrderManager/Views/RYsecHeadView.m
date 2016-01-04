//
//  RYsecHeadView.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYsecHeadView.h"

@interface RYsecHeadView()

@property (weak, nonatomic) IBOutlet UILabel  *orderIDLabel;       /**< 订单号   */
@property (weak, nonatomic) IBOutlet UILabel  *orderDateLabel;     /**< 订单日期 */
@property (weak, nonatomic) IBOutlet UILabel  *senderNameLabel;    /**< 发货人   */
@property (weak, nonatomic) IBOutlet UILabel  *senderTelLabel;     /**< 发货人电话*/
@property (weak, nonatomic) IBOutlet UILabel  *addresseeNameLabel; /**< 收货人   */
@property (weak, nonatomic) IBOutlet UILabel  *addresseeTelLabel;  /**< 收货人电话*/
@property (weak, nonatomic) IBOutlet UILabel  *freightLabel;       /**< 运费     */
@property (weak, nonatomic) IBOutlet UILabel  *paidMoneyLabel;     /**< 代收款   */
@property (weak, nonatomic) IBOutlet UILabel  *orderStatusLabel;   /**< 订单状态  */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;      /**< 评论按钮  */

@property (nonatomic, strong) RYFinishedOrderModel *model;

@end

@implementation RYsecHeadView

- (instancetype) secHeadView {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RYsecHeadView" owner:self options:nil];
    return [array lastObject];
}

- (instancetype) initSecHeadViewWithOrderModel:(RYFinishedOrderModel *)model {
    RYsecHeadView *secHV          = [self secHeadView];
    secHV.model                   = model;
    secHV.orderIDLabel.text       = [NSString stringWithFormat:@"订单号：%@", model.orderid];
    secHV.orderDateLabel.text     = [NSString stringWithFormat:@"日期：%@", model.time];
    secHV.senderNameLabel.text    = [NSString stringWithFormat:@"发货方：%@", model.iname];
    secHV.senderTelLabel.text     = model.iphone;
    secHV.addresseeNameLabel.text = [NSString stringWithFormat:@"收货方：%@", model.dname];
    secHV.addresseeTelLabel.text  = model.dphone;
    secHV.freightLabel.text       = [NSString stringWithFormat:@"%.2f", [model.carriage floatValue]];
    secHV.paidMoneyLabel.text     = [NSString stringWithFormat:@"%.2f", [model.proxycarriage floatValue]];
    secHV.orderStatusLabel.text     = [NSString stringWithFormat:@"%@", model.state];
    [secHV.flexibleButton addTarget:self action:@selector(respondsToFleBut:) forControlEvents:UIControlEventTouchUpInside];
    [secHV.commentButton addTarget:self action:@selector(respondsToComBut:) forControlEvents:UIControlEventTouchUpInside];
    secHV.flexibleButton.selected = NO;
    return secHV;
}

- (NSInteger)size {
    return self.flexibleButton.selected ? self.waybills.count : 0;
}

- (void) respondsToFleBut:(UIButton *) sender {
//    NSLog(@"index:%lu, size:%lu", self.sectionIndex, self.size);
    if ([self.delegate respondsToSelector:@selector(orderSectionFlexibleButClickedWithIndex:)]) {
        [self.delegate orderSectionFlexibleButClickedWithIndex:self.sectionIndex];
    }
}

- (void) respondsToComBut:(UIButton *) sender {
    if ([self.delegate respondsToSelector:@selector(orderSectionCommentButClickedWithModel:)]) {
        [self.delegate orderSectionCommentButClickedWithModel:self.model];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
