//
//  RYSendDateSeclectView.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/18.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPPopView.h"

@interface RYSendDateSeclectView : WPPopView

+ (RYSendDateSeclectView *)showSendSelecionViewWithOperation:(void (^)(NSDictionary *))operation;

@end
