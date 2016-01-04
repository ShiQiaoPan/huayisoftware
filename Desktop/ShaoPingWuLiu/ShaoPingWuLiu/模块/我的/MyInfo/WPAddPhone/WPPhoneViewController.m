//
//  WPPhoneViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/19.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPPhoneViewController.h"
#import "WPAddPhoneViewController.h"
#import "WPLinkModelViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPPhoneViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * phoneNums;
@property (nonatomic, strong) UILabel * introLabel;
@property (nonatomic, strong) UITableView * phoneNumTableView;
@property (nonatomic, strong) UIView * footView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */


@end

@implementation WPPhoneViewController

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
    hud.detailsLabelText = @"正在获取关联联系人";
    __weak typeof(self)weakself = self;
    
    [WPLinkModelViewModel getLinkModelWithSuccessBlock:^(NSDictionary *myInfo) {
        hud.labelText = @"获取联系人列表成功";
        if (myInfo.count == 0) {
            hud.detailsLabelText = @"尚未添加关联联系人";
        } else {
            hud.detailsLabelText = @"刷新中...";
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.phoneNums.count > 0) {
            [weakself.phoneNums removeAllObjects];
        }
        for (NSDictionary * dic in myInfo) {
            [weakself.phoneNums insertObject:dic atIndex:0];
        }
        [weakself.phoneNumTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"phoneNums" andWithData:weakself.phoneNums andWithReturnFlag:nil];
        [weakself.phoneNumTableView.mj_header endRefreshing];
        
    } failBlock:^(NSString *error) {
        hud.detailsLabelText = error;
        hud.labelText = @"获取联系人失败";
        [hud hide:YES afterDelay:2.0];
        [weakself.phoneNumTableView.mj_header endRefreshing];
    }];

}
- (void)initializeDataSource {
    self.phoneNums = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"phoneNums"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"关联号";
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.view addSubview:self.introLabel];
    [self.view addSubview:self.phoneNumTableView];
    __weak typeof(self)weakself = self;
    self.phoneNumTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
#pragma mark - responds events
- (void)respondsToFootView {
    WPAddPhoneViewController * VC = [[WPAddPhoneViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.phoneNums.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.phoneNums[indexPath.row][@"lname"];
    cell.detailTextLabel.text = self.phoneNums[indexPath.row][@"ltel"];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, 320, 1) adjustWidth:NO];
    line.backgroundColor = GARYTextColor;
    [cell.contentView addSubview:line];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44*DHFlexibleVerticalMutiplier();
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"删除联系人中";
    __weak typeof(self)weakself = self;
    [WPLinkModelViewModel deleteSingleLinkModelWithCardNum:self.phoneNums[indexPath.row][@"id"] SuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
        [weakself.phoneNums removeObjectAtIndex:indexPath.row];
        [weakself.phoneNumTableView reloadData];
    } failBlock:^(NSString *error) {
        hud.labelText = @"删除联系人失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
    
}

#pragma mark - getter
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 310, 30) adjustWidth:YES];
            label.textColor = COLOR_RGB(171, 172, 173, 1);
            label.text = @"与我关联的联系方式";
            label;
        });
    }
    return _introLabel;
}
- (UITableView *)phoneNumTableView {
    if (!_phoneNumTableView) {
        _phoneNumTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 110, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.backgroundColor = [UIColor clearColor];
            tableview.tableFooterView = self.footView;
            tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview;
        });
    }
    return _phoneNumTableView;
}
- (UIView *)footView {
    if (!_footView) {
        _footView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50/DHFlexibleHorizontalMutiplier()) adjustWidth:NO];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 50/DHFlexibleHorizontalMutiplier(), 320, 1) adjustWidth:NO];
            line.backgroundColor = GARYTextColor;
            [view addSubview:line];
            view.backgroundColor = [UIColor whiteColor];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 50) adjustWidth:NO];
            label.text = @"添加关联号";
            [view addSubview:label];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 10, 30, 30) adjustWidth:YES];
            imageView.image = IMAGE_CONTENT(@"bankAdd@2x.png");
            [view addSubview:imageView];
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToFootView)];
            [view addGestureRecognizer:ges];
            view;
        });
    }
    return _footView;
}
@end
