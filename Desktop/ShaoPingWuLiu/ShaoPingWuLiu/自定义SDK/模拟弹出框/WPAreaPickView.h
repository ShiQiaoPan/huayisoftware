//
//  WPAreaPickView.h
//  picker
//
//  Created by WeiPan on 15/11/27.
//  Copyright © 2015年 Sylar. All rights reserved.
//

#import "WPPopView.h"

@interface WPAreaPickView : WPPopView
+ (WPAreaPickView *)showViewWithcomplete:(void(^)(NSMutableArray *result))complete;
@end
