//
//  WPMoreDiscountViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/19.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMoreDiscountViewController.h"
#import "WPMoreDisCountCell.h"
#import "WPUseDiscountCell.h"
#import "WPMoreDiscountViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPMoreDiscountViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UILabel * discountLabel;
@property (nonatomic, strong) UILabel * useIntroLabel;
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) UITableView * discountTableView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */



@end

@implementation WPMoreDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"discountUse"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"index"];
}
#pragma mark - init
- (void)refreshData {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"刷新优惠劵详情中";
    __weak typeof(self)weakself = self;
    [WPMoreDiscountViewModel getDiscountDetailWithSuccessBlock:^(NSArray * discount) {
        hud.labelText = @"优惠劵详情获取成功";
        if ([discount count] == 0) {
            hud.detailsLabelText = @"没有优惠劵";
            if (!weakself.noDataImageView.superview) {
                [weakself.view addSubview:weakself.noDataImageView];
            }
        } else {
            hud.detailsLabelText = @"刷新中";
            if (weakself.noDataImageView.superview) {
                [weakself.noDataImageView removeFromSuperview];
            }
        }
        [hud hide:YES afterDelay:1.0];
        if (weakself.dataSource.count > 0) {
            [weakself.dataSource removeAllObjects];
        }
        for (id obj in discount) {
            [weakself.dataSource addObject:obj];
        }
        [UserDataStoreModel saveUserDataWithDataKey:@"morediscount" andWithData:weakself.dataSource andWithReturnFlag:nil];
        [weakself.discountTableView reloadData];
        [weakself.discountTableView.mj_header endRefreshing];
    } failBlock:^(NSString *error) {
        hud.labelText = @"获取失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        [weakself.discountTableView.mj_header endRefreshing];
    }];

}
- (void)initializeDataSource {
    self.dataSource =  [NSMutableArray arrayWithArray:[UserDataStoreModel readUserDataWithDataKey:@"morediscount"]];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"我的优惠劵";
    [self.rightButton removeFromSuperview];
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    backLabel.adjustsFontSizeToFitWidth = YES;
    [self.baseNavigationBar addSubview:backLabel];
    [self.view addSubview:self.discountLabel];
    [self.view addSubview:self.useIntroLabel];
    [self.view addSubview:self.discountTableView];
    if (self.dataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    __weak typeof(self)weakself = self;
    self.discountTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
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
    if (self.isSelect) {
        WPUseDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
        if (!cell) {
            cell = [[WPUseDiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.discountImage.image = IMAGE_CONTENT(@"coupons.png");
        NSMutableAttributedString * count = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元", [self.dataSource[indexPath.row][@"money"] floatValue]]];
        [count addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24*DHFlexibleHorizontalMutiplier()] range:NSMakeRange(0, count.length - 1)];
        cell.discountLabel.attributedText = count;
        cell.pushViewController = self;
        cell.cellIndex = indexPath.row;
        UIImageView * view = [[UIImageView alloc]initWithFrame:cell.frame];
        if (indexPath.row % 2) {
            view.image = IMAGE_CONTENT(@"shadow2.png");
        } else {
            view.image = IMAGE_CONTENT(@"shadow1.png");
        }
        cell.backgroundView = view;
        return cell;
    }
    WPMoreDisCountCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPMoreDisCountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.discountImage.image = IMAGE_CONTENT(@"coupons.png");
    NSMutableAttributedString * count = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元", [self.dataSource[indexPath.row][@"money"] floatValue]]];
    [count addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24*DHFlexibleHorizontalMutiplier()] range:NSMakeRange(0, count.length - 1)];
    cell.discountLabel.attributedText = count;
    UIImageView * view = [[UIImageView alloc]initWithFrame:cell.frame];
    if (indexPath.row % 2) {
        view.image = IMAGE_CONTENT(@"shadow2.png");
    } else {
        view.image = IMAGE_CONTENT(@"shadow1.png");
    }
    cell.backgroundView = view;
    return cell;
}
#pragma mark - UITableViewDelegate
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 * DHFlexibleVerticalMutiplier();
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40) adjustWidth:NO];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有更多优惠劵了！";
    return label;
}
#pragma mark - getter
- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 200, 40) adjustWidth:NO];
            lab.text = @"我的优惠劵";
            lab.adjustsFontSizeToFitWidth = YES;
            lab;
        });
    }
    return _discountLabel;
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
- (UILabel *)useIntroLabel {
    if (!_useIntroLabel) {
        _useIntroLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(130, 64, 180, 40) adjustWidth:NO];
            lab.text = @"优惠劵每次仅限使用一张";
            lab.textAlignment = NSTextAlignmentRight;
            lab.adjustsFontSizeToFitWidth = YES;
            lab;

        });
    }
    return _useIntroLabel;
}
- (UITableView *)discountTableView {
    if (!_discountTableView) {
        _discountTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 104, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = COLOR_RGB(192, 193, 194, 1);
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _discountTableView;
}
@end
