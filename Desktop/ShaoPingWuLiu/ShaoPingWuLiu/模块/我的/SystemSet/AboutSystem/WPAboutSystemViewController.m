//
//  WPAboutSystemViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/19.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAboutSystemViewController.h"



@interface WPAboutSystemViewController ()
@property (nonatomic, strong) UIImageView * systemImageView;
@property (nonatomic, strong) UILabel * versionLab;
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPAboutSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"关于系统";
    [self.view addSubview:self.systemImageView];
    [self.view addSubview:self.versionLab];
}
#pragma mark - getter
- (UILabel *)versionLab {
    if (!_versionLab) {
        _versionLab = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 450, 320, 40) adjustWidth:NO];
            lab.text = @"当前版本   V1.1.4";
            lab.textAlignment = NSTextAlignmentCenter;
            lab;
        });
    }
    return _versionLab;
}
- (UIImageView *)systemImageView {
    if (!_systemImageView) {
        _systemImageView = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(72, 120, 176, 280), YES)];
            imageView.image = IMAGE_CONTENT(@"abooutSystem@2x.png");
            imageView;
        });
    }
    return _systemImageView;
}
@end
