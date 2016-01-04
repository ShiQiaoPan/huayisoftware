//
//  RYPayBillWaybillModel.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/18.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYBasicModel.h"

@interface RYPayBillWaybillModel : RYBasicModel

ProStr(City);
ProStr(Consignee);
ProStr(Consigner);
ProStr(FHPhone);
ProStr(SHPhone);
ProStr(GoodsName);
ProStr(State);
ProStr(DSMoney);      /**< 代收款 */
ProStr(TotalAmount);  /**< 运费   */
ProStr(YBillNo);
ProStr(YDate);

@end
