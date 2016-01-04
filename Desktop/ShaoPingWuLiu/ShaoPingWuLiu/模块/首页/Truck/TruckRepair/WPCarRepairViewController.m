//
//  WPCarRepairViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/28.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPCarRepairViewController.h"
#import "WPTruckRepairViewModel.h"
#import "WPAddRepairViewController.h"

#define TXTColor COLOR_RGB(108, 109, 109, 1)
static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPCarRepairViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) UITableView * repairTableView;
@property (nonatomic, strong) NSMutableArray * repairDataSource;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */


@end

@implementation WPCarRepairViewController

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
    [WPTruckRepairViewModel getAllRepairRecordWithSuccessBlock:^(NSArray *repairArr) {
        hud.labelText = @"获取网络数据成功";
        if (repairArr.count) {
            hud.detailsLabelText = @"刷新中...";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        } else {
            hud.detailsLabelText = @"没有维修记录";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.repairDataSource.count > 0) {
            [weakself.repairDataSource removeAllObjects];
        }
        for (id obj in repairArr) {
            [weakself.repairDataSource addObject:obj];
        }
        [weakself.repairTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"repairArr" andWithData:weakself.repairDataSource andWithReturnFlag:nil];
        [weakself.repairTableView.mj_header endRefreshing];
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"获取网络数据失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.repairTableView.mj_header endRefreshing];
    }];
}
- (void)initializeDataSource {
    self.repairDataSource = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"repairArr"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"车辆维修";
    [self.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    [self.view addSubview:self.repairTableView];
    __weak typeof(self)weakself = self;
    if (self.repairDataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    self.repairTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    [self.navigationController pushViewController:[[WPAddRepairViewController alloc]init] animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.repairDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.repairDataSource[section][@"mcontents"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row+1,self.repairDataSource[indexPath.section][@"mcontents"][indexPath.row][@"servicecontent"]];
    cell.textLabel.textColor = TXTColor;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [self.repairDataSource[indexPath.section][@"mcontents"][indexPath.row][@"servicemoney"] floatValue]];
    cell.detailTextLabel.textColor = REDBGCOLOR;
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
     return [self configHeadViewWithIndex:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self configFootViewWithSection:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*DHFlexibleVerticalMutiplier();
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}
#pragma mark - private methods
- (UIView *)configHeadViewWithIndex:(NSInteger )section {
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100) adjustWidth:NO];
    headView.backgroundColor = [UIColor whiteColor];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40) adjustWidth:NO];
    view.backgroundColor = BGCOLOR;
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 40) adjustWidth:NO];
    lab.textColor = TXTColor;
    lab.text = [NSString stringWithFormat:@"维修记录%ld", section + 1];
    UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lab.frame)/DHFlexibleVerticalMutiplier(), 310, 30) adjustWidth:NO];
    lab1.textColor = TXTColor;
    lab1.text = [NSString stringWithFormat:@"维修人：%@", self.repairDataSource[section][@"serviceman"]];
    UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lab1.frame)/DHFlexibleVerticalMutiplier(), 310, 30) adjustWidth:NO];
    lab2.textColor = TXTColor;
    lab2.text = [NSString stringWithFormat:@"维修日期：%@", self.repairDataSource[section][@"ffdate"]];
    UIView * upview = [[UIView alloc]initWithFrame:CGRectMake(0, 99, 320, 1/DHFlexibleVerticalMutiplier()) adjustWidth:NO];
    upview.backgroundColor = COLOR_RGB(201, 202, 203, 1);
    [headView addSubview:upview];
    [headView addSubview:view];
    [headView addSubview:lab];
    [headView addSubview:lab1];
    [headView addSubview:lab2];
    return headView;
}
- (UIView *)configFootViewWithSection:(NSInteger)section {
    UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 1, 320, 40/DHFlexibleVerticalMutiplier()) adjustWidth:NO];
    text.leftViewMode = UITextFieldViewModeAlways;
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 40)adjustWidth:NO];
    lab.text = @"维修总计：";
    lab.textColor = TXTColor;
    lab.textAlignment = NSTextAlignmentRight;
    text.text = [NSString stringWithFormat:@"%.2f", [self.repairDataSource[section][@"amount"]floatValue]];
    text.leftView = lab;
    text.adjustsFontSizeToFitWidth = YES;
    text.userInteractionEnabled = NO;
    text.textColor = REDBGCOLOR;
    text.text = [NSString stringWithFormat:@"%.2f", [self.repairDataSource[section][@"amount"] floatValue]];
    text.backgroundColor = [UIColor whiteColor];
    UIView * upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1/DHFlexibleVerticalMutiplier()) adjustWidth:NO];
    upview.backgroundColor = COLOR_RGB(201, 202, 203, 1);
    [text addSubview:upview];
    return text;
}
#pragma mark - getter
- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, ORIGIN_HEIGHT - 64) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"暂无信息@2x.png");
            view;
        });
    }
    return _noDataImageView;
}
- (UITableView *)repairTableView {
    if (!_repairTableView) {
        _repairTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH, ORIGIN_HEIGHT - 64), NO) style:UITableViewStyleGrouped];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = [UIColor clearColor];
            tableview.backgroundColor = [UIColor clearColor];
            tableview.showsHorizontalScrollIndicator = NO;
            tableview.showsVerticalScrollIndicator = NO;
            tableview;
        });
    }
    return _repairTableView;
}



@end
