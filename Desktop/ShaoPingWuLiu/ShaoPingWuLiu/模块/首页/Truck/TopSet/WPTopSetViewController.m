//
//  TopSetViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/16.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTopSetViewController.h"
static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
@interface WPTopSetViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray * _topDatasource;
    NSMutableArray * _viewControlls;
}
@property (nonatomic, strong) UITableView * topTableView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPTopSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    _topDatasource = @[@[@"保养提醒"],
                       @[@"保险提醒",@"年审提醒"]];
    NSArray * arr = @[@"WPMaintenanceTopViewController", @"WPInsuranceTopViewController", @"ExamTopViewController"];
    _viewControlls = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrSecOne = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrSecTwo = [NSMutableArray arrayWithCapacity:0];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = NSClassFromString(obj);
        UIViewController * VC = [[class alloc]init];
        if (idx == 0) {
            [arrSecOne addObject:VC];
        } else {
            [arrSecTwo addObject:VC];
        }
    }];
    [_viewControlls addObject:arrSecOne];
    [_viewControlls addObject:arrSecTwo];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"提醒设置";
    [self.view addSubview:self.topTableView];
    
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _topDatasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_topDatasource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _topDatasource[indexPath.section][indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15 * DHFlexibleHorizontalMutiplier();
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44*DHFlexibleHorizontalMutiplier();
}

//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:_viewControlls[indexPath.section][indexPath.row] animated:YES];
}

#pragma mark - getter
- (UITableView *)topTableView {
    if (!_topTableView) {
        _topTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.scrollEnabled = NO;
            tableview.separatorColor = COLOR_RGB(192, 193, 194, 1);
            tableview;
        });
    }
    return _topTableView;
}

@end
