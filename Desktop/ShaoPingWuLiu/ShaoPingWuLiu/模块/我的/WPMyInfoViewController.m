//
//  MyInfoViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/5.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMyInfoViewController.h"
#import "CustomTableViewCell.h"
#import "WPMyInfoMoreViewController.h"
#import "WPMsgViewController.h"
#import "MyInfoViewModel.h"
#import "ImageHandle.h"
#import "URL.h"


static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
#define STRARTTAG 1001

@interface WPMyInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * headBgImageView;/**< 头像背景 */
@property (nonatomic, strong) UIButton * chatBtn;/**< 消息按钮 */
@property (nonatomic, strong) UIImageView * headImagView;/**< 头像背景 */
@property (nonatomic, strong) UILabel * nameLabel;/**< 名字文本 */
@property (nonatomic, strong) UIImageView * isSignedImageView;/**< 签约客户 */
@property (nonatomic, assign) NSInteger starCount;/**< 星级等级 */
@property (nonatomic, assign) NSInteger balance;/**< 余额 */
@property (nonatomic, assign) NSInteger transportBean;/**< 运输豆 */
@property (nonatomic, strong) UITableView * myInfoTableView;/**< 信息tableView */
@property (nonatomic, strong) NSArray * infoDataSource;/**< tableView数据源 */
@property (nonatomic, strong) NSArray * moneyArr;
@property (nonatomic, strong) NSArray * viewControllersArr;/**< 控制器数组 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */
- (void)configStar;/**< 画星星 */
- (void)setUserStartCountWithStartCount:(NSInteger)starCount;/**< 配置星级 */
@end

@implementation WPMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![UserModel defaultUser].needAutoLogin) {
        return;
    }
    
    __weak typeof(self)weakself = self;
        [MyInfoViewModel getMyInfoWithSuccessBlock:^(NSDictionary *myInfo) {
        NSArray * keys = myInfo.allKeys;
        NSMutableDictionary * resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSString * key in keys) {
            id info = myInfo[key]==[NSNull null]? @"":myInfo[key];
            [resultDic setObject:info forKey:key];
        }
        [UserDataStoreModel saveUserDataWithDataKey:@"myInfoDic" andWithData:resultDic andWithReturnFlag:nil];
        weakself.starCount = [resultDic[@"rank"] integerValue];
        [weakself setUserStartCountWithStartCount:self.starCount];
        weakself.nameLabel.text = !resultDic[@"nickname"] ? [UserModel defaultUser].phoneNumber:resultDic[@"nickname"];
        weakself.balance = [resultDic[@"balance"] integerValue];
        weakself.transportBean = [resultDic[@"transportbean"] integerValue];
        [weakself.myInfoTableView reloadData];
        NSURL * headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASIC_URL,resultDic[@"favicon"]]];
        NSData * headData = [NSData dataWithContentsOfURL:headUrl];
        if (headData.bytes > 0) {
            weakself.headImagView.image = [UIImage imageWithData:headData];
            [ImageHandle saveImage:weakself.headImagView.image WithName:@"headImage.png"];
        } else {
            weakself.headImagView.image = IMAGE_CONTENT(@"head.png");
        }
        weakself.isSignedImageView.image = [resultDic[@"cooperation"] integerValue] ?IMAGE_CONTENT(@"label.png") : IMAGE_CONTENT(@"nolable@2x.png");
    } failBlock:^(NSString *error) {
        [weakself initializeAlertControllerWithMessageAndDismiss:error];
    }];
}
#pragma mark - init
- (void)initializeDataSource {
    NSArray * imageArr = [NSArray arrayWithObjects:
  @[@[@"wallet.png", @"我的钱包"] ,
    @[@"bean.png", @"运输豆"]],
  @[@[@"myInfo.png", @"我的资料"],
    @[@"bean.png", @"地址管理"]],
  @[@[@"comment.png", @"我的评价"],
    @[@"friend.png", @"邀请好友"],
    @[@"advice.png", @"建议反馈"],
    @[@"settings.png", @"系统设置"]], nil];
    
    self.infoDataSource = [NSArray arrayWithArray:imageArr];
    self.viewControllersArr = @[@[@"WPMyWalletViewController",
                                  @"WPTransportBeanViewController"],
                                @[@"WPMyInfoMoreViewController",
                                  @"WPAddressManagerViewController"],
                                @[@"WPMyJudgeViewController",
                                  @"WPInviteFriendsViewController",
                                  @"WPAdviceFeedbackViewController",
                                  @"WPSystemSetViewController"]];
    NSDictionary * originDic = [UserDataStoreModel readUserDataWithDataKey:@"myInfoDic"];
    self.starCount = [originDic[@"rank"] integerValue];
    self.balance = [originDic[@"balance"] integerValue];
    self.transportBean = [originDic[@"transportbean"] integerValue];
    [self.myInfoTableView reloadData];
    self.isSignedImageView.image = [originDic[@"cooperation"] integerValue] ?IMAGE_CONTENT(@"label.png") : IMAGE_CONTENT(@"nolable@2x.png");
}
- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.baseNavigationBar removeFromSuperview];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.headBgImageView];
    [self.view addSubview:self.chatBtn];
    [self.view addSubview:self.headImagView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.isSignedImageView];
    [self.view addSubview:self.myInfoTableView];
    [self configStar];
    [self addMask];
}
#pragma mark - reponds events
- (void)respondsToChatBtn {
    [self.navigationController pushViewController:[[WPMsgViewController alloc] init] animated:YES];
}

#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _infoDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_infoDataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = IMAGE_CONTENT(_infoDataSource[indexPath.section][indexPath.row][0]);
    cell.titleLabel.text = _infoDataSource[indexPath.section][indexPath.row][1];
    cell.rightLabel.text = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%ld", (long)self.balance];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%ld",(long)self.transportBean];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*DHFlexibleVerticalMutiplier();
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * DHFlexibleHorizontalMutiplier();
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.infoDataSource.count - 1) {
        return nil;
    }
    UIView * footView = [[UIView alloc]init];
    footView.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    UIView *  viewUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1) adjustWidth:NO];
    viewUp.backgroundColor = COLOR_RGB(210, 211, 212, 1);
    UIView *  viewDown = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 320, 1) adjustWidth:NO];
    viewDown.backgroundColor = COLOR_RGB(210, 211, 212, 1);
    [footView addSubview:viewUp];
    [footView addSubview:viewDown];
    return footView;
}
//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        WPMyInfoMoreViewController * VC = [[WPMyInfoMoreViewController alloc]init];
        VC.userName = self.nameLabel.text;
        VC.starCount = self.starCount;
        VC.isSigned = [[UserDataStoreModel readUserDataWithDataKey:@"myInfoDic"][@"cooperation"] integerValue];
        [[[ControllerManager sharedManager] rootViewController] pushViewController:VC animated:YES];
        return;
    }
    Class class = NSClassFromString(self.viewControllersArr[indexPath.section][indexPath.row]);
    UIViewController *controller = [[class alloc]init];
    [[[ControllerManager sharedManager] rootViewController] pushViewController:controller animated:YES];
}
#pragma mark - private methods
- (void)addMask {
    CAGradientLayer * grafientLayer = [CAGradientLayer layer];
    grafientLayer.frame = DHFlexibleFrame(CGRectMake(0, ORIGIN_HEIGHT - 60, 320, 60), NO);
    grafientLayer.startPoint = CGPointMake(0, 0);
    grafientLayer.endPoint = CGPointMake(0, 1);
    grafientLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:grafientLayer];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 60), NO);
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path moveToPoint:DHFlexibleCenter(CGPointMake(0, 10))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(140, 10))];/**<r = 29 */
    [path addArcWithCenter:DHFlexibleCenter(CGPointMake(160, 29)) radius:28
     *DHFlexibleVerticalMutiplier() startAngle:M_PI*1.3 endAngle:M_PI*1.75 clockwise:YES];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, 10))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(320, 60))];
    [path addLineToPoint:DHFlexibleCenter(CGPointMake(0, 60))];
    
    maskLayer.path = path.CGPath;
    grafientLayer.mask = maskLayer;
    [grafientLayer addSublayer:maskLayer];
    
}

- (void)configStar {
    for (int i = 1; i < 6; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.bounds = DHFlexibleFrame(CGRectMake(0, 0, 25, 25), YES);
        btn.center = DHFlexibleCenter(CGPointMake(i * 25 +85, 160));
        [btn setImage:IMAGE_CONTENT(@"star_1.png") forState:UIControlStateNormal];
        [btn setImage:IMAGE_CONTENT(@"star.png") forState:UIControlStateSelected];
        btn.tag = STRARTTAG + i;
        [self.view addSubview:btn];
    }
}
- (void)setUserStartCountWithStartCount:(NSInteger)starCount {
    if (starCount == 0) {
        return;
    }
    for (int i = 0; i < starCount; i++) {
        UIButton * btn = [self.view viewWithTag:STRARTTAG + i];
        btn.selected = YES;
    }
}
#pragma mark - getter
- (UIImageView *)headBgImageView {
    if (!_headBgImageView) {
        _headBgImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"myInfoBg.png");
            view;
        });
    }
    return _headBgImageView;
}
- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = ({
            UIButton * btn = [ UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(270, 24, 30, 30), YES);
            [btn setImage:IMAGE_CONTENT(@"chat.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToChatBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _chatBtn;
}
- (UIImageView *)headImagView {
    if (!_headImagView) {
        _headImagView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(120, 30, 80, 80) adjustWidth:YES];
            
            NSData * imageData = [ImageHandle readImageWithImageName:@"headImage.png"];
            view.image = imageData.bytes != 0 ?[UIImage imageWithData:imageData]: IMAGE_CONTENT(@"head.png");
            view.userInteractionEnabled = YES;
            view.layer.cornerRadius = 40 * DHFlexibleVerticalMutiplier();
            view.layer.masksToBounds = YES;
            view;
        });
    }
    return _headImagView;
}
- (UIImageView *)isSignedImageView {
    if (!_isSignedImageView) {
        _isSignedImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(210, 40, 30, 60) adjustWidth:YES];
            view;
        });
    }
    return _isSignedImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 320, 30) adjustWidth:NO];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [UserDataStoreModel readUserDataWithDataKey:@"myInfoDic"][@"nickname"] ? [UserDataStoreModel readUserDataWithDataKey:@"myInfoDic"][@"nickname"] :[UserModel defaultUser].phoneNumber;
            label;
        });
    }
    return _nameLabel;
}

- (UITableView *)myInfoTableView {
    if (!_myInfoTableView) {
        _myInfoTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 200, ORIGIN_WIDTH, ORIGIN_HEIGHT-250), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = COLOR_RGB(210, 211, 212, 1);
            tableview.showsHorizontalScrollIndicator = NO;
            tableview.showsVerticalScrollIndicator = NO;
            tableview;
        });
    }
    return _myInfoTableView;
}
@end
