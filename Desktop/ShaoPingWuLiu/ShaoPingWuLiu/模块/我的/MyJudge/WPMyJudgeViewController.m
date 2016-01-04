//
//  WPMyJudgeViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMyJudgeViewController.h"
#import "RYJudgeTableViewCell.h"
#import "NetWorkingManager+MyJudge.h"
#import "RYMyJudgeModel.h"

@interface WPMyJudgeViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *thyTableView; /**< 表 */
- (void)initializeDataSource;    /**< 初始化数据源   */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPMyJudgeViewController {
    NSMutableArray *_dataArray;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataArray = [NSMutableArray new];
    [NetWorkingManager getMyJudgeSuccessHandler:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"datas"]) {
            RYMyJudgeModel *model = [RYMyJudgeModel new];
            [model setValuesForKeysWithDictionary:dict];
            [model setValuesForKeysWithDictionary:[dict[@"reply"] firstObject]];
            [_dataArray addObject:model];
        }
        if (!_dataArray.count) {
            [self initializeAlertControllerWithMessage:@"暂无评论"];
        }
        [self.thyTableView reloadData];
    } failureHandler:^(NSError *error) {
    }];
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
    self.titleLable.text = @"我的评价";
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.thyTableView];
}
- (UITableView *)thyTableView {
    if (!_thyTableView) {
        _thyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.baseNavigationBar.frame.size.height, SCREEN_SIZE.width, SCREEN_SIZE.height - self.baseNavigationBar.frame.size.height) style:UITableViewStylePlain];
        _thyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _thyTableView.delegate       = self;
        _thyTableView.dataSource     = self;
    }
    return _thyTableView;
}

#pragma mark - tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier       = @"judgeCell";
    RYJudgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RYJudgeTableViewCell" owner:self options:nil] lastObject];
    }
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}
@end
