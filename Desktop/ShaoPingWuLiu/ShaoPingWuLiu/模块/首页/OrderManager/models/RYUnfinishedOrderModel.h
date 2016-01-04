//
//  RYOrderModel.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/8.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYBasicModel.h"

@interface RYUnfinishedOrderModel : RYBasicModel

ProStr(time);           /**< 时间    */
ProStr(dname);          /**< 姓名（收 */
ProStr(iname);          /**< 姓名（发 */
ProStr(orderid);        /**< 订单     */
ProStr(dphone);         /**< 电话（收 */
ProStr(iphone);         /**< 电话（发 */
ProStr(carriage);       /**< 运费    */
ProStr(proxycarriage);  /**< 代收费   */
ProStr(state);          /**< 订单状态 */

@end
