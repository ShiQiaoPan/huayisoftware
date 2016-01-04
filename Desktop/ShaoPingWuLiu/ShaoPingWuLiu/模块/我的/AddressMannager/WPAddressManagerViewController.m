//
//  WPAddressManagerViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/13.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAddressManagerViewController.h"
#import "WPAddAddressViewController.h"
#import "WPAddressCell.h"
#import "WPAddMangerViewModel.h"

static NSString * const kUITableViewCellIdentifier = @"cellIdentifier";
#define SETTAG 2000

@interface WPAddressManagerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISegmentedControl * segmentedControl;
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) UITableView * addressTableView;
@property (nonatomic, strong) NSMutableArray * postAddDataSource;
@property (nonatomic, strong) NSMutableArray * getAddDataSource;
@property (nonatomic, assign) NSInteger defaultIndex;/**< 默认地址的下标 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshSendAddress;/**< 更新发货地址 */
- (void)refreshReciveAddress;/**< 更新收货地址 */

@end

@implementation WPAddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isPost) {
        [self refreshSendAddress];
    } else {
        [self refreshReciveAddress];
    }
}
#pragma mark - init
- (void)refreshSendAddress {
    self.segmentedControl.selectedSegmentIndex = 0;
    __weak typeof(self)weakself = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"刷新发货地址中";
    [WPAddMangerViewModel getAllSendAddressWithSuccessBlock:^(NSArray *myInfo) {
        hud.labelText = @"获取网络数据成功";
        if (myInfo.count) {
            hud.detailsLabelText = @"刷新中...";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        } else {
            hud.detailsLabelText = @"尚未设置发货地址";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.postAddDataSource.count > 0) {
            [weakself.postAddDataSource removeAllObjects];
        }
        for (NSDictionary * dict in myInfo) {
            [weakself.postAddDataSource addObject:dict];
        }
        [UserDataStoreModel saveUserDataWithDataKey:@"postAddDataSource" andWithData:weakself.postAddDataSource andWithReturnFlag:nil];
        [weakself.addressTableView reloadData];
        [weakself.addressTableView.mj_header endRefreshing];
    } failBlock:^(NSString *error) {
        hud.labelText = @"刷新失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.addressTableView.mj_header endRefreshing];
    }];
}
- (void)refreshReciveAddress {
    __weak typeof(self)weakself = self;
    self.segmentedControl.selectedSegmentIndex = 1;
    [WPAddMangerViewModel getAllReciveAddressWithSuccessBlock:^(NSArray *myInfo) {
        if (myInfo.count) {
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        } else {
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        }
        if (self.getAddDataSource.count > 0) {
            [self.getAddDataSource removeAllObjects];
        }
        for (NSDictionary * dic in myInfo) {
            [weakself.getAddDataSource addObject:dic];
        }
        [weakself.addressTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"getAddDataSource" andWithData:weakself.getAddDataSource andWithReturnFlag:nil];
        [weakself.addressTableView.mj_header endRefreshing];
        
    } failBlock:^(NSString *error) {
        [weakself initializeAlertControllerWithMessageAndDismiss:[NSString stringWithFormat:@"刷新失败%@", error]];
        [weakself.addressTableView reloadData];
        [weakself.addressTableView.mj_header endRefreshing];
    }];
    
}
- (void)initializeDataSource {
    self.defaultIndex = 0;
    self.postAddDataSource = [NSMutableArray arrayWithArray: [UserDataStoreModel readUserDataWithDataKey:@"postAddDataSource"]];
    self.getAddDataSource = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"getAddDataSource"]];
}

- (void)initializeUserInterface {
    self.titleLable.text = @"地址管理";
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.addressTableView];
    if (self.postAddDataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    __weak typeof(self)weakself = self;
    self.addressTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.isPost) {
            [weakself refreshSendAddress];
        } else {
            [weakself refreshReciveAddress];
        }
    }];
}
#pragma mark - responds events
- (void)respondsToNavBarRightButton:(UIButton *)sender {
    WPAddAddressViewController * addADVC = [[WPAddAddressViewController alloc]init];
    addADVC.addIndex = self.segmentedControl.selectedSegmentIndex;
    [self.navigationController pushViewController:addADVC animated:YES];
}
- (void)respondsToSegmentControl:(UISegmentedControl *)sender {
    self.isPost = !self.isPost;
    if (self.isPost) {
        [self.addressTableView reloadData];
        if (self.postAddDataSource.count) {
            if (self.noDataImageView.superview) {
                [self.noDataImageView removeFromSuperview];
            }
        } else {
            if (!self.noDataImageView.superview) {
                [self.view addSubview:self.noDataImageView];
            }
        }
        return;
    }
    [self.addressTableView.mj_header beginRefreshing];
}
- (void)respondsToDeleteBtn:(UIButton *)sender {
    __weak typeof(self)weakself = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    if (self.isPost) {
        hud.detailsLabelText = @"正在删除发货地址";
        [WPAddMangerViewModel deleteSigleSendAddressWithAddId:self.postAddDataSource[sender.tag][@"id"] SuccessBlock:^(NSString *success) {
            hud.labelText = success;
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
            [weakself.postAddDataSource removeObjectAtIndex:sender.tag];
            [weakself.addressTableView reloadData];
            [UserDataStoreModel saveUserDataWithDataKey:@"postAddDataSource" andWithData:weakself.postAddDataSource andWithReturnFlag:nil];
        } failBlock:^(NSString *error) {
            hud.labelText = @"网络错误";
            hud.detailsLabelText = error;
            [hud hide:YES afterDelay:2.0];
        }];
        return;
    }
    hud.detailsLabelText = @"正在删除收货地址";
    [WPAddMangerViewModel deleteSigleReciveAddressWithAddId:self.getAddDataSource[sender.tag][@"id"] SuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
        [weakself.getAddDataSource removeObjectAtIndex:sender.tag];
        [weakself.addressTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"getAddDataSource" andWithData:weakself.getAddDataSource andWithReturnFlag:nil];
    } failBlock:^(NSString *error) {
        hud.labelText = @"网络错误";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}
- (void)respondsToSelectedBtn:(UIButton *)sender {
    if (self.isSelect) {
        if (self.isPost && [self.delegate respondsToSelector:@selector(refreshPostAddressWith:)]) {
            [self.delegate refreshPostAddressWith:self.postAddDataSource[sender.tag - SETTAG][@"site"]];
        }
        else if (!self.isPost && [self.delegate respondsToSelector:@selector(refreshReciveAddressWith:)]) {
            [self.delegate refreshReciveAddressWith:self.getAddDataSource[sender.tag - SETTAG][@"site"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (sender.selected ) {
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在设置默认地址中";
    hud.removeFromSuperViewOnHide = YES;
    __weak typeof(self)weakself = self;
    if (self.isPost) {
        [WPAddMangerViewModel setDefaultSendAddressWithAddId:self.postAddDataSource[sender.tag - SETTAG][@"id"] SuccessBlock:^(NSString *success) {
            hud.labelText = success;
            hud.detailsLabelText = nil;
            [hud hide:YES afterDelay:1.0];
            weakself.defaultIndex = sender.tag - SETTAG;
            [weakself.addressTableView reloadData];
    [weakself.addressTableView reloadData];
        } failBlock:^(NSString *error) {
            hud.labelText = @"设置失败";
            hud.detailsLabelText = error;
            [hud hide:YES afterDelay:2.0];
        }];
        return;
    }

    [WPAddMangerViewModel setDefaultGetAddressWithAddId:self.postAddDataSource[sender.tag - SETTAG][@"id"] SuccessBlock:^(NSString *success) {
        hud.labelText = success;
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
        weakself.defaultIndex = sender.tag - SETTAG;
        [weakself.addressTableView reloadData];
    } failBlock:^(NSString *error) {
        hud.labelText = @"设置失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
    }];
}

#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isPost ? self.postAddDataSource.count:self.getAddDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.isPost) {
        cell.addTitleLabel.text = @"发货地址";
        cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@", self.postAddDataSource[indexPath.row][@"name"], self.postAddDataSource[indexPath.row][@"phone"]];
        cell.addressLabel.text = [NSString stringWithFormat:@"发货地：%@", self.postAddDataSource[indexPath.row][@"site"]];
    } else {
        cell.addTitleLabel.text = @"收货地址";
        cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@", self.getAddDataSource[indexPath.row][@"name"], self.getAddDataSource[indexPath.row][@"phone"]];
        cell.addressLabel.text = [NSString stringWithFormat:@"收货地%@", self.getAddDataSource[indexPath.row][@"site"]];

    }
    cell.selectBtn.tag = indexPath.row + SETTAG;
    [cell.selectBtn addTarget:self action:@selector(respondsToSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(respondsToDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.selected = NO;
    if (!self.isSelect && indexPath.row == self.defaultIndex) {
        cell.selectBtn.selected = YES;
        self.defaultIndex = 0;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1) adjustWidth:NO];
    headView.backgroundColor = GARYTextColor;
    return headView;
}

#pragma mark - getter
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = ({
            UISegmentedControl * control = [[UISegmentedControl alloc]initWithItems:@[@"发货地址", @"收货地址"]];
            control.frame = DHFlexibleFrame(CGRectMake(10, 74, 300, 35), YES);
            control.tintColor = REDBGCOLOR;
            control.selectedSegmentIndex = 0;
            [control addTarget:self action:@selector(respondsToSegmentControl:) forControlEvents:UIControlEventValueChanged];
            control;
        });
    }
    return _segmentedControl;
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
- (UITableView *)addressTableView {
    if (!_addressTableView) {
        _addressTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 110, ORIGIN_WIDTH, ORIGIN_HEIGHT - 110), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.separatorColor = [UIColor clearColor];
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _addressTableView;
}
@end
