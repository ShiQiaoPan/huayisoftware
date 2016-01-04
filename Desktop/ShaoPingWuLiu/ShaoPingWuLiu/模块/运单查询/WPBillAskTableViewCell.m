//
//  WPBillAskTableViewCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/18.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBillAskTableViewCell.h"
#define BILLTXTCOLOR [UIColor colorWithRed:151/255.0 green:152/255.0 blue:153/255.0 alpha:1]

@interface WPBillAskTableViewCell ()
- (void)initializeAppearance;/**< 一般界面初始化 */


@end

@implementation WPBillAskTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}
- (void)initializeAppearance {
    [self addSubview:self.titleLab];
    [self addSubview:self.detailTextLabel];
}
#pragma mark - getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 320, 30) adjustWidth:NO];
            lab.textColor = BILLTXTCOLOR;
            lab.font = [UIFont systemFontOfSize:12*DHFlexibleHorizontalMutiplier()];
            lab;
        });
    }
    return _titleLab;
}
- (UILabel *)detailTextLabel {
    if (!_detailLab) {
        _detailLab = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(35, 25, 320, 30) adjustWidth:NO];
            lab.textColor = BILLTXTCOLOR;
            lab.font = [UIFont systemFontOfSize:12*DHFlexibleHorizontalMutiplier()];
            lab;
        });
    }
    return _detailLab;
}
- (UIImageView *)firstImage {
    if (!_firstImage) {
        _firstImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 52) adjustWidth:YES];
            view.center = DHFlexibleCenter(CGPointMake(20, 36));
            view.image = IMAGE_CONTENT(@"roundline1.png");
            view;
        });
    }
    return _firstImage;
}
- (UIImageView *)sencondImage {
    if (!_sencondImage) {
        _sencondImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 9, 62) adjustWidth:YES];
            view.center = DHFlexibleCenter(CGPointMake(20, 31));
            view.image = IMAGE_CONTENT(@"roundline2.png");
            view;
        });
    }
    return _sencondImage;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(30, 61, 290, 1) adjustWidth:NO];
            view.backgroundColor = COLOR_RGB(211, 212, 213, 1);
            view;
        });
    }
    return _lineView;
}
@end
