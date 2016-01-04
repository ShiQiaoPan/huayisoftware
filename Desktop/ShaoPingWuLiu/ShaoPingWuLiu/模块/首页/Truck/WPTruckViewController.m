//
//  WPTruckViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTruckViewController.h"
#import "ControllerManager.h"
#import "WPDriverCardViewController.h"
#import "WPTruckViewModel.h"

#define vSpace        10.0f
#define textFont      14.0f
#define titImgWid     30.0f
#define butWidth      60.0f
#define tBeginTag     200     // 200 ~ 203
#define mColor [UIColor colorWithWhite:0.88 alpha:1]

@interface WPTruckViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_dataArray;
    NSMutableArray * _nextViewControlls;
}
@property (nonatomic, strong) UIImageView * noDataImageView;/**< 没数据背景 */
@property (nonatomic, strong) UIImageView *topImageView;   /**< 顶部实图 */
@property (nonatomic, strong) UIView      *buttonBackView; /**< 按钮背景 */
@property (nonatomic, strong) UITableView *thyTableView;   /**< 表      */
@property (nonatomic, strong) UILabel * todayTruckNeed; /**< 今日需求 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)refreshData;/**< 刷新数据 */


@end

@implementation WPTruckViewController
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
- (void)initializeDataSource {
    NSArray * arr = @[@"RYTrunkInfoViewController", @"WPCarRepairViewController", @"WPTopSetViewController", @"WPFreightAskViewController"];
    _nextViewControlls = [NSMutableArray arrayWithCapacity:0];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = NSClassFromString(obj);
        //            *stop = YES;/**< 停止遍历 */
        UIViewController *controller = [[class alloc]init];
        [_nextViewControlls addObject:controller];
    }];
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = mColor;
    self.titleLable.text = @"车辆管理";
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.buttonBackView];
    [self.view addSubview:self.todayTruckNeed];
    if (_dataArray.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    [self.view addSubview:self.thyTableView];
    __weak typeof(self)weakself = self;
    self.thyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
}
- (void)refreshData {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor grayColor];
    hud.detailsLabelText = @"获取今日车辆需求中";
    hud.labelText = @"请稍候";
    __weak typeof(self)weakself = self;
    [WPTruckViewModel getTruckNeedWithSuccessBlock:^(NSArray *truckNeeds) {
        hud.labelText = @"获取网络数据成功";
        hud.detailsLabelText = @"数据加载中...";
        [hud hide:YES afterDelay:1.0];
        if (weakself.noDataImageView.superview) {
            [self.noDataImageView removeFromSuperview];
        }
        if (_dataArray.count) {
            [_dataArray removeAllObjects];
        } else {
            _dataArray = [NSMutableArray arrayWithCapacity:0];
        }
        for (NSString * str in truckNeeds) {
            [_dataArray addObject:str];
        }
        [weakself.thyTableView reloadData];
        [weakself.thyTableView.mj_header endRefreshing];
    } failBlock:^(NSString *error) {
        hud.labelText = @"获取网络数据失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        if (!weakself.noDataImageView.superview) {
            [weakself.view addSubview:weakself.noDataImageView];
        }
        [weakself.thyTableView.mj_header endRefreshing];
    }];
}
#pragma mark - get methods
- (UIView *)buttonBackView {
    if (!_buttonBackView) {
        _buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame) + vSpace, SCREEN_SIZE.width, 110)];
        _buttonBackView.backgroundColor = [UIColor whiteColor];
        [self createButtons];
    }
    return _buttonBackView;
}
- (UIImageView *) topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.baseNavigationBar.frame), SCREEN_SIZE.width, 140)];
        _topImageView.image =  IMAGE_CONTENT(@"banner.png");
    }
    return _topImageView;
}
- (UILabel *)todayTruckNeed {
    if (!_todayTruckNeed) {
        _todayTruckNeed = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.buttonBackView.frame), 310, 40)];
            label.text = @"今日车辆需求";
            label.textColor = COLOR_RGB(51, 52, 53, 1);
            label;
        });
    }
    return _todayTruckNeed;
}
- (UITableView *) thyTableView {
    if (!_thyTableView) {
        _thyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.todayTruckNeed.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - CGRectGetMaxY(self.todayTruckNeed.frame)) style:UITableViewStylePlain];
        _thyTableView.backgroundColor = [UIColor clearColor];
        _thyTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _thyTableView.delegate        = self;
        _thyTableView.dataSource      = self;
    }
    return _thyTableView;
}
- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.todayTruckNeed.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - CGRectGetMaxY(self.todayTruckNeed.frame)) ];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 51,  75)];
            imageView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(view.bounds));
            imageView.image = IMAGE_CONTENT(@"暂无信息null@2x.png");
            [view addSubview:imageView];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _noDataImageView;
}
#pragma mark - 创建 But
- (void) createButtons {
    NSArray *titles   = @[@"车辆资料", @"车辆维修", @"提醒设置", @"运费查询"];
    NSArray *imgArr   = @[@"truck_car.png", @"tools_truck.png", @"alert_truck.png", @"search_truck.png"];
    for (int i = 0;  i < titles.count; i++) {
        CGFloat   spa = (SCREEN_SIZE.width - butWidth * 4) / 5;
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame     = CGRectMake(spa + (butWidth + spa) * i, vSpace, butWidth, butWidth);
        but.tag       = tBeginTag + i;
        [but setImage:IMAGE_CONTENT(imgArr[i]) forState:UIControlStateNormal];
        [but addTarget:self action:@selector(respondsToButClicked:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lab  = [[UILabel alloc] initWithFrame:CGRectMake(but.frame.origin.x, CGRectGetMaxY(but.frame), but.frame.size.width, 30)];
        lab.text      = titles[i];
        lab.adjustsFontSizeToFitWidth = YES;
        lab.textAlignment = NSTextAlignmentCenter;
        [self.buttonBackView addSubview:but];
        [self.buttonBackView addSubview:lab];
    }
}

#pragma mark - but点击回调方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void) respondsToButClicked:(UIButton *) sender {
    [self.navigationController pushViewController:_nextViewControlls[sender.tag - tBeginTag] animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = _dataArray[indexPath.row];
    CGFloat hight = [self calculateSizeWithFont:textFont Text:string Width:tableView.frame.size.width -vSpace * 3 - titImgWid].size.height + vSpace;
    if (hight < titImgWid+vSpace) {
        hight = titImgWid + vSpace;
    }
    return hight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    UIImageView *titImg   = [[UIImageView alloc] initWithFrame:CGRectMake(vSpace, vSpace / 2, titImgWid, titImgWid)];
    titImg.image          = IMAGE_CONTENT(@"title_truck.png");
    UILabel *imgLab       = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titImgWid, titImgWid)];
    imgLab.text           = [NSString stringWithFormat:@"%lu", (long)indexPath.row +1];
    imgLab.textColor      = [UIColor whiteColor];
    imgLab.textAlignment  = NSTextAlignmentCenter;
    UILabel *lab          = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titImg.frame) + vSpace, vSpace / 2, tableView.frame.size.width - CGRectGetMaxX(titImg.frame) - vSpace * 2, [self calculateSizeWithFont:textFont Text:_dataArray[indexPath.row] Width:tableView.frame.size.width -vSpace * 3 - titImgWid].size.height)];
    lab.text              = _dataArray[indexPath.row];
    lab.font              = [UIFont systemFontOfSize:textFont];
    lab.textColor         = [UIColor colorWithWhite:0.48 alpha:1];
    lab.numberOfLines     = 0;
    [titImg addSubview:imgLab];
    [cell.contentView addSubview:lab];
    [cell.contentView addSubview:titImg];
    return cell;
}
#pragma mark - 计算文本高度
- (CGRect) calculateSizeWithFont:(NSInteger)Font Text:(NSString *)text Width:(CGFloat) width {
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    return size;
}
@end
