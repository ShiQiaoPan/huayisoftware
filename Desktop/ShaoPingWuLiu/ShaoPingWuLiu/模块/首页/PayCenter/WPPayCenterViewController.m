//
//  WPPayCenterViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPPayCenterViewController.h"
#import "RYPayWaybillTableViewCell.h"
#import "RYPayOrderTableViewCell.h"
#import "NetWorkingManager+PayCenter.h"
#import "RYPayBillModel.h"
#import "RYPayWaybillModel.h"
#import "RYPayBillView.h"
#import "RYPayBillFootView.h"

#define oSpace 10

@interface WPPayCenterViewController ()
<UITableViewDataSource, UITableViewDelegate, PayWaybillDelegate, PayBillDelegate, RYBillPayingDelegate>
@property (nonatomic, strong) UISegmentedControl *segmentedControl; /**< 分段控件 */
@property (nonatomic, strong) UIScrollView       *thyScrollView;    /**< 滚动视图 */
@property (nonatomic, strong) UITableView        *leftTableView;    /**< 左表    */
@property (nonatomic, strong) UITableView        *rightTableView;   /**< 右表    */
@property (nonatomic, strong) UIView             *leftFooterView;   /**< 左表尾 */
@property (nonatomic, strong) UIView             *rightFooterView;  /**< 右表尾 */

- (void)initializeDataSource;    /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPPayCenterViewController {
    NSMutableArray *_leftDataArray;
    NSMutableArray *_leftFootArray;
    NSMutableArray *_rightDataArray;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"付款中心";
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.thyScrollView];
}
#pragma mark - loadData
- (void) loadDataModel {
    [NetWorkingManager getBillsIsWayBill:self.thyScrollView.contentOffset.x SuccessHandler:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if (!self.thyScrollView.contentOffset.x) {
            _leftDataArray = [NSMutableArray array];
            _leftFootArray = [NSMutableArray array];
            NSInteger index = 0;
            for (NSDictionary *dict in responseObject[@"datas"]) {
                RYPayBillModel *model = [RYPayBillModel new];
                [model setValuesForKeysWithDictionary:dict];
                model.totalMoney      = [NSString stringWithFormat:@"%f", [dict[@"carriage"] floatValue] + [dict[@"proxycarriage"] floatValue]];
                NSMutableArray *waybillArray = [NSMutableArray array];
                for (NSDictionary *tDict in dict[@"yd"]) {
                    model.totalMoney = [NSString stringWithFormat:@"%f", [tDict[@"TotalAmount"] floatValue] + [tDict[@"DSMoney"] floatValue] + [model.totalMoney floatValue]];
                    RYPayBillWaybillModel *wModel = [RYPayBillWaybillModel new];
                    [wModel setValuesForKeysWithDictionary:tDict];
                    [waybillArray addObject:wModel];
                }
                RYPayBillView *secHV  = [[RYPayBillView alloc] initSecHeadViewWithOrderModel:model];
                secHV.sectionIndex    = index;
                secHV.waybills        = [waybillArray copy];
                secHV.delegate        = self;
                [_leftDataArray addObject:secHV];
                RYPayBillFootView *footV = [[RYPayBillFootView alloc] initSecFootViewWithOrderModel:model];
                footV.sectionIndex    = index;
                footV.delegate        = self;
                [_leftFootArray addObject:footV];
                index++;
            }
            if (!_leftDataArray.count) {
                self.leftTableView.tableFooterView = self.leftFooterView;
            }
            else {
                self.leftTableView.tableFooterView = nil;
            }
            [self.leftTableView reloadData];
            [self stopLeftRefreshing];
        }
        else {
            _rightDataArray = [NSMutableArray array];
            NSLog(@"tu le");
//            if (!_rightDataArray.count) {
//                self.rightTableView.tableFooterView = self.rightFooterView;
//            }
//            else {
//                self.rightTableView.tableFooterView = nil;
//            }
//            [self.rightTableView reloadData];
//            [self stopRightRefreshing];
        }
    } failureHandler:^(NSError *error) {
        NSLog(@"%@", error);
        [self stopRefreshing];
    }];
}

#pragma mark - responds events
- (void)respondsToSegmentControl:(UISegmentedControl *)sender {
    self.thyScrollView.contentOffset = CGPointMake(sender.selectedSegmentIndex * self.thyScrollView.frame.size.width, 0);
    
    
}
#pragma mark - delegete
- (void)payBillWithOrderModel:(RYPayBillModel *)model {
    [self initializeAlertControllerWithMessage:@"Attention:You Will Pay Order ! ! !"];
}
- (void) payBillWithMoney:(NSInteger)moeny {
    NSLog(@"Attention:You Will Pay   ¥%lu ! ! !", moeny);
    [self initializeAlertControllerWithMessage:[NSString stringWithFormat:@"Attention:You Will Pay   ¥%lu ! ! !", moeny]];
}
- (void) trackingBill {
    [self initializeAlertControllerWithMessage:@"Attention:You Will Track Bill ! ! !"];
    NSLog(@"Attention:You Will Track Bill ! ! !");
}
- (void) flexibleWayBillWithBillIndex:(NSInteger)index {
    RYPayBillView *secV = _leftDataArray[index];
    secV.flexibleButton.selected = !secV.flexibleButton.selected;
    [secV.flexibleButton setImage:[UIImage imageNamed:secV.flexibleButton.selected ? @"order_up.png" : @"order_down.png"] forState:UIControlStateNormal];
    [_leftTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - tableView delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) { return 110.0f;}
    else if (tableView == self.rightTableView) { return 205.0f; }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 90.0f;
    }
    else if (tableView == self.rightTableView) {
        return 0.0f;
    }
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 30.0f;
    }
    return 0.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        RYPayBillFootView *footV = _leftFootArray[section];
        return footV;
    }
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        RYPayBillView *secHV = _leftDataArray[section];
        return secHV;
    }
    return nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) { return _leftDataArray.count;}
    else if (tableView == self.rightTableView) { return 1;}
    return 0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        RYPayBillView *secHV = _leftDataArray[section];
        return secHV.size;
    }
    else if (tableView == self.rightTableView) { return 5;}
    return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        NSString *identifier          = @"payOrderBill";
        RYPayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RYPayOrderTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RYPayBillView *seHV = _leftDataArray[indexPath.section];
        [cell setModel:seHV.waybills[indexPath.row]];
        return cell;
    }
    else if (tableView == self.rightTableView) {
        NSString *identifier            = @"payWaybill";
        RYPayWaybillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RYPayWaybillTableViewCell" owner:self options:nil] lastObject];
        }
        
        [cell setModel:nil];
        cell.delegate       = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
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

#pragma mark - getter
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = ({
            UISegmentedControl * control = [[UISegmentedControl alloc]initWithItems:@[@"订单支付", @"运单支付"]];
            control.frame = DHFlexibleFrame(CGRectMake(10, 74, 300, 35), YES);
            control.tintColor = REDBGCOLOR;
            control.selectedSegmentIndex = 0;
            [control addTarget:self action:@selector(respondsToSegmentControl:) forControlEvents:UIControlEventValueChanged];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f],NSFontAttributeName ,nil];
            [control setTitleTextAttributes:dic forState:UIControlStateNormal];
            control;
        });
    }
    return _segmentedControl;
}
- (UIScrollView *)thyScrollView {
    if (!_thyScrollView) {
        _thyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + oSpace, SCREEN_SIZE.width, SCREEN_SIZE.height - CGRectGetMaxY(self.segmentedControl.frame) - oSpace)];
        _thyScrollView.scrollEnabled = NO;
        _thyScrollView.contentSize   = CGSizeMake(_thyScrollView.frame.size.width * 2, _thyScrollView.frame.size.height);
        _thyScrollView.contentOffset = CGPointMake(0, 0);
        [_thyScrollView addSubview:self.leftTableView];
        [_thyScrollView addSubview:self.rightTableView];
    }
    return _thyScrollView;
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.thyScrollView.frame.size.width, self.thyScrollView.frame.size.height)];
        _leftTableView.dataSource     = self;
        _leftTableView.delegate       = self;
        _leftTableView.mj_header      = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_leftTableView.mj_header beginRefreshing];
            [self loadDataModel];
        }];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;

    }
    return _leftTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.thyScrollView.frame.size.width, 0, self.thyScrollView.frame.size.width, self.thyScrollView.frame.size.height)];
        _rightTableView.dataSource     = self;
        _rightTableView.delegate       = self;
        _rightTableView.mj_header      = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_rightTableView.mj_header beginRefreshing];
            [self loadDataModel];
        }];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.showsVerticalScrollIndicator = NO;
    }
    return _rightTableView;
}

- (UIView *)leftFooterView {
    if (!_leftFooterView) {
        _leftFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftTableView.frame.size.width, 30)];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _leftFooterView.frame.size.width, _leftFooterView.frame.size.height)];
        la.text            = @"暂无数据";
        la.font            = [UIFont systemFontOfSize:14.0f];
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
        la.text            = @"暂无数据";
        la.font            = [UIFont systemFontOfSize:14.0f];
        la.textColor       = [UIColor whiteColor];
        la.textAlignment   = NSTextAlignmentCenter;
        la.backgroundColor = REDBGCOLOR;
        [_rightFooterView addSubview:la];
        
    }
    return _rightFooterView;
}


@end
