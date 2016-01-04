//
//  RYSendingCargoModel.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYBasicModel.h"

@interface RYSendingCargoModel : RYBasicModel

//YBillNo：运单号
//YDate：日期
//Consignee: 收货人
//SHPhone: 收货电话
//Consigner: 发货人
//FHPhone: 发货电话
//TotalAmount: 运费
//DSMoney: 代收款

ProStr(YBillNo);     /**< 运单号   */
ProStr(YDate);       /**< 日期     */
ProStr(Consignee);   /**< 收货人   */
ProStr(SHPhone);     /**< 收货电话 */
ProStr(Consigner);   /**< 发货人   */
ProStr(FHPhone);     /**< 发货电话 */
ProStr(TotalAmount); /**< 运费    */
ProStr(DSMoney);     /**< 代收款   */

@end
