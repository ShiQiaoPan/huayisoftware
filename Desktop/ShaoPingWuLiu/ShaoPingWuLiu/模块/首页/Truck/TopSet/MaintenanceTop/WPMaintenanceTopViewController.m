//
//  WPMaintenanceTopViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMaintenanceTopViewController.h"
#import "WPAddMaintenanceTopViewController.h"
#import "WPCustomMaintenanceCell.h"
#import "WPMaintenanceViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPMaintenanceTopViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) NSMutableArray * maintenanceDataSource;
@property (nonatomic, strong) UITableView * maintenanceTableView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */



@end

@implementation WPMaintenanceTopViewController

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
    hud.detailsLabelText = @"刷新数据中";
    __weak typeof(self)weakself = self;
    [WPMaintenanceViewModel getAllMaintenaceWithSuccessBlock:^(NSArray *maintenanceArr) {
        maintenanceArr = nil;
        hud.labelText = @"获取网络数据成功";
        if (maintenanceArr.count == 0) {
            hud.detailsLabelText = @"没有保养记录";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        } else {
            hud.detailsLabelText = @"刷新中";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.maintenanceDataSource.count > 0) {
            [weakself.maintenanceDataSource removeAllObjects];
        }
        for (id obj in maintenanceArr) {
            [weakself.maintenanceDataSource addObject:obj];
        }
        [weakself.maintenanceTableView reloadData];
        [weakself.maintenanceTableView.mj_header endRefreshing];
        [UserDataStoreModel saveUserDataWithDataKey:@"maintenanceArr" andWithData:weakself.maintenanceDataSource andWithReturnFlag:nil];
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"刷新数据失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.maintenanceTableView.mj_header endRefreshing];
    }];

}
- (void)initializeDataSource {
    self.maintenanceDataSource = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"maintenanceArr"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    self.titleLable.text = @"保养提醒";
    [self.view addSubview:self.maintenanceTableView];
    if (self.maintenanceDataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    __weak typeof(self)weakself = self;
    self.maintenanceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    [self.navigationController pushViewController:[[WPAddMaintenanceTopViewController alloc]init] animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.maintenanceDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPCustomMaintenanceCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPCustomMaintenanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.maintencenanceTitleLabel.text = [NSString stringWithFormat:@"保养%ld", (long)indexPath.section+1];
    cell.maintencenanceTimeLabel.text = self.maintenanceDataSource[indexPath.section][@"mstarttime"];
    cell.maintencenanceText.text = [NSString stringWithFormat:@"%.2f", [self.maintenanceDataSource[indexPath.section][@"mamount"] floatValue]];
    cell.maintencenanceDetailLabel.text = [NSString stringWithFormat:@"保养内容：%@", self.maintenanceDataSource[indexPath.section][@"mcontent"]];
    cell.nextMaintenanceTimeText.text = self.maintenanceDataSource[indexPath.section][@"remindtime"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160*DHFlexibleVerticalMutiplier();
}

#pragma mark - getter
- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, ORIGIN_HEIGHT - 64) adjustWidth:NO];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80,  151*80/102) adjustWidth:YES];
            imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 64*DHFlexibleHorizontalMutiplier());
            imageView.image = IMAGE_CONTENT(@"暂无信息null@2x.png");
            [view addSubview:imageView];
            view;

        });
    }
    return _noDataImageView;
}

- (UITableView *)maintenanceTableView {
    if (!_maintenanceTableView) {
        _maintenanceTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = [UIColor clearColor];
            tableview;
        });
    }
    return _maintenanceTableView;
}


@end
