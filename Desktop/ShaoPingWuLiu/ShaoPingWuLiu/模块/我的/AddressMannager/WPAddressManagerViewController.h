//
//  WPAddressManagerViewController.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/13.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBasicViewController.h"
@protocol RYPickGoodAddressDeLegate <NSObject>
- (void)refreshPostAddressWith:(NSString *)address;
- (void)refreshReciveAddressWith:(NSString *)address;
@end

@interface WPAddressManagerViewController : WPBasicViewController
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isPost;
@property (nonatomic, weak)id<RYPickGoodAddressDeLegate> delegate;

@end
