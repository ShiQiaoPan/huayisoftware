//
//  WPDatePickView.h
//  LikeAlertView
//
//  Created by rimi on 15/9/7.
//  Copyright © 2015年 魏攀. All rights reserved.
//

#import "WPPopView.h"

@interface WPDatePickView : WPPopView
@property (nonatomic, strong) UIDatePicker *datePicker /**< 时间选择器 */;
+ (WPDatePickView *)showViewWithTitle:(NSString *)title datePickerMode: (UIDatePickerMode) datePickerMode maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate complete:(void(^)(NSDate *date))complete;
@end
