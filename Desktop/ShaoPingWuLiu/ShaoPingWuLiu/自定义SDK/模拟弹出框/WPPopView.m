//
//  WPPopView.m
//  LikeAlertView
//
//  Created by rimi on 15/8/21.
//  Copyright (c) 2015年 魏攀. All rights reserved.
//

#import "WPPopView.h"
#define SCREEN_W CGRectGetWidth([[UIScreen mainScreen]bounds])
#define SCREEN_H CGRectGetHeight([UIScreen mainScreen].bounds)
#define DURATION 1.0f
@interface WPPopView ()
- (void) initInterface;
- (void) initAlertViewWithRect:(CGSize) size;
@end

@implementation WPPopView {
    UIWindow * _popWindow;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initInterface];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize) size {
    self = [super init];
    if (self) {
        [self initAlertViewWithRect:size];
    }
    return self;
}

- (void)initInterface {
    _popWindow = [[UIWindow alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    _popWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    _popWindow.windowLevel = UIWindowLevelAlert;
    self.bounds = CGRectMake(0, 0, SCREEN_W*0.75, SCREEN_H*0.6);
    self.backgroundColor = [UIColor whiteColor];
    self.center = _popWindow.center;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    [_popWindow addSubview:self];
}

- (void) initAlertViewWithRect:(CGSize) size {
    _popWindow  = [[UIWindow alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    _popWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    _popWindow.windowLevel     = UIWindowLevelAlert;
    self.bounds = CGRectMake(0, 0, size.width, size.height);
    self.backgroundColor       = [UIColor whiteColor];
    self.center                = _popWindow.center;
    self.layer.cornerRadius    = 5;
    self.clipsToBounds         = YES;
    [_popWindow addSubview:self];
}

- (void)show {
    [_popWindow makeKeyAndVisible];
    self.alpha = 0.0;
    [UIView animateWithDuration:DURATION animations:^{
        self.alpha = 1.0;
    } completion:nil];
}
- (void)hide {
    [UIView animateWithDuration:DURATION animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        _popWindow.windowLevel = UIWindowLevelNormal;
        [self removeFromSuperview];
        [_popWindow resignKeyWindow];
        _popWindow.alpha = 0;

    }];

}
@end
