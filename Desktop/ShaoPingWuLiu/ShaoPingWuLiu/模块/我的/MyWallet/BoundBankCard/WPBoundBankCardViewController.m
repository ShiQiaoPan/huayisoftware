//
//  WPBoundBankCardViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPBoundBankCardViewController.h"
#import "WPAddBankCardViewController.h"
#import "WPBoundBankCardViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
@interface WPBoundBankCardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel * introLabel;/**< 绑定说明 */
@property (nonatomic, strong) UITableView * cardTableView;
@property (nonatomic, strong) NSMutableArray * cardDataSource;
@property (nonatomic, strong) UIView * footView;/**< 添加视图 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */



@end

@implementation WPBoundBankCardViewController

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
    __weak typeof(self)weakself = self;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"获取银行卡列表中";
    hud.removeFromSuperViewOnHide = YES;
    [WPBoundBankCardViewModel getBankCardsWithSuccessBlock:^(NSArray *bankCards) {
        hud.labelText = @"获取网络数据成功";
        if (bankCards.count == 0) {
            hud.detailsLabelText = @"尚未绑定银行卡";
            
        } else {
            hud.detailsLabelText = @"刷新中...";
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.cardDataSource.count > 0) {
            [weakself.cardDataSource removeAllObjects];
        }
        for (NSDictionary * dic in bankCards) {
            [weakself.cardDataSource insertObject:dic atIndex:0];
        }
        [weakself.cardTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"cardDataSource" andWithData:weakself.cardDataSource andWithReturnFlag:nil];
        [weakself.cardTableView.mj_header endRefreshing];
    } failBlock:^(NSString *error) {
        hud.labelText = @"获取银行卡列表失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.cardTableView.mj_header endRefreshing];
    }];
}

- (void)initializeDataSource {
    self.cardDataSource = [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"cardDataSource"]];
    }
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"银行卡";
    [self.view addSubview:self.introLabel];
    UIView * lineDown = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introLabel.frame)-1, CGRectGetWidth(self.view.frame), 1)];
    lineDown.backgroundColor = COLOR_RGB(192, 193, 194, 1);
    [self.view addSubview:lineDown];
    [self.view addSubview:self.cardTableView];
    __weak typeof(self)weakself = self;
    self.cardTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
#pragma mark - responds events
- (void)respondsToFootView {
    WPAddBankCardViewController * VC = [[WPAddBankCardViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableString * cardNum = [NSMutableString stringWithString: self.cardDataSource[indexPath.row][@"cardnumber"]];
    for (int i = 5; i < cardNum.length - 4; i++) {
      [cardNum replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    cell.textLabel.text = cardNum;
    cell.detailTextLabel.text = self.cardDataSource[indexPath.row][@"bankname"];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    UIView * lineDown = [[UIView alloc]initWithFrame:CGRectMake(0, 43*DHFlexibleHorizontalMutiplier(), 320*DHFlexibleHorizontalMutiplier(), 1)];
    lineDown.backgroundColor = COLOR_RGB(192, 193, 194, 1);
    [cell addSubview:lineDown];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * DHFlexibleHorizontalMutiplier();
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
    hud.detailsLabelText = @"删除中...";
    __weak typeof(self)weakself = self;
    [WPBoundBankCardViewModel delegeteBankCardWithCardNum:self.cardDataSource[indexPath.row][@"cardnumber"] SuccessBlock:^(NSString *success) {
        hud.labelText = @"删除成功";
        [hud hide:YES afterDelay:1.0];
        [weakself.cardDataSource removeObjectAtIndex:indexPath.row];
        [weakself.cardTableView reloadData];
        [UserDataStoreModel saveUserDataWithDataKey:@"cardDataSource" andWithData:weakself.cardDataSource andWithReturnFlag:nil];
    } failBlock:^(NSString *error) {
        hud.labelText = error;
        hud.detailsLabelText = nil;
        [hud hide:YES afterDelay:1.0];
    }];
}
#pragma mark - getter
- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 310, 30) adjustWidth:YES];
            label.textColor = COLOR_RGB(171, 172, 173, 1);
            label.text = @"绑定的卡号";
            label;
        });
    }
    return _introLabel;
}
- (UITableView *)cardTableView {
    if (!_cardTableView) {
        _cardTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 110, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.backgroundColor = [UIColor clearColor];
            tableview.tableFooterView = self.footView;
            tableview.separatorColor = COLOR_RGB(210, 211, 212, 1);
            tableview;
        });
    }
    return _cardTableView;
}
- (UIView *)footView {
    if (!_footView) {
        _footView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320*DHFlexibleHorizontalMutiplier(), 44*DHFlexibleHorizontalMutiplier())];
            NSLog(@"%f", DHFlexibleHorizontalMutiplier());
            view.backgroundColor = [UIColor whiteColor];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200*DHFlexibleHorizontalMutiplier(), 44*DHFlexibleHorizontalMutiplier())];
            label.text = @"添加银行卡";
            [view addSubview:label];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(260*DHFlexibleHorizontalMutiplier(), 7*DHFlexibleHorizontalMutiplier(), 30*DHFlexibleHorizontalMutiplier(), 30*DHFlexibleHorizontalMutiplier())];
            imageView.image = IMAGE_CONTENT(@"bankAdd@2x.png");
            [view addSubview:imageView];
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToFootView)];
            [view addGestureRecognizer:ges];
            UIView * lineDown = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.bounds)-1, CGRectGetWidth(view.frame), 1)];
            lineDown.backgroundColor = COLOR_RGB(192, 193, 194, 1);
            [view addSubview:lineDown];
            view;
        });
    }
    return _footView;
}
@end
