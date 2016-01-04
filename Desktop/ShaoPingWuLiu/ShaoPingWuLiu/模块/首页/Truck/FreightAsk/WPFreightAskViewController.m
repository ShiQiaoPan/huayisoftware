//
//  WPFreightAskViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/16.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPFreightAskViewController.h"
#import "WPDatePickView.h"
#import "WPFregihtCell.h"
#import "WPFreightAskViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPFreightAskViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) NSMutableArray * freightDataSource;
@property (nonatomic, strong) UIImageView * bgImage;
@property (nonatomic, strong) UITextField * searchText;
@property (nonatomic, strong) UIButton * dataBtn;
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) UITableView * fregihtTableView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */


@end

@implementation WPFreightAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
//    self.freightDataSource = [NSMutableArray arrayWithArray:@[@[@"2015-03-23", @"成都", @"1000.0", @"1000.0", @"1000.0", @"油卡已充值、转账完成"]]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"运费查询";
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.searchText];
    [self.view addSubview:self.dataBtn];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.fregihtTableView];
    [self.view addSubview:self.noDataImageView];
    __weak typeof(self)weakself = self;
    self.fregihtTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself respondsToSearchBtn];
    }];
}
#pragma mark - responds events
- (void)respondsToDataBtn {
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        self.searchText.text = destDateString;
    }];
}
- (void)respondsToSearchBtn {
    if (self.searchText.text.length == 0) {
        [self.fregihtTableView.mj_header endRefreshing];
        [self initializeAlertControllerWithMessageAndDismiss:@"请选择查询日期"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"查询中";
    __weak typeof(self)weakself = self;
    [WPFreightAskViewModel askFreshWithDate:self.searchText.text SuccessBlock:^(NSArray *freightArr) {
        hud.labelText = @"查询完成";
        hud.detailsLabelText = @"刷新中";
        [hud hide:YES afterDelay:1.0];
        weakself.freightDataSource = [NSMutableArray arrayWithArray:freightArr];
        if (weakself.noDataImageView.superview) {
            [weakself.noDataImageView removeFromSuperview];
        }
        [weakself.fregihtTableView reloadData];
        [weakself.fregihtTableView.mj_header endRefreshing];
    } andWithFailBlock:^(NSString *error) {
        hud.labelText = @"查询失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.fregihtTableView.mj_header endRefreshing];
    }];

}
#pragma mark - system protocol
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self respondsToDataBtn];
    return NO;
}
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.freightDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPFregihtCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPFregihtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * date = [self.freightDataSource[indexPath.section][@"yDate"] substringToIndex:10];
    cell.dataLabel.text = [NSString stringWithFormat:@"日期：%@", date];
    cell.addLabel.text = [NSString stringWithFormat:@"地点：%@", self.freightDataSource[indexPath.section][@"City"]];
    cell.fregihtText.text = [NSString stringWithFormat:@"%.1f", [self.freightDataSource[indexPath.section][@"yfTotal"] floatValue]];
    cell.oilCardText.text = [NSString stringWithFormat:@"%.1f", [self.freightDataSource[indexPath.section][@"jytotal"]floatValue]];
    cell.transferText.text = [NSString stringWithFormat:@"%.1f", [self.freightDataSource[indexPath.section][@"zzTotal"]floatValue]];
    cell.stateText.text = self.freightDataSource[indexPath.section][@"State"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView HeightForHeaderInSection:(NSInteger)section {
    return 10 * DHFlexibleVerticalMutiplier();
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120 * DHFlexibleHorizontalMutiplier();
}
#pragma mark - getter
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 74, 300, 40) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"CarSearchBg.png");
            view;
        });
    }
    return _bgImage;
}
- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80,  151*80/102) adjustWidth:YES];
            view.center = self.view.center;
            view.image = IMAGE_CONTENT(@"暂无信息null@2x.png");
            view;
        });
    }
    return _noDataImageView;
}
- (UITextField *)searchText {
    if (!_searchText) {
        _searchText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(20, 74, 290, 40) adjustWidth:NO];
            text.placeholder = @"请选择查询日期";
            text.delegate = self;
            text;
        });
    }
    return _searchText;
}
- (UIButton *)dataBtn {
    if (!_dataBtn) {
        _dataBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(200, 84, 30, 30), YES);
            [btn setImage:IMAGE_CONTENT(@"triangle.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToDataBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;

        });
    }
    return _dataBtn;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(240, 74, 70, 40), YES);
            [btn setTitle:@"查询" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToSearchBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _searchBtn;
}
- (UITableView *)fregihtTableView {
    if (!_fregihtTableView) {
        _fregihtTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 120, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = [UIColor clearColor];
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _fregihtTableView;
}
@end
