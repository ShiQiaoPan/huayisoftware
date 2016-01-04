//
//  WPAnyPickView.h
//  LikeAlertView
//
//  Created by rimi on 15/9/7.
//  Copyright © 2015年 魏攀. All rights reserved.
//

#import "WPPopView.h"

@interface WPSendSelectionView : WPPopView
+ (WPSendSelectionView *)showSendSelecionViewWithSize:(CGSize) size Complete:(void (^)(NSInteger))complete;
@end
