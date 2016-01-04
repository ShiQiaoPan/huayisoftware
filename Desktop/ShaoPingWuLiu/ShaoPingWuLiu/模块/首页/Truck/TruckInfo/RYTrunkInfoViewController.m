//
//  RYTrunkInfoViewController.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/16.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYTrunkInfoViewController.h"
#import "WPDatePickView.h"
#import "WPTruckBasicInfoViewModel.h"

#define iSpace        10.0f
#define row_Height    30.0f
#define textFont      14.0f
#define mColor [UIColor colorWithWhite:0.88 alpha:1]
#define TextColor  COLOR_RGB(100, 101, 102, 1)

@interface RYTrunkInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *backSrol; /**< 背景视图   */
@property (nonatomic, strong) UITextField * carOwnerTitleText;/**< 车主标题 */
@property (nonatomic, strong) UITextField * carOwnerInfotext;/**< 车主姓名 */
@property (nonatomic, strong) UITextField * carOwnerPhoneText;/**< 车主电话 */
@property (nonatomic, strong) UITextField * driverTitleText;/**< 司机标题 */
@property (nonatomic, strong) UITextField * driverNameText;/**< 司机姓名 */
@property (nonatomic, strong) UITextField * driverPhoneText;/**< 司机电话 */
@property (nonatomic, strong) UITextField * driverCardText;/**< 司机驾驶证 */
@property (nonatomic, strong) UITextField * driverIDCardText;/**< 司机身份证 */
@property (nonatomic, strong) UITextField * carTitleText;/**< 车标题 */
@property (nonatomic, strong) UITextField * carNumText;/**< 车牌号 */
@property (nonatomic, strong) UIView * carBuyDayView;
@property (nonatomic, strong) UILabel * carBuyDayLabel;/**< 购买日期 */
@property (nonatomic, strong) UITextField * carLongText;/**< 车长 */
@property (nonatomic, strong) UITextField * carBottomHeightText;/**< 车底盘高度 */
@property (nonatomic, strong) UITextField * carWidthText;/**< 车宽 */
@property (nonatomic, strong) UITextField * carAxleCountText;/**< 轴数 */

@property (nonatomic, strong) UITextField * oilTitleText;/**< 油卡标题 */
@property (nonatomic, strong) UITextField * oilCardText;/**< 油卡卡号 */

@property (nonatomic, strong) UITextField * bankcardTitleText;/**< 银行卡标题 */
@property (nonatomic, strong) UITextField * bankcardNameText;/**< 银行卡持有人 */
@property (nonatomic, strong) UITextField * bankNameText;/**< 开户银行名 */
@property (nonatomic, strong) UITextField * bankCardNumText;/**< 银行卡号 */
@property (nonatomic, strong) NSDictionary * basicInfoDict;/**< 基本信息字典 */


- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */
- (BOOL)isAllWirite;/**< 判断是否填写完整 */
@end

@implementation RYTrunkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}
#pragma mark - init
- (void)refreshData {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"获取车辆信息中";
    __weak typeof(self)weakself = self;
    [WPTruckBasicInfoViewModel getTruckBasicInfoWithSuccessBlock:^(NSDictionary *basicSuc) {
        hud.labelText = @"获取网络数据成功";
        hud.detailsLabelText = @"刷新数据中...";
        [hud hide:YES afterDelay:1.0];
        weakself.carOwnerInfotext.text = basicSuc[@"COwner"];
        weakself.carOwnerPhoneText.text = basicSuc[@"COwnerPhone"];
        weakself.driverNameText.text = basicSuc[@"Driver"];
        weakself.driverPhoneText.text = basicSuc[@"DriverPhone"];
        weakself.driverCardText.text = basicSuc[@"DriveCard"];
        weakself.driverIDCardText.text = basicSuc[@"IDCard"];
        weakself.carNumText.text = basicSuc[@"CarNo"];
        weakself.carBuyDayLabel.text = basicSuc[@"GCRQ"];
        weakself.carLongText.text = basicSuc[@"Long"];
        weakself.carBottomHeightText.text = basicSuc[@"Height"];
        weakself.carWidthText.text = basicSuc[@"Width"];
        weakself.carAxleCountText.text = basicSuc[@"BonnetNumber"];
        weakself.bankcardNameText.text = basicSuc[@"BankHM"];
        weakself.bankNameText.text = basicSuc[@"BankName"];
        weakself.bankCardNumText.text = basicSuc[@"BankNo"];
        weakself.oilCardText.text = basicSuc[@"JykNo"];
        [UserDataStoreModel saveUserDataWithDataKey:@"truckBasic" andWithData:basicSuc andWithReturnFlag:nil];
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"获取车辆信息失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];

}
- (void)initializeDataSource {
    self.basicInfoDict = [UserDataStoreModel readUserDataWithDataKey:@"truckBasic"];
}

- (void)initializeUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"车辆资料";
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.backSrol];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [self.backSrol addSubview:self.carOwnerTitleText];
    [self addLineWithYPosition:30 andWithPath:path];
    [self.backSrol addSubview:self.carOwnerInfotext];
    [self.backSrol addSubview:self.carOwnerPhoneText];
    [self.backSrol addSubview:self.driverTitleText];
    [self addLineWithYPosition:100 andWithPath:path];
    [self.backSrol addSubview:self.driverNameText];
    [self.backSrol addSubview:self.driverPhoneText];
    [self addLineWithYPosition:130 andWithPath:path];
    [self.backSrol addSubview:self.driverCardText];
    [self addLineWithYPosition:160 andWithPath:path];
    [self.backSrol addSubview:self.driverIDCardText];

    
    [self.backSrol addSubview:self.carTitleText];
    [self addLineWithYPosition:230 andWithPath:path];
    [self.backSrol addSubview:self.carNumText];
    [self addLineWithYPosition:260 andWithPath:path];
    [self.backSrol addSubview:self.carBuyDayView];
    [self.backSrol addSubview:self.carBuyDayLabel];
    [self addLineWithYPosition:290 andWithPath:path];
    [self.backSrol addSubview:self.carLongText];
    [self.backSrol addSubview:self.carBottomHeightText];
    [self.backSrol addSubview:self.carWidthText];
    [self addLineWithYPosition:320 andWithPath:path];
    [self.backSrol addSubview:self.carAxleCountText];
    
    [self.backSrol addSubview:self.oilTitleText];
    [self addLineWithYPosition:390 andWithPath:path];
    [self.backSrol addSubview:self.oilCardText];
    
    [self.backSrol addSubview:self.bankcardTitleText];
    [self addLineWithYPosition:460 andWithPath:path];
    [self.backSrol addSubview:self.bankcardNameText];
    [self addLineWithYPosition:490 andWithPath:path];
    [self.backSrol addSubview:self.bankNameText];
    [self addLineWithYPosition:520 andWithPath:path];
    [self.backSrol addSubview:self.bankCardNumText];
    self.backSrol.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bankCardNumText.frame));
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 800), NO);
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    layer.path = path.CGPath;
    [self.backSrol.layer addSublayer:layer];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    if (![self isAllWirite]) {
        return;
    }
    [self.view endEditing:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在提交中...";
    [WPTruckBasicInfoViewModel submitTruckBasicInfoWithParams:[self getParams] successBlock:^(NSString *basicSuc) {
        hud.labelText = @"提交成功";
        hud.detailsLabelText = @"保存数据中";
        [hud hide:YES afterDelay:1.0];
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"提交失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];

}
- (void)respondsToBuyDayLabel {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"时间选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.carBuyDayLabel.text = destDateString;
    }];

}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.carOwnerPhoneText || textField == self.driverPhoneText) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - private menthods
- (void)addLineWithYPosition :(CGFloat)y andWithPath:(UIBezierPath *)path{
    [path moveToPoint:DHFlexibleCenter(CGPointMake(0, y))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, y))];
    path.lineWidth = 1;
}
- (NSMutableDictionary *)getParams {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"purchasedata"] = self.carBuyDayLabel.text;
    dic[@"owner"] = self.carOwnerInfotext.text;
    dic[@"ownerphone"] = self.carOwnerPhoneText.text;
    dic[@"driver"] = self.driverNameText.text;
    dic[@"driverphone"] = self.driverPhoneText.text;
    dic[@"driverid"] = self.driverIDCardText.text;
    dic[@"vehiclelength"] = self.carLongText.text;
    dic[@"chassisheight"] = self.carBottomHeightText.text;
    dic[@"vehidewidth"] = self.carWidthText.text;
    dic[@"axescount"] = self.carAxleCountText.text;
    dic[@"drivinglicence"] = self.driverCardText.text;
    dic[@"numberplate"] = self.carNumText.text;
    return dic;
}
- (BOOL)isAllWirite {
    if (self.carOwnerInfotext.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写车主姓名"];
        return NO;
    }
    if (self.carOwnerPhoneText.text.length == 0 || ![ConfirmMobileNumber isMobileNumber:self.carOwnerPhoneText.text]) {
        [self initializeAlertControllerWithMessage:@"请正确填写车主电话"];
        return NO;
    }
    if (self.driverNameText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写司机姓名"];
        return NO;
    }
    if (self.driverPhoneText.text.length == 0 || ![ConfirmMobileNumber isMobileNumber:self.driverPhoneText.text]) {
        [self initializeAlertControllerWithMessage:@"请正确填写司机电话"];
        return NO;
    }
    if (self.driverCardText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写司机驾驶证信息"];
        return NO;
    }
    if (self.driverIDCardText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写司机身份证信息"];
        return NO;
    }
    if (self.carNumText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写车牌号"];
        return NO;
    }
    if ([self.carBuyDayLabel.text isEqualToString:@"购车日期"]) {
        [self initializeAlertControllerWithMessage:@"请填写购车日期"];
        return NO;
    }
    if (self.carLongText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写车长"];
        return NO;
    }
    if (self.carBottomHeightText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写底盘高度"];
        return NO;
    }
    if (self.carWidthText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写车宽"];
        return NO;
    }
    if (self.carAxleCountText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写轴数"];
        return NO;
    }
    return YES;
}
#pragma mark - getter
- (UIScrollView *)backSrol {
    if (!_backSrol) {
        _backSrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, 320, ORIGIN_HEIGHT - 80) adjustWidth:NO];
        _backSrol.showsVerticalScrollIndicator = NO;
        _backSrol.showsHorizontalScrollIndicator = NO;
        _backSrol.contentSize = CGSizeMake(0, 800);
    }
    return _backSrol;
}
- (UITextField *)carOwnerTitleText {
    if (!_carOwnerTitleText) {
        _carOwnerTitleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 30) adjustWidth:NO];
            text.text = @"车主信息";
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)adjustWidth:NO];
            text.leftView = view;
            text.backgroundColor = [UIColor whiteColor];
            text.textColor = TextColor;
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _carOwnerTitleText;
}
- (UITextField *)carOwnerInfotext {
    if (!_carOwnerInfotext) {
        _carOwnerInfotext = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 30, 200, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 30) adjustWidth:NO];
            lab.text = @"车主:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"姓名";
            text.textColor = TextColor;
            text.text = self.basicInfoDict[@"COwner"];
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text;
        });
    }
    return _carOwnerInfotext;
}
- (UITextField *)carOwnerPhoneText {
    if (!_carOwnerPhoneText) {
        _carOwnerPhoneText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(160, 30, 160, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 30) adjustWidth:NO];
            lab.text = @"电话:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = lab;
            text.placeholder = @"电话";
            text.text = self.basicInfoDict[@"COwnerPhone"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            text.delegate = self;
            text;

        });
    }
    return _carOwnerPhoneText;
}
- (UITextField *)driverTitleText {
    if (!_driverTitleText) {
        _driverTitleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 70, 320, 30) adjustWidth:NO];
            text.text = @"司机信息";
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)adjustWidth:NO];
            text.leftView = view;
            text.backgroundColor = [UIColor whiteColor];
            text.textColor = TextColor;
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _driverTitleText;
}
- (UITextField *)driverNameText {
    if (!_driverNameText) {
        _driverNameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 160, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 30) adjustWidth:NO];
            lab.text = @"司机:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.textColor = TextColor;
            text.placeholder = @"姓名";
            text.text = self.basicInfoDict[@"Driver"];
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text;
        });
    }
    return _driverNameText;
}
- (UITextField *)driverPhoneText {
    if (!_driverPhoneText) {
        _driverPhoneText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(160, 100, 160, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 30) adjustWidth:NO];
            lab.text = @"电话:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = lab;
            text.placeholder = @"电话";
            text.text = self.basicInfoDict[@"DriverPhone"];
            text.backgroundColor = [UIColor whiteColor];
            text.textColor = TextColor;
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            text;
        });
    }
    return _driverPhoneText;
}
- (UITextField *)driverCardText {
    if (!_driverCardText) {
        _driverCardText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 130, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 30) adjustWidth:NO];
            lab.text = @"驾驶证:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"驾驶证号";
            text.text = self.basicInfoDict[@"DriveCard"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            text;
        });
    }
    return _driverCardText;
}
- (UITextField *)driverIDCardText {
    if (!_driverIDCardText) {
        _driverIDCardText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 160, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 30) adjustWidth:NO];
            lab.text = @"身份证:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"身份证号";
            text.text = self.basicInfoDict[@"IDCard"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            text;

        });
    }
    return _driverIDCardText;
}

- (UITextField *)carTitleText {
    if (!_carTitleText) {
        _carTitleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 200, 320, 30) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)adjustWidth:NO];
            text.leftView = view;
            text.text = @"车辆信息";
            text.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text;

        });
    }
    return _carTitleText;
}
- (UITextField *)carNumText {
    if (!_carNumText) {
        _carNumText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 230, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"车牌号:";
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"车牌号";
            text.text = self.basicInfoDict[@"CarNo"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text;
        });
    }
    return _carNumText;
}
- (UIView *)carBuyDayView {
    if (!_carBuyDayView) {
        _carBuyDayView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 260, 100, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 30) adjustWidth:NO];
            lab.text = @"购车日期:";
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textColor = TextColor;
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:lab];
            view;
        });
    }
    return _carBuyDayView;
}
- (UILabel *)carBuyDayLabel {
    if (!_carBuyDayLabel) {
        _carBuyDayLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 260, 220, 30) adjustWidth:NO];
            lab.textColor = GARYTextColor;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToBuyDayLabel)];
            [lab addGestureRecognizer:ges];
            lab.userInteractionEnabled = YES;
            lab.text = self.basicInfoDict[@"gcrq"]?self.basicInfoDict[@"gcrq"]: @"购车日期";
            lab.backgroundColor = [UIColor whiteColor];
            lab;
        });
    }
    return _carBuyDayLabel;
}
- (UITextField *)carLongText {
    if (!_carLongText) {
        _carLongText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 290, 100, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 30) adjustWidth:NO];
            lab.text = @"车长:";
            lab.textColor = TextColor;
            lab.adjustsFontSizeToFitWidth = YES;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"车长";
            text.text = self.basicInfoDict[@"Long"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text;
        });
    }
    return _carLongText;
}
- (UITextField *)carBottomHeightText {
    if (!_carBottomHeightText) {
        _carBottomHeightText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(90, 290, 120, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 30) adjustWidth:NO];
            lab.text = @"底盘高度:";
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = lab;
            text.placeholder = @"高度";
            text.text = self.basicInfoDict[@"Height"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text;
        });
    }
    return _carBottomHeightText;
}
- (UITextField *)carWidthText {
    if (!_carWidthText) {
        _carWidthText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(210, 290, 120, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30) adjustWidth:NO];
            lab.text = @"车净宽:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = lab;
            text.placeholder = @"宽度";
            text.text = self.basicInfoDict[@"Width"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text;
        });
    }
    return _carWidthText;
}
- (UITextField *)carAxleCountText {
    if (!_carAxleCountText) {
        _carAxleCountText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 320, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30) adjustWidth:NO];
            lab.text = @"轴数:";
            lab.textColor = TextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"轴数";
            text.text = self.basicInfoDict[@"BonnetNumber"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.delegate = self;
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text;

        });
    }
    return _carAxleCountText;
}
- (UITextField *)oilTitleText {
    if (!_oilTitleText) {
        _oilTitleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 360, 320, 30) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)adjustWidth:NO];
            text.leftView = view;
            text.text = @"油卡信息";
            text.textColor = GARYTextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text;

        });
    }
    return _oilTitleText;
}

- (UITextField *)oilCardText {
    if (!_oilCardText) {
        _oilCardText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 390, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"加油卡号:";
            lab.adjustsFontSizeToFitWidth = YES;
            lab.textColor = GARYTextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"加油卡卡号";
            text.text = self.basicInfoDict[@"JykNo"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _oilCardText;
}
- (UITextField *)bankcardTitleText {
    if (!_bankcardTitleText) {
        _bankcardTitleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 430, 320, 30) adjustWidth:NO];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)adjustWidth:NO];
            text.leftView = view;
            text.text = @"开户信息";
            text.textColor = GARYTextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _bankcardTitleText;
}
- (UITextField *)bankcardNameText {
    if (!_bankcardNameText) {
        _bankcardNameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 460, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"开户名:";
            lab.textColor = GARYTextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"开户姓名";
            text.text = self.basicInfoDict[@"BankHM"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _bankcardNameText;
}
- (UITextField *)bankNameText {
    if (!_bankNameText) {
        _bankNameText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 490, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"开户银行:";
            lab.textColor = GARYTextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"开户银行名";
            text.text = self.basicInfoDict[@"BankName"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _bankNameText;
}
- (UITextField *)bankCardNumText {
    if (!_bankCardNumText) {
        _bankCardNumText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 520, 320, 30) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"开户账号:";
            lab.textColor = GARYTextColor;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"银行账户";
            text.text = self.basicInfoDict[@"BankNo"];
            text.textColor = TextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _bankCardNumText;
}
@end
