//
//  WPAnyPickView.h
//  LikeAlertView
//
//  Created by rimi on 15/9/7.
//  Copyright © 2015年 魏攀. All rights reserved.
//

#import "WPPopView.h"

@interface WPBankPickView : WPPopView
+ (WPBankPickView *)showViewWithDataSources:(NSArray *)dataSource complete:(void(^)(NSMutableDictionary * date))complete;
@end
