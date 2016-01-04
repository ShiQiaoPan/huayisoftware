
//
//  WPSystemSetViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPSystemSetViewController.h"
#import "WPChangedPwdViewController.h"
#import "WPAboutSystemViewController.h"
#import "ImageHandle.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPSystemSetViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * setTableView;
@property (nonatomic, strong) NSArray * setDataSource;
@property (nonatomic, strong) UIButton * quitBtn;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPSystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark -init
- (void)initializeDataSource {
    self.setDataSource = @[@[@"声音提醒", @"消息推送"],
                           @[@"修改密码"],
                           @[@"关于系统"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    self.titleLable.text = @"系统设置";
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.view addSubview:self.setTableView];
    [self.view addSubview:self.quitBtn];
}
#pragma mark - responds events
- (void)respondsToQuitBtn {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AutoLogin"];
    [UserDataStoreModel clearUserData];
    [ImageHandle deleteImageWithImageName:@"headImage.png"];
    [[[ControllerManager sharedManager] mainTabController] resetController];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - system provotol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.setDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.setDataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.setDataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch * wpSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ORIGIN_WIDTH - 80, 10, 30, 30) adjustWidth:YES];
        wpSwitch.onTintColor = COLOR_RGB(240, 81, 51, 1);
        [cell addSubview:wpSwitch];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20*DHFlexibleVerticalMutiplier();
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 * DHFlexibleVerticalMutiplier();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return;
    }
    if (indexPath.section == 1) {
        [self.navigationController pushViewController:[[WPChangedPwdViewController alloc]init] animated:YES];
        return;
    }
    if (indexPath.section == 2) {
        [self.navigationController pushViewController:[[WPAboutSystemViewController alloc]init] animated:YES];
        return;
    }
}

#pragma mark - gettet
- (UITableView *)setTableView {
    if (!_setTableView) {
        _setTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH, ORIGIN_HEIGHT - 128), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = COLOR_RGB(210, 211, 212, 1);
            tableview.scrollEnabled = NO;
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _setTableView;
}
- (UIButton *)quitBtn {
    if (!_quitBtn) {
        _quitBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 350, 300, 45) adjustWidth:YES];
            [btn setTitle:@"退出登录" forState:UIControlStateNormal];
            btn.backgroundColor = COLOR_RGB(240, 81, 51, 1);
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToQuitBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _quitBtn;
}
@end
