//
//  UIView+AdaptFrame.m
//  Deepbreathing
//
//  Created by DreamHack on 15-8-12.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "UIView+AdaptFrame.h"
#import "AdaptableScreen.h"
@implementation UIView (AdaptFrame)

- (instancetype)initWithFrame:(CGRect)frame adjustWidth:(BOOL)flag
{
    self = [self initWithFrame:DHFlexibleFrame(frame, flag)];
    return self;
}

@end
