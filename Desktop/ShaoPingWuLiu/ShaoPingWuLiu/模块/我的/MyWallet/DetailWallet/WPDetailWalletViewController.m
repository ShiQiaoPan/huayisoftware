//
//  WPDetailWalletViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/13.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPDetailWalletViewController.h"
#import "WPDatePickView.h"
#import "WPWalletDetailViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPDetailWalletViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) UIImageView * searchImage;
@property (nonatomic, strong) UITextField * searchText;
@property (nonatomic, strong) UIButton * timeBtn;
@property (nonatomic, strong) UITableView * deatailTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) MJRefreshAutoFooter * footer;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshWalletDetails;

@end

@implementation WPDetailWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    self.dataSource = [NSMutableArray arrayWithArray: [UserDataStoreModel readUserDataWithDataKey:@"walletDetail"]];
}
- (void)refreshWalletDetails {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"获取明细列表中";
    __weak typeof(self)weakself = self;
    [WPWalletDetailViewModel getAllWalletDateWitSuccessBlock:^(NSArray *detailArr) {
        hud.labelText = @"查询成功";
        detailArr = nil;
        if (detailArr.count) {
            hud.detailsLabelText = @"刷新中";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        } else {
            hud.detailsLabelText = @"暂无钱包明细";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.dataSource.count > 0) {
            [weakself.dataSource removeAllObjects];
        }
        for (NSDictionary * dic in detailArr) {
            [weakself.dataSource addObject:dic];
        }
        [UserDataStoreModel saveUserDataWithDataKey:@"walletDetail" andWithData:weakself.dataSource andWithReturnFlag:nil];
        [weakself.deatailTableView reloadData];
        [weakself.deatailTableView.mj_header endRefreshing];
    } failBlock:^(NSString *error) {
        hud.labelText = @"查询失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.deatailTableView.mj_header endRefreshing];
    }];
}
- (void)initializeUserInterface {
    self.titleLable.text = @"钱包明细";
    [self.rightButton removeFromSuperview];
    self.view.backgroundColor = BGCOLOR;
    [self.view addSubview:self.searchImage];
    [self.view addSubview:self.searchText];
    [self.view addSubview:self.timeBtn];
    [self.view addSubview:self.deatailTableView];
    __weak typeof(self)weakself = self;
    if (self.dataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    self.deatailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshWalletDetails];
    }];
     [self.deatailTableView.mj_header beginRefreshing];
}
#pragma mark - responds events
- (void)respondsToTimeBtn:(UIButton *)sender {
    if (self.searchText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请输入查询的类型"];
        return;
    }
    sender.selected = !sender.selected;
    [self.view endEditing:YES];
    __weak typeof(self)weakself = self;
    [WPDatePickView showViewWithTitle:@"日期选择" datePickerMode:UIDatePickerModeDate maxDate:nil minDate:nil complete:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * destDateString = [dateFormatter stringFromDate:date];
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor grayColor];
        hud.labelText = @"请稍候";
        hud.detailsLabelText = @"查询中";
        [WPWalletDetailViewModel getMyWalletDetailWithTradetype:weakself.searchText.text date:destDateString SuccessBlock:^(NSArray *myWallet) {
            hud.labelText = @"获取成功";
            if (myWallet.count) {
                hud.detailsLabelText = @"刷新中";
            } else {
                hud.detailsLabelText = @"没有钱包明细";
            }
            [hud hide:YES afterDelay:1.0];
            if (weakself.dataSource.count > 0) {
                [weakself.dataSource removeAllObjects];
            }
            for (id obj in myWallet) {
                [weakself.dataSource addObject:obj];
            }
            [weakself.deatailTableView reloadData];
            
        } failBlock:^(NSString *error) {
            hud.labelText = @"查询失败";
            hud.detailsLabelText = error;
            [hud hide:YES afterDelay:2.0];
        }];
    }];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kUITableViewCellIdentifier];
    }
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = self.dataSource[indexPath.row][@"time"];
    cell.textLabel.text = self.dataSource[indexPath.row][@"tradetype"];
    UILabel * payLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.contentView.frame)*DHFlexibleHorizontalMutiplier()-100, 0, 90, CGRectGetHeight(cell.bounds))];
    payLab.text = self.dataSource[indexPath.row][@"money"];
    payLab.textColor = REDBGCOLOR;
    payLab.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:payLab];
    cell.backgroundColor = COLOR_RGB(249, 250, 251, 1);
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30) adjustWidth:YES];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"下拉查看更多....";
    return label;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 4) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - refresh data

#pragma mark - getter
- (UIImageView *)searchImage {
    if (!_searchImage) {
        _searchImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 70, 300, 30) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"searchkuang@2x.png");
            view;
        });
    }
    return _searchImage;
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
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(40, 70, 200, 30) adjustWidth:NO];
            text.placeholder =  @"(充值、提现、优惠劵)";
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.returnKeyType = UIReturnKeyDone;
            text.delegate = self;
            text.adjustsFontSizeToFitWidth = YES;
            text;
        });
    }
    return _searchText;
}
- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(255, 75, 45, 15), NO);
            [btn setImage:IMAGE_CONTENT(@"down@2x.png") forState:UIControlStateNormal];
            [btn setTintColor:BGCOLOR];
            [btn addTarget:self action:@selector(respondsToTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _timeBtn;
}
- (UITableView *)deatailTableView {
    if (!_deatailTableView) {
        _deatailTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 100, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.pagingEnabled = NO;
            tableview.separatorColor = GARYTextColor;
            tableview.backgroundColor = [UIColor clearColor];
            tableview.tableFooterView = [UIView new];
            tableview;
        });
    }
    return _deatailTableView;
}

@end