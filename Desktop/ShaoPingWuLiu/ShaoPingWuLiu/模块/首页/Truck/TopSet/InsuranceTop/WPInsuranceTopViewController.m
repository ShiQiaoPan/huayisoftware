//
//  WPInsuranceTopViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPInsuranceTopViewController.h"
#import "WPAddInsTopViewController.h"
#import "WPCustomInsureCell.h"
#import "WPInsureViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPInsuranceTopViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) NSMutableArray * insureDataSource;
@property (nonatomic, strong) UITableView * insureTableView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */



@end

@implementation WPInsuranceTopViewController

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
    [WPInsureViewModel getAllInsuranceWithSuccessBlock:^(NSArray *insuranceArr) {
        hud.labelText = @"获取网络数据成功";
        if (insuranceArr.count == 0) {
            hud.detailsLabelText = @"没有保险记录";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        } else {
            hud.detailsLabelText = @"刷新中...";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.insureDataSource.count > 0) {
            [weakself.insureDataSource removeAllObjects];
        }
        for (id obj in insuranceArr) {
            [weakself.insureDataSource addObject:obj];
        }
        [weakself.insureTableView reloadData];
        [weakself.insureTableView.mj_header endRefreshing];
        [UserDataStoreModel saveUserDataWithDataKey:@"insureArr" andWithData:weakself.insureDataSource andWithReturnFlag:nil];
        
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"获取网络数据失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.insureTableView.mj_header endRefreshing];
    }];

}
- (void)initializeDataSource {
    self.insureDataSource = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"insureArr"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    self.titleLable.text = @"保险提醒";
    [self.view addSubview:self.insureTableView];
    if (self.insureDataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    __weak typeof(self)weakself = self;
    self.insureTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    [self.navigationController pushViewController:[[WPAddInsTopViewController alloc]init] animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.insureDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPCustomInsureCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPCustomInsureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.insureTitleLabel.text = [NSString stringWithFormat:@"保险%ld", (long)indexPath.section + 1];
    cell.insureBuyTimeLabel.text = [NSString stringWithFormat:@"购买日期：%@", self.insureDataSource[indexPath.section][@"starttime"]];
    cell.insureCountText.text = [NSString stringWithFormat:@"%.2f",[self.insureDataSource[indexPath.section][@"insurance"] floatValue]];
    cell.insureDetailLabel.text = [NSString stringWithFormat:@"保险内容：%@", self.insureDataSource[indexPath.section][@"details"]];
    cell.insureStartTimeLabel.text = [NSString stringWithFormat:@"保险开始日期：%@", self.insureDataSource[indexPath.section][@"istarttime"]];
    cell.insureEndTimeLabel.text = [NSString stringWithFormat:@"保险结束日期：%@", self.insureDataSource[indexPath.section][@"iendtime"]];
    cell.nextInsureTimeText.text = self.insureDataSource[indexPath.section][@"remindtime"];
    return cell;

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240*DHFlexibleVerticalMutiplier();
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

- (UITableView *)insureTableView {
    if (!_insureTableView) {
        _insureTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview;
        });
    }
    return _insureTableView;
}

@end
