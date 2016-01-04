//
//  NetWorkingManager+BillCenter.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/3.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "NetWorkingManager.h"

@interface NetWorkingManager (BillCenter)

+ (AFHTTPRequestOperation *) getBillsWithBeginDate:(NSString *) begin
                                           EndDate:(NSString *) end
                                      ConsigneeTel:(NSString *) conTel
                                          isReceiver:(BOOL) isReceiver
                                    SuccessHandler:(SuccessBlock) successOption
                                    FailureHandler:(FailureBlock) failuerOption;
@end
