//
//  ExamTopViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/18.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "ExamTopViewController.h"
#import "WPAddExamTopViewController.h"
#import "WPCustomExamCell.h"
#import "WPAddExamViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface ExamTopViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) UITableView * examTableView;
@property (nonatomic, strong) NSMutableArray * examDataSource;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */

@end

@implementation ExamTopViewController

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
    [WPAddExamViewModel getAllExamTopWithSuccessBlock:^(NSArray *examArr) {
        hud.labelText = @"获取网络数据成功";
        if (examArr.count) {
            hud.detailsLabelText = @"刷新中...";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        } else {
            hud.detailsLabelText = @"没有年审记录";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.examDataSource.count > 0) {
            [weakself.examDataSource removeAllObjects];
        }
        for (id obj in examArr) {
            [weakself.examDataSource addObject:obj];
        }
        [weakself.examTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"examArr" andWithData:weakself.examDataSource andWithReturnFlag:nil];
        [weakself.examTableView.mj_header endRefreshing];
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"获取数据失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.examTableView.mj_header endRefreshing];
    }];
}
- (void)initializeDataSource {
    self.examDataSource = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"examArr"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"新增" forState:UIControlStateNormal];
    self.titleLable.text = @"年审提醒";
    [self.view addSubview:self.examTableView];
    if (self.examDataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    __weak typeof(self)weakself = self;
    self.examTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    WPAddExamTopViewController * VC = [[WPAddExamTopViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPCustomExamCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPCustomExamCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.examTitleLabel.text = [NSString stringWithFormat:@"年审%ld", (long)indexPath.section + 1];
    cell.examTimeLabel.text = [NSString stringWithFormat:@"年审日期：%@", self.examDataSource[indexPath.section][@"estarttime"]];
    cell.nextExamTimeText.text = self.examDataSource[indexPath.section][@"eendtime"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*DHFlexibleVerticalMutiplier();
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

- (UITableView *)examTableView {
    if (!_examTableView) {
        _examTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = [UIColor clearColor];
            tableview;
        });
    }
    return _examTableView;
}

@end
