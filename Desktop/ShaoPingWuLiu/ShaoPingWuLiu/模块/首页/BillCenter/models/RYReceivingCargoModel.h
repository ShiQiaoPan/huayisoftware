//
//  RYReceivingCargoModel.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYBasicModel.h"

@interface RYReceivingCargoModel : RYBasicModel

ProStr(dname);         /**< 名字（收 */
ProStr(dphone);        /**< 电话（收 */
ProStr(orderid);       /**< 订单号 */
ProStr(time);          /**< 日期   */
ProStr(carriage);      /**< 运费   */
ProStr(proxycarriage); /**< 代收费 */

@end
