//
//  WPPopView.h
//  LikeAlertView
//
//  Created by rimi on 15/8/21.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPopView : UIView

- (instancetype)initWithSize:(CGSize) size; /**< 弹框的size */
- (void) show; /**< 弹出 */
- (void) hide; /**< 隐藏 */

@end
