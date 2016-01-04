//
//  WPAddRepairViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/17.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddRepairViewController.h"
#import "WPCustomAddRepairCell.h"
#import "WPDatePickView.h"
#import "WPTruckRepairViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPAddRepairViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray * _repairDatasource;/**< 维修内容数组 */
}
@property (nonatomic, strong) UITextField * repairTitle;/**< 维修标题 */
@property (nonatomic, strong) UITextField * repairPersonText;/**< 维修人 */
@property (nonatomic, strong) UILabel * repairTimeTileLabel;/**< 维修时间标题 */
@property (nonatomic, strong) UILabel * repairTimeLabel;/**< 维修内容 */

@property (nonatomic, strong) UITableView * repairTableView;/**< 维修内容表格视图 */
@property (nonatomic, strong) UIView * addView;/**< 添加 */
@property (nonatomic, strong) UITextField * sumTextField;/**< 维修和 */
@property (nonatomic, strong) NSArray * detailArr;/**< 详情数组 */
@property (nonatomic, strong) UIView * headView;/**< 头部视图 */
@property (nonatomic, strong) UIView * footView;/**< 尾部视图 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPAddRepairViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sum" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults]setFloat:0.0 forKey:@"sum"];
}
#pragma mark - init
- (void)initializeDataSource {
    _repairDatasource = [NSMutableArray arrayWithObjects:@"1", nil];
}
- (void)initializeUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"新增维修记录";
    self.titleLable.adjustsFontSizeToFitWidth = YES;
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.repairTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSum) name:@"sum" object:nil];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    [self.view endEditing:YES];
    [self refreshSum];
    NSArray * resultArr = [self getResultArr];
    if (resultArr.count == 0) {
        [self initializeAlertControllerWithMessage:@"您未填写记录"];
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在提交维修记录";
    __weak typeof(self)weakself = self;
    [WPTruckRepairViewModel addRepairRecordWithRepairDate:self.repairTimeLabel.text repairManName:self.repairPersonText.text repairMoneyCount:[self.sumTextField.text substringFromIndex:5] repairDetailsArr:resultArr WithSuccessBlock:^(NSString *success) {
        hud.labelText = @"提交成功";
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
- (void)respondsToAdd {
    [_repairDatasource addObject:@(1)];
    [self.repairTableView reloadData];
}
- (void)refreshSum {
    CGFloat sum = 0;
    for (int i = 0; i < _repairDatasource.count; i++) {
        WPCustomAddRepairCell * cell = [self.repairTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        sum +=[cell.payText.text floatValue];
    }
    self.sumTextField.text = [NSString stringWithFormat:@"维修总计：%.2f", sum];
}
- (void)respondsToRepairTimeLabel {
    [self.view endEditing:YES];
    [WPDatePickView showViewWithTitle:@"时间选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.repairTimeLabel.text = destDateString;
    }];
}
#pragma mark - system protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.repairPersonText) {
        if (textField.text.length > 10) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _repairDatasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPCustomAddRepairCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPCustomAddRepairCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleNumLabel.text = [NSString stringWithFormat:@"维修内容%ld:", indexPath.row + 1];
    return cell;
}
#pragma mark - UITableViewDelegate
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44*DHFlexibleVerticalMutiplier();
}

#pragma mark - private menthods
- (void)addLineWithYPosition:(CGFloat)y andWithPath:(UIBezierPath *) path {
    [path moveToPoint:DHFlexibleCenter(CGPointMake(0, y))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, y))];
    path.lineWidth = 1;
}
- (NSArray *)getResultArr {
    NSMutableArray * resultArr = [NSMutableArray arrayWithCapacity:0];
    int j = 0;
    for (int i = 0; i < _repairDatasource.count; i++) {
        WPCustomAddRepairCell * cell = [self.repairTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        NSString * content = cell.titleText.text;
        NSString * pay = cell.payText.text;
        if (content.length == 0 || pay.length == 0) {
            continue;
        }
        j++;
        NSString * contentkey = [NSString stringWithFormat:@"mcontents[%d].servicecontent", j];
        NSString * paykey = [NSString stringWithFormat:@"mcontents[%d].servicemoney", j];
        NSDictionary * dic = @{contentkey:content, paykey:pay};
        [resultArr addObject:dic];
    }
    return resultArr;
}

#pragma mark - getter
- (UITextField *)repairTitle {
    if (!_repairTitle) {
        _repairTitle = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 40) adjustWidth:NO];
            text.text = @"请填写您的维修信息";
            text.userInteractionEnabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = view;
            text;
        });
    }
    return _repairTitle;
}
- (UITextField *)repairPersonText {
    if (!_repairPersonText) {
        _repairPersonText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 40, 160, 40) adjustWidth:NO];
            text.backgroundColor = [UIColor whiteColor];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30) adjustWidth:NO];
            lab.text = @"维修人:";
            lab.adjustsFontSizeToFitWidth = YES;
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)adjustWidth:NO];
            [view addSubview:lab];
            text.leftView = view;
            text.placeholder = @"姓名";
            text.adjustsFontSizeToFitWidth = YES;
            text.delegate = self;
            text;
        });
    }
    return _repairPersonText;
}

- (UILabel *)repairTimeTileLabel {
    if (!_repairTimeTileLabel) {
        _repairTimeTileLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(150, 40, 80, 40) adjustWidth:NO];
            lab.text = @"维修时间：";
            lab.backgroundColor = [UIColor whiteColor];
            lab.adjustsFontSizeToFitWidth = YES;
            lab;
        });
    }
    return _repairTimeTileLabel;
}
- (UILabel *)repairTimeLabel {
    if (!_repairTimeLabel) {
        _repairTimeLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(230, 40, 90, 40) adjustWidth:NO];
            lab.text = @"维修时间选择";
            lab.adjustsFontSizeToFitWidth = YES;
            lab.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToRepairTimeLabel)];
            [lab addGestureRecognizer:ges];
            lab.userInteractionEnabled = YES;
            lab;
        });
    }
    return _repairTimeLabel;
}
- (UITableView *)repairTableView {
    if (!_repairTableView) {
        _repairTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 75, ORIGIN_WIDTH, ORIGIN_HEIGHT - 155), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = GARYTextColor;
            tableview.tableHeaderView = self.headView;
            tableview.tableFooterView = self.footView;
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _repairTableView;
}
- (UIView *)addView {
    if (!_addView) {
        _addView = ({
            UIView * text = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40) adjustWidth:NO];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(200, 5, 30, 30), YES);
            [btn setImage:IMAGE_CONTENT(@"bean.png") forState:UIControlStateNormal];
            [text addSubview:btn];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(230, 0, 90, 40)adjustWidth:NO];
            
            label.text = @"添加内容";
            label.textColor = COLOR_RGB(69, 185, 228, 1);
            [text addSubview:label];
            text.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToAdd)];
            [text addGestureRecognizer:ges];
            text;
        });
    }
    return _addView;
}
- (UITextField *)sumTextField {
    if (!_sumTextField) {
        _sumTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 50, 320, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170, 40)adjustWidth:NO];
            NSInteger sum = [[NSUserDefaults standardUserDefaults]integerForKey:@"sum"];
            text.text = [NSString stringWithFormat:@"维修总计：%ld", (long)sum];;
            text.leftView = view;
            text.backgroundColor = [UIColor whiteColor];
            text.adjustsFontSizeToFitWidth = YES;
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _sumTextField;
}
- (UIView *)headView {
    if (!_headView) {
        _headView = ({
            UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80) adjustWidth:NO];
            [headView addSubview:self.repairTitle];
            [headView addSubview:self.repairPersonText];
            [headView addSubview:self.repairTimeTileLabel];
            [headView addSubview:self.repairTimeLabel];
            UIBezierPath * path = [UIBezierPath bezierPath];
            [self addLineWithYPosition:40 andWithPath:path];
            [self addLineWithYPosition:80 andWithPath:path];
            CAShapeLayer * layer = [CAShapeLayer layer];
            layer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 800), NO);
            layer.fillColor = [UIColor whiteColor].CGColor;
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
            layer.path = path.CGPath;
            [headView.layer addSublayer:layer];
            headView;
        });
    }
    return _headView;
}
- (UIView *)footView {
    if (!_footView) {
        _footView = ({
            UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100) adjustWidth:NO];
            [footView addSubview:self.addView];
            [footView addSubview:self.sumTextField];
            footView.backgroundColor = [UIColor clearColor];
            
            footView;
        });
    }
    return _footView;
}
@end
