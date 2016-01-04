//
//  RYAreaSelectionPickerView.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/12/15.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPPopView.h"

@interface RYAreaSelectionPickerView : WPPopView
+ (RYAreaSelectionPickerView *)showViewWithcomplete:(void(^)(NSString *result))complete;

@end
