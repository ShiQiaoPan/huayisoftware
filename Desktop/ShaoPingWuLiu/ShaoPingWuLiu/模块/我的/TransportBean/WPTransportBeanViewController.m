//
//  WPTransportBeanViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTransportBeanViewController.h"
#import "WPTransportBeanViewModel.h"
@interface WPTransportBeanViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) NSInteger beanCount;/**< 运输豆总量 */
@property (nonatomic, assign) NSInteger moneyCount;/**< 兑换的比例 */
@property (nonatomic, strong) UIImageView * beanImageView;/**< 豆子图 */
@property (nonatomic, strong) UILabel * myBeanLabel;/**< 豆子说明 */
@property (nonatomic, strong) UILabel * beanCountLabel;/**< 豆子数量 */
@property (nonatomic, strong) UILabel * scleLabel;/**< 比例说明 */
@property (nonatomic, strong) UITextField * beanNumText;/**< 兑换豆子数目 */
@property (nonatomic, strong) UITextField * discountText;/**< 优惠劵金额 */
@property (nonatomic, strong) UIButton * convertBtn;/**< 兑换按钮 */
@property (nonatomic, strong) UITextField * titleTextField;/**< 来源标题 */
@property (nonatomic, strong) UILabel * getBeanLabel;/**< 获取运输豆说明 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPTransportBeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeDataSource];
}
#pragma mark - init
- (void)initializeDataSource {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"数据刷新中";
    self.beanCount = [[UserDataStoreModel readUserDataWithDataKey:@"bean"]integerValue];
    __weak typeof(self)weakself = self;
    [WPTransportBeanViewModel getBeanCountWithSuccessBlock:^(NSInteger count) {
        weakself.beanCount = count;
        weakself.beanCountLabel.text = [NSString stringWithFormat:@"%ld个", count];
        weakself.beanNumText.placeholder = [NSString stringWithFormat:@"当前可兑换运输豆%ld个", count];
        [UserDataStoreModel saveUserDataWithDataKey:@"bean" andWithData:@(count) andWithReturnFlag:nil];
        [WPTransportBeanViewModel getBeanConversionWithSuccessBlock:^(NSString *success) {
            hud.labelText = @"刷新成功";
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
            weakself.moneyCount = [success integerValue];
            weakself.scleLabel.text = [NSString stringWithFormat:@"提示：%@运输豆=1元优惠劵", success];
            [[NSUserDefaults standardUserDefaults]setObject:weakself.scleLabel.text forKey:@"scle"];
        } failBlock:^(NSString *error) {
            hud.labelText = @"刷新失败";
            hud.detailsLabelText = error;
            [hud hide:YES afterDelay:2.0];
        }];
    } failBlock:^(NSString *error) {
        hud.labelText = @"刷新失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];

}
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    self.titleLable.text = @"运输豆";
    [self.rightButton removeFromSuperview];
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.view addSubview:self.beanImageView];
    [self.view addSubview:self.myBeanLabel];
    [self.view addSubview:self.beanCountLabel];
    [self.view addSubview:self.scleLabel];
    [self.view addSubview:self.beanNumText];
    [self.view addSubview:self.discountText];
    [self addLine];
    [self.view addSubview:self.convertBtn];
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.getBeanLabel];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToConverBtn {
    if ([self.beanNumText.text integerValue] % self.moneyCount) {
        [self initializeAlertControllerWithMessageAndDismiss:@"请输入兑换比例的整数倍进行兑换"];
        return;
    }
    [self.view endEditing:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在提交申请";
    __weak typeof(self)weakself = self;
   
    [WPTransportBeanViewModel changeBeanWithBeanCount:self.beanNumText.text SuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakself.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSString *error) {
        hud.labelText = @"提交失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - system protocol
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self calculateChangeResult];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.discountText.text = @"￥0";
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger result = 0;
    if (![string isEqualToString:@""]) {
        result = [[NSString stringWithFormat:@"%@%@", textField.text, string ] integerValue]  / self.moneyCount;
    } else {
        result = [[textField.text substringToIndex:textField.text.length - 1] integerValue] / self.moneyCount;
    }
    
    self.discountText.text = [NSString stringWithFormat:@"￥%ld", result];
    if (textField.text.length > 10) {
        return NO;
    }
    return YES;
}
#pragma mark - private methods
- (void)addLine {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.scleLabel.frame))];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, CGRectGetMaxY(self.scleLabel.frame))];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.beanNumText.frame))];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, CGRectGetMaxY(self.beanNumText.frame))];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.discountText.frame))];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, CGRectGetMaxY(self.discountText.frame))];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.view.frame;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = GARYTextColor.CGColor;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}
- (void)calculateChangeResult {
    NSInteger result = [self.beanNumText.text integerValue]  / self.moneyCount;
    self.discountText.text = [NSString stringWithFormat:@"￥%ld", result];
}
#pragma mark - getter
- (UIImageView *)beanImageView {
    if (!_beanImageView) {
        _beanImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(130, 80, 60, 60) adjustWidth:YES];
            view.image = IMAGE_CONTENT(@"myBean.png");
            view;
        });
    }
    return _beanImageView;
}
- (UILabel *)myBeanLabel {
    if (!_myBeanLabel) {
        _myBeanLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.beanImageView.frame)/DHFlexibleVerticalMutiplier()+10, 320, 30) adjustWidth:NO];
            label.text = @"我的运输豆";
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _myBeanLabel;
}
- (UILabel *)beanCountLabel {
    if (!_beanCountLabel) {
        _beanCountLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myBeanLabel.frame)/DHFlexibleVerticalMutiplier(), 320, 30) adjustWidth:NO];
            
            label.text = [NSString stringWithFormat:@"%ld个", (long)([UserDataStoreModel readUserDataWithDataKey:@"bean"]? [[UserDataStoreModel readUserDataWithDataKey:@"bean"]integerValue]:0)];
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = COLOR_RGB(241, 109, 88, 1);
            label;
        });
    }
    return _beanCountLabel;
}
- (UILabel *)scleLabel {
    if (!_scleLabel) {
        _scleLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.myBeanLabel.frame)/DHFlexibleVerticalMutiplier()+30, 300, 30)adjustWidth:NO];
            label.textColor = COLOR_RGB(241, 109, 88, 1);
            label.adjustsFontSizeToFitWidth = YES;
            label.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"scle"]? [[NSUserDefaults standardUserDefaults]objectForKey:@"scle"]:@"提示：0运输豆=1元优惠劵";
            label;
        });
    }
    return _scleLabel;
}
- (UITextField *)beanNumText {
    if (!_beanNumText) {
        _beanNumText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scleLabel.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40) adjustWidth:NO];
            label.text = @"运输豆";
            label.adjustsFontSizeToFitWidth = YES;
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.placeholder = [NSString stringWithFormat:@"当前可兑换运输豆%ld个", (long)self.beanCount];
            text.adjustsFontSizeToFitWidth = YES;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.backgroundColor = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            text.delegate = self;
            text;
        });
    }
    return _beanNumText;
}
- (UITextField *)discountText {
    if (!_discountText) {
        _discountText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.beanNumText.frame)/DHFlexibleVerticalMutiplier(), 320, 40) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40) adjustWidth:NO];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 40) adjustWidth:NO];
            label.text = @"优惠劵金额";
            label.adjustsFontSizeToFitWidth = YES;
            [view addSubview:label];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text.textColor = COLOR_RGB(241, 109, 88, 1);
            text.text = @"￥0";
            text.textAlignment = NSTextAlignmentCenter;
            text;
        });
    }
    return _discountText;
}
- (UIButton *)convertBtn {
    if (!_convertBtn) {
        _convertBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(10, CGRectGetMaxY(self.discountText.frame)/DHFlexibleVerticalMutiplier()+30, 300, 40), NO);
            [btn setTitle:@"兑换" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10*DHFlexibleVerticalMutiplier();
            [btn addTarget:self action:@selector(respondsToConverBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _convertBtn;
}
- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.convertBtn.frame)/DHFlexibleVerticalMutiplier()+30, 320, 30) adjustWidth:NO];
            text.textColor = COLOR_RGB(116, 184, 251, 1);
            text.userInteractionEnabled = NO;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) adjustWidth:NO];
            imageView.image = IMAGE_CONTENT(@"bean.png");
            text.text = @"运输豆来源";
            text.font = [UIFont systemFontOfSize:14];
            text.leftView = imageView;
            text;
        });
    }
    return _titleTextField;
}
- (UILabel *)getBeanLabel {
    if (!_getBeanLabel) {
        _getBeanLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleTextField.frame)/DHFlexibleVerticalMutiplier(), 290, 60) adjustWidth:NO];
            label.text = @"发货订单成功后的支付运费(扣除优惠劵)、建议反馈、星级等级兑换、邀请好友";
            label.numberOfLines = 0;
            label.textColor = COLOR_RGB(87, 88, 89, 1);
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
    }
    return _getBeanLabel;
}
@end
