//
//  WPOrderManagerViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPOrderManagerViewController.h"
#import "RYOrder1TableViewCell.h"
#import "RYOrder2TableViewCell.h"
#import "RYCommentViewController.h"
#import "RYsecHeadView.h"
#import "NetWorkingManager+OrderManager.h"
#import "RYUnfinishedOrderModel.h"
#import "RYFinishedWaybillModel.h"

#define iSpace 10

@interface WPOrderManagerViewController ()
<UITableViewDataSource, UITableViewDelegate, OrderSectionDelegate, WayBillTrackingDelegate, CancelBillDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView       *thyScrollView;
@property (nonatomic, strong) UITableView        *leftTableView;   /**< 左表   */
@property (nonatomic, strong) UITableView        *rightTableView;  /**< 右表   */
@property (nonatomic, strong) UIView             *leftFooterView;  /**< 左表尾 */
@property (nonatomic, strong) UIView             *rightFooterView; /**< 右表尾 */


- (void)initializeDataSource;    /**< 初始化数据源   */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPOrderManagerViewController {
    NSMutableArray  *_leftDataArray;    /**< 未完成订单数据  */
    NSMutableArray  *_rightDataArray;   /**< 未完成订单数据  */
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
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
    self.titleLable.text      = @"订单管理";
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.thyScrollView];
}

- (void) loadData {
    [NetWorkingManager getOrderComplete:self.thyScrollView.contentOffset.x SuccessHandler:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if (!self.thyScrollView.contentOffset.x) {
            _leftDataArray = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"datas"]) {
                RYUnfinishedOrderModel *model = [RYUnfinishedOrderModel new];
                [model setValuesForKeysWithDictionary:dict];
                [_leftDataArray addObject:model];
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
            NSInteger index = 0;
            for (NSDictionary *dict in responseObject[@"datas"]) {
                RYFinishedOrderModel *model = [RYFinishedOrderModel new];
                [model setValuesForKeysWithDictionary:dict];
                NSMutableArray *waybillArray = [NSMutableArray array];
                for (NSDictionary *tDict in dict[@"yd"]) {
                    RYFinishedWaybillModel *tModel = [RYFinishedWaybillModel new];
                    [tModel setValuesForKeysWithDictionary:tDict];
                    [waybillArray addObject:tModel];
                }
                RYsecHeadView *sV = [[RYsecHeadView alloc] initSecHeadViewWithOrderModel:model];
                sV.sectionIndex   = index;
                sV.delegate       = self;
                sV.waybills       = [waybillArray copy];
                sV.flexibleButton.selected = NO;
                [_rightDataArray addObject:sV];
                index++;
            }
            if (!_rightDataArray.count) {
                self.rightTableView.tableFooterView = self.rightFooterView;
            }
            else {
                self.rightTableView.tableFooterView = nil;
            }
            [self.rightTableView reloadData];
            [self stopRightRefreshing];
        }
    } failureHandler:^(NSError *error) {
        NSLog(@"%@", error);
        [self stopRefreshing];
    }];
}
#pragma mark - respond events
- (void)respondsToSegmentControl:(UISegmentedControl *)sender {
    self.thyScrollView.contentOffset = CGPointMake(sender.selectedSegmentIndex * self.thyScrollView.frame.size.width, 0);
    [self loadData];
    [self stopRefreshing];
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

#pragma mark - delegates
- (void)orderSectionFlexibleButClickedWithIndex:(NSInteger)index {
    RYsecHeadView *sV = _rightDataArray[index];
    sV.flexibleButton.selected = !sV.flexibleButton.selected;
    [sV.flexibleButton setImage:[UIImage imageNamed:sV.flexibleButton.selected ? @"order_up.png" : @"order_down.png"] forState:UIControlStateNormal];
    [_rightTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
}
- (void) orderSectionCommentButClickedWithModel:(RYFinishedOrderModel *)model {
    RYCommentViewController *cVC = [RYCommentViewController new];
    cVC.model                    = model;
    [self.navigationController pushViewController:cVC animated:YES];
}

- (void) respondsToWaybillTrackingButtonWithModel:(RYFinishedWaybillModel *)model {
    
    // 此处写追踪的方法；
    NSLog(@"Attention:Waybill tracking ! ! !");
}
- (void)cancelBillButtonClickedWithModel:(RYUnfinishedOrderModel *)model {
    // 此处写取消订单的方法；
    [self initializeAlertControllerWithMessage:@"确定取消这条订单吗" withHandelBlock:^(id action) {
        [NetWorkingManager cancelOrderWithOrderId:model.orderid SuccessHandler:^(id responseObject) {
            NSLog(@"提交取消");
            NSLog(@"%@", responseObject);
            NSLog(@"%@", responseObject[@"errMsg"]);
            if ([responseObject[@"code"] isEqual:@0]) {
//                [self initializeAlertControllerWithMessage:@"取消订单成功"];
                NSLog(@"取消订单成功");
            }
            else {
                [self initializeAlertControllerWithMessage:@"取消订单失败"];
                NSLog(@"取消订单失败");
            }
        } failureHandler:^(NSError *error) {
            NSLog(@"Error：%@", error);
        }];
    }];
    
    NSLog(@"Attention:Bill Cancel ! ! ! !");
}

#pragma mark - tableView delegate methods
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        RYsecHeadView *sV = _rightDataArray[section];
        return sV;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) { return 120;}
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - tableView 代理回调方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _leftTableView) { return 1;}
    else if (tableView == _rightTableView) { return _rightDataArray.count;}
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) { return _leftDataArray.count;}
    else if (tableView == _rightTableView) {
        RYsecHeadView *sV = _rightDataArray[section];
        return sV.size;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) { return 120;}
    else if (tableView == _rightTableView) { return 90;}
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        NSString *identifer = @"OrderCell1";
        RYOrder1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RYOrder1TableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate       = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:_leftDataArray[indexPath.row]];
        return cell;
    }
    else if (tableView == _rightTableView) {
        NSString *identifer = @"OrderCell2";
        RYOrder2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RYOrder2TableViewCell" owner:self options:nil] lastObject];
        }
        RYsecHeadView *secV = _rightDataArray[indexPath.section];
        [cell setModel:secV.waybills[indexPath.row]];
        cell.delegate       = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark - getter
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = ({
            UISegmentedControl * control = [[UISegmentedControl alloc]initWithItems:@[@"未完成", @"已完成"]];
            control.frame = DHFlexibleFrame(CGRectMake(iSpace, 74, 300, 30), YES);
            control.tintColor            = REDBGCOLOR;
            control.selectedSegmentIndex = 0;
            [control addTarget:self action:@selector(respondsToSegmentControl:) forControlEvents:UIControlEventValueChanged];
            control.selectedSegmentIndex = 0;
            NSDictionary *dic            = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
            [control setTitleTextAttributes:dic forState:UIControlStateNormal];
            control;
        });
    }
    return _segmentedControl;
}

- (UIScrollView *)thyScrollView {
    if (!_thyScrollView) {
        _thyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + iSpace, SCREEN_SIZE.width * 2, SCREEN_SIZE.height - CGRectGetMaxY(self.segmentedControl.frame) - iSpace)];
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
            [self loadData];
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
            [self loadData];
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

@end
