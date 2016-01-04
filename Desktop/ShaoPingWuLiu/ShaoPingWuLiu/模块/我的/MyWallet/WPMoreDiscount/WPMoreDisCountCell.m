//
//  WPMoreDisCountCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/1.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMoreDisCountCell.h"

@interface WPMoreDisCountCell ()
@property (nonatomic, strong)UILabel * discountUseLabel;
- (void)initializeAppearance;
@end

@implementation WPMoreDisCountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    [self addSubview:self.discountImage];
    [self addSubview:self.discountUseLabel];
    [self addSubview:self.discountLabel];
}
#pragma mark - getter
- (UIImageView *)discountImage {
    if (!_discountImage) {
        _discountImage = ({
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85, 50) adjustWidth:YES];
            image;
        });
    }
    return _discountImage;
}
- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = ({
            UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.bounds)/DHFlexibleVerticalMutiplier()-10, 320, 40) adjustWidth:NO];
            countLabel.textColor = COLOR_RGB(239, 86, 59, 1);
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel;
        });
    }
    return _discountLabel;
}


- (UILabel *)discountUseLabel {
    if (!_discountUseLabel) {
        _discountUseLabel = ({
            UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, CGRectGetMidY(self.bounds)/DHFlexibleVerticalMutiplier()-10, 100, 40) adjustWidth:NO];
            countLabel.textColor = COLOR_RGB(239, 86, 59, 1);
            countLabel.textAlignment = NSTextAlignmentRight;
            countLabel.text = @"可以使用";
            countLabel;
        });
    }
    return _discountUseLabel;
}
@end
