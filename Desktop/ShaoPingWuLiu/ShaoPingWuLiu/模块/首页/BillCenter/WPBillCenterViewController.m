//
//  WPBillCenterViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBillCenterViewController.h"
#import "RYBillTableViewCell.h"
#import "NetWorkingManager+BillCenter.h"
#import "RYReceivingCargoModel.h"

#define nSpace     10.0f
#define nTitFont   16.0f
#define nNorFont   14.0f
#define nLabHeight 30.0f

@interface WPBillCenterViewController ()
<UITableViewDataSource, UITableViewDelegate, BillTrackingDelegate>

@property (nonatomic, strong) UISegmentedControl *thySegControl;   /**< 分段控件 */
@property (nonatomic, strong) UIScrollView       *thyScrollView;   /**< 滚动时图 */
@property (nonatomic, strong) UITableView        *leftTableView;   /**< 左表    */
@property (nonatomic, strong) UITableView        *rightTableView;  /**< 右表    */
@property (nonatomic, strong) UIView             *leftFooterView;  /**< 左表尾  */
@property (nonatomic, strong) UIView             *rightFooterView; /**< 右表尾  */
@property (nonatomic, strong) UIView             *thyTotalView;    /**< 汇总    */
@property (nonatomic, strong) UILabel            *leftLabel;       /**< 标题:   */
@property (nonatomic, strong) UILabel            *rightLabel;      /**< 运费:   */
@property (nonatomic, strong) UILabel            *ryTitleLabel;    /**< 标题    */
@property (nonatomic, strong) UILabel            *freightLabel;    /**< 运费    */
@property (nonatomic, strong) UILabel            *agencyFundLabel; /**< 代收款  */

- (void)initializeDataSource;    /**< 初始化数据源   */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPBillCenterViewController {
    NSMutableArray *_leftDataArray;
    NSMutableArray *_rightDataArray;
    float leftFreight;      /**< 左－运费   */
    float leftAgencyFund;   /**< 左－代收费  */
    float rightFreight;     /**< 右－运费   */
    float rightAgencyFund;  /**< 左－代收费  */
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
    [self initializeDataSource];
}
#pragma mark - init
- (void)initializeDataSource {
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text      = @"对账中心";
    [self.view addSubview:self.thySegControl];
    [self.view addSubview:self.thyTotalView];
    [self.view addSubview:self.thyScrollView];
}
#pragma mark - loadData
- (void) loadDataModel {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"查询中...";
    [NetWorkingManager getBillsWithBeginDate:self.beginDateString EndDate:self.endDateString ConsigneeTel:self.consigneeTele isReceiver:self.thyScrollView.contentOffset.x SuccessHandler:^(id responseObject) {
        hud.labelText = @"查询成功";
        if (!self.thyScrollView.contentOffset.x) {
            _leftDataArray = [NSMutableArray array];
            leftFreight = leftAgencyFund = 0.0f;
            if ([responseObject[@"datas"] count]) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    RYReceivingCargoModel *model = [RYReceivingCargoModel new];
                    [model setValuesForKeysWithDictionary:dict];
                    leftFreight    += [model.carriage floatValue];
                    leftAgencyFund += [model.proxycarriage floatValue];
                    [_leftDataArray addObject:model];
                }

            }
            if (!_leftDataArray.count) {
                hud.detailsLabelText = @"暂无数据";
                self.leftTableView.tableFooterView = self.leftFooterView;
            }
            else {
                hud.detailsLabelText = @"加载数据中...";
                self.leftTableView.tableFooterView = nil;
            }
            [hud hide:YES afterDelay:1.0];
            self.freightLabel.text = [NSString stringWithFormat:@"%.2f", leftFreight];
            self.agencyFundLabel.text = [NSString stringWithFormat:@"%.2f", leftAgencyFund];
            [self.leftTableView reloadData];
            [self stopLeftRefreshing];
        }
        else {
            rightFreight = rightAgencyFund = 0.0f;
            _rightDataArray = [NSMutableArray array];
            if ([responseObject[@"yd"] count]) {
                for (NSDictionary *dict in responseObject[@"yd"]) {
                    RYSendingCargoModel *model = [RYSendingCargoModel new];
                    [model setValuesForKeysWithDictionary:dict];
                    rightFreight    += [model.TotalAmount floatValue];
                    rightAgencyFund += [model.DSMoney floatValue];
                    [_rightDataArray addObject:model];
                }
            }
            if (!_rightDataArray.count) {
                hud.detailsLabelText = @"暂无数据";
                self.rightTableView.tableFooterView = self.rightFooterView;
            }
            else {
                hud.detailsLabelText = @"加载数据中...";
                self.rightTableView.tableFooterView = nil;
            }
            [hud hide:YES afterDelay:1.0];
            self.freightLabel.text = [NSString stringWithFormat:@"%.2f", rightFreight];
            self.agencyFundLabel.text = [NSString stringWithFormat:@"%.2f", rightAgencyFund];
            [self.rightTableView reloadData];
            [self stopRightRefreshing];
        }
        
    } FailureHandler:^(NSError *error) {
        hud.labelText = @"查询失败";
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:2.0];
        [self stopRefreshing];
    }];
}

#pragma mark - tableView delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return _leftDataArray.count;
    }
    else if (tableView == self.rightTableView) {
        return _rightDataArray.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 90.0f;
    }
    if (tableView == self.rightTableView) {
        return 90.0f;
    }
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier  = @"billCell";
    RYBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell              = [[[NSBundle mainBundle] loadNibNamed:@"RYBillTableViewCell" owner:self options:nil] lastObject];
    }
    cell.delegate         = self;
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    if (tableView == self.leftTableView) {
        [cell setBModel:_leftDataArray[indexPath.row]];
    }
    else if (tableView == self.rightTableView){
        [cell setCModel:_rightDataArray[indexPath.row]];
    }
    return cell;
}

#pragma mark -stop refresh
- (void) stopLeftRefreshing {
    if (self.leftTableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.leftTableView.mj_header endRefreshing];
    }
}
- (void) stopRightRefreshing {
    if (self.rightTableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.rightTableView.mj_header endRefreshing];
    }
}
- (void) stopRefreshing {
    [self stopLeftRefreshing];
    [self stopRightRefreshing];
}
#pragma mark - events resopnd 
- (void) respondsToSegmentControl:(UISegmentedControl *) sender {
    self.thyScrollView.contentOffset = CGPointMake(sender.selectedSegmentIndex * self.thyScrollView.frame.size.width, 0);
    self.freightLabel.text    = [NSString stringWithFormat:@"%.2f", self.thyScrollView.contentOffset.x ? rightFreight : leftFreight];
    self.agencyFundLabel.text = [NSString stringWithFormat:@"%.2f", self.thyScrollView.contentOffset.x ? rightAgencyFund : leftAgencyFund];
    [self loadDataModel];
    [self stopRefreshing];
}

- (void)billTrackingButtonClicked {
    NSLog(@"Attention: BillCenter tracking！！！！！");
    [self initializeAlertControllerWithMessage:@"Attention: BillCenter tracking!"];
}

#pragma mark - getter
- (UISegmentedControl *)thySegControl {
    if (!_thySegControl) {
        _thySegControl       = [[UISegmentedControl alloc] initWithItems:@[@"我发的货", @"我收的货"]];
        _thySegControl.frame = DHFlexibleFrame(CGRectMake(nSpace, 74, 300, nLabHeight), YES);
        _thySegControl.tintColor            = REDBGCOLOR;
        _thySegControl.selectedSegmentIndex = 0;
        [_thySegControl addTarget:self action:@selector(respondsToSegmentControl:) forControlEvents:UIControlEventValueChanged];
        _thySegControl.selectedSegmentIndex = 0;
        NSDictionary *dic    = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
        [_thySegControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    }
    return _thySegControl;
}

- (void) drawView {
    UIView *topV  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.thyTotalView.frame.size.width, 1)];
    UIView *botV  = [[UIView alloc] initWithFrame:CGRectMake(0, self.thyTotalView.frame.size.height - 1, self.thyTotalView.frame.size.width, 1)];
    topV.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    botV.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    [self.thyTotalView addSubview:topV];
    [self.thyTotalView addSubview:botV];
}

- (UIView *)thyTotalView {
    if (!_thyTotalView) {
        _thyTotalView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.thySegControl.frame) + nSpace, SCREEN_SIZE.width,  nLabHeight * 2 + nSpace * 2) adjustWidth:NO];
        _thyTotalView.backgroundColor = [UIColor whiteColor];
        [self drawView];
        [_thyTotalView addSubview:self.ryTitleLabel];
        [_thyTotalView addSubview:self.leftLabel];
        [_thyTotalView addSubview:self.freightLabel];
        [_thyTotalView addSubview:self.rightLabel];
        [_thyTotalView addSubview:self.agencyFundLabel];
    }
    return _thyTotalView;
}

- (UIScrollView *)thyScrollView {
    if (!_thyScrollView) {
        _thyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.thyTotalView.frame) + nSpace, SCREEN_SIZE.width * 2, SCREEN_SIZE.height - CGRectGetMaxY(self.thyTotalView.frame) - nSpace)];
        _thyScrollView.scrollEnabled = NO;
        _thyScrollView.contentOffset = CGPointMake(0, 0);
        _thyScrollView.contentSize   = CGSizeMake(_thyScrollView.frame.size.width * 2, _thyScrollView.frame.size.height);
        [_thyScrollView addSubview:self.leftTableView];
        [_thyScrollView addSubview:self.rightTableView];
    }
    return _thyScrollView;
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.thyScrollView.frame.size.height) style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate   = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_leftTableView.mj_header beginRefreshing];
            [self loadDataModel];
        }];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.thyScrollView.frame.size.width, 0, SCREEN_SIZE.width, self.thyScrollView.frame.size.height) style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate   = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_rightTableView.mj_header beginRefreshing];
            [self loadDataModel];
        }];
    }
    return _rightTableView;
}

- (UIView *)leftFooterView {
    if (!_leftFooterView) {
        _leftFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftTableView.frame.size.width, 30)];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _leftFooterView.frame.size.width, _leftFooterView.frame.size.height)];
        la.text     = @"暂无数据";
        la.font     = [UIFont systemFontOfSize:14.0f];
        la.textColor       = [UIColor whiteColor];
        la.textAlignment   = NSTextAlignmentCenter;
        la.backgroundColor = REDBGCOLOR;
        [_leftFooterView addSubview:la];
    }
    return _leftFooterView;
}

- (UIView *)rightFooterView {
    if (!_rightFooterView) {
        _rightFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rightTableView.frame.size.width, 30)];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _rightFooterView.frame.size.width, _rightFooterView.frame.size.height)];
        la.text     = @"暂无数据";
        la.font     = [UIFont systemFontOfSize:14.0f];
        la.textColor       = [UIColor whiteColor];
        la.textAlignment   = NSTextAlignmentCenter;
        la.backgroundColor = REDBGCOLOR;
        [_rightFooterView addSubview:la];
        
    }
    return _rightFooterView;
}

- (UILabel *)ryTitleLabel {
    if (!_ryTitleLabel) {
        _ryTitleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(nSpace, nSpace, self.thyTotalView.frame.size.width - nSpace * 2, nLabHeight)];
        _ryTitleLabel.text = @"汇总信息：";
        _ryTitleLabel.font = [UIFont systemFontOfSize:nTitFont];
    }
    return _ryTitleLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel      = [[UILabel alloc] initWithFrame:CGRectMake(self.ryTitleLabel.frame.origin.x, CGRectGetMaxY(self.ryTitleLabel.frame) + nSpace / 2, 45, nLabHeight)];
        _leftLabel.text = @"运费：";
        _leftLabel.font = [UIFont systemFontOfSize:nNorFont];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.thyTotalView.frame) / 2, self.leftLabel.frame.origin.y, 60, nLabHeight)];
        _rightLabel.text = @"代收款：";
        _rightLabel.font = [UIFont systemFontOfSize:nNorFont];
    }
    return _rightLabel;
}

- (UILabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftLabel.frame), self.leftLabel.frame.origin.y, 80, nLabHeight)];
        _freightLabel.text = @"0.00";
        _freightLabel.font = [UIFont systemFontOfSize:nNorFont];
        _freightLabel.textColor = REDBGCOLOR;
    }
    return _freightLabel;
}

- (UILabel *)agencyFundLabel {
    if (!_agencyFundLabel) {
        _agencyFundLabel      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rightLabel.frame), self.rightLabel.frame.origin.y, 80, nLabHeight)];
        _agencyFundLabel.text = @"0.00";
        _agencyFundLabel.font = [UIFont systemFontOfSize:nNorFont];
        _agencyFundLabel.textColor = REDBGCOLOR;
    }
    return _agencyFundLabel;
}

@end
