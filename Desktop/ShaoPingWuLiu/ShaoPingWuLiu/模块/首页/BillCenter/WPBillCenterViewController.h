//
//  WPBillCenterViewController.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBasicViewController.h"

@interface WPBillCenterViewController : WPBasicViewController

@property (nonatomic, copy) NSString *beginDateString; /**< 开始日期  */
@property (nonatomic, copy) NSString *endDateString;   /**< 结束日期  */
@property (nonatomic, copy) NSString *consigneeTele;   /**< 收货人电话 */

@end
