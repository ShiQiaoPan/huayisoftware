//
//  WPCustomRepairCell.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/17.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPCustomAddRepairCell.h"

@interface WPCustomAddRepairCell ()<UITextFieldDelegate>
- (void)initializeAppearance;

@end
@implementation WPCustomAddRepairCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeAppearance];
    }
    return self;
}
#pragma mark - init
- (void)initializeAppearance {
    [self addSubview:self.titleText];
    [self addSubview:self.payText];
}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.titleText) {
        if (textField.text.length > 40) {
            return NO;
        }
    }
    else if (textField == self.payText) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.payText) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sum" object:nil];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - getter
- (UITextField *)titleText {
    if (!_titleText) {
        _titleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 140, CGRectGetHeight(self.bounds)/DHFlexibleVerticalMutiplier()) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)adjustWidth:NO];
            [view addSubview:self.titleNumLabel];
            text.leftView = view;
            text.placeholder = @"内容";
            text.backgroundColor = [UIColor whiteColor];
            text.adjustsFontSizeToFitWidth = YES;
            text.delegate = self;
            text;
        });
    }
    return _titleText;
}
- (UILabel *)titleNumLabel {
    if (!_titleNumLabel) {
        _titleNumLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.adjustsFontSizeToFitWidth = YES;
            lab;
        });
    }
    return _titleNumLabel;
}
- (UITextField *)payText {
    if (!_payText) {
        _payText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, 180, CGRectGetHeight(self.bounds)/DHFlexibleVerticalMutiplier()) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"维修费用:";
            lab.adjustsFontSizeToFitWidth = YES;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"0";
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.clearsOnBeginEditing = YES;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text.adjustsFontSizeToFitWidth = YES;
            text;
        });
    }
    return _payText;
}
@end
