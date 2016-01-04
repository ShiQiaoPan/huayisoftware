//
//  HomePageViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/5.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPHomePageViewController.h"
#import "WPLoginViewController.h"
#import "WPMsgViewController.h"
#import "RYLatticeSearchViewController.h"
#import "WPMemberViewController.h"
#import "WPTruckViewController.h"
#import "WPBillCenterViewController.h"
#import "WPOrderManagerViewController.h"
#import "WPPayCenterViewController.h"
#import "RYSendDateSeclectView.h"
#import "NetWorkingManager+Login.h"
#import "QRCodeViewController.h"
#import "WPFreightBillAskViewController.h"
#import "WPDriverCardViewController.h"
#import "WPHomePageViewModel.h"

@interface WPHomePageViewController ()<UITextFieldDelegate, UIScrollViewDelegate>{
    NSMutableArray *_iamgeViews;/**< 存储图片视图 */
    NSMutableArray *_imageNames;/**< 存储图片名字 */
}
@property (nonatomic, strong) UITextField * searchTextField;/**< 查询输入框 */
@property (nonatomic, strong) UIButton * scanBtn;/**< 扫描按钮 */
@property (nonatomic, strong) UIButton * searchBtn;/**< 查找按钮 */
@property (nonatomic, strong) UIButton * custmerBtn;/**< 客户按钮 */
@property (nonatomic, strong) UIButton * truckBtn;/**< 车辆按钮 */
@property (nonatomic, strong) UIButton * memberBtn;/**< 盟商按钮 */
@property (nonatomic, assign) NSUInteger currentSelectedBtnIndex;/**< 当前选中按钮 */
@property (nonatomic, strong) UIScrollView * imageScrollView;/**< 图片轮播滚动 */
@property (nonatomic, strong) UIPageControl * pageControl;/**< 分页显示器 */
@property (nonatomic, strong) UIImageView * billImage;/**< 对账中心 */
@property (nonatomic, strong) UIImageView * netSearchImage;/**< 网点查询 */
@property (nonatomic, strong) UIImageView * orderManagerImage;/**< 订单管理 */
@property (nonatomic, strong) UIImageView * moneyCenterImageView;/**< 付款中心 */
@property (nonatomic, strong) NSTimer * timer;/**< 计时器 */


- (void)initalizedDatasource;
- (void)initalizedUserInterface;
- (void)insertImageViewInScroll;/**< 在滚动视图中插入3个图片视图 */
- (void)insertImageInImageView;/**< 在图片视图上显示图片 */

@end

@implementation WPHomePageViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"homeScan" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalizedDatasource];
    [self initalizedUserInterface];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //释放timer
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserModel defaultUser].needAutoLogin ) {
            self.rightButton.frame = DHFlexibleFrame(CGRectMake(280, 24, 30, 30), YES);
            self.rightButton.selected = YES;
        } else {
       self.rightButton.frame = DHFlexibleFrame(CGRectMake(265, 35, 33, 16), YES);
       self.rightButton.selected = NO;
   }
    self.custmerBtn.selected = YES;
    self.truckBtn.selected = NO;
    self.memberBtn.selected = NO;
    __weak typeof(self)weakself = self;
    [WPHomePageViewModel getTruckStatusWithSuccsessBlock:^(NSString *succ) {
    } andFailBlock:^(NSString *fail) {
        [weakself initializeAlertControllerWithMessageAndDismiss:@"网络暂时不能连接请稍候再试"];
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
}
#pragma mark - init
- (void)initalizedDatasource {
    self.currentSelectedBtnIndex = 0;
    NSArray * arr = @[@"banner.png",@"banner.png",@"banner.png"];
    _imageNames = [NSMutableArray arrayWithArray:arr];                   
}
- (void)initalizedUserInterface {
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    [self.leftButton removeFromSuperview];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(115, 30, 90, 30) adjustWidth:YES];
    imageView.image = IMAGE_CONTENT(@"logo.png");
    [self.baseNavigationBar addSubview:imageView];
    [self.rightButton setImage:IMAGE_CONTENT(@"login@2x.png") forState:UIControlStateNormal];
    [self.rightButton setImage:IMAGE_CONTENT(@"message.png") forState:UIControlStateSelected];
    self.baseNavigationBar.frame = DHFlexibleFrame(CGRectMake(0, 0, 320, 110), NO);
    [self.baseNavigationBar addSubview:self.searchTextField];
    [self.baseNavigationBar addSubview:self.searchBtn];
    [self.view addSubview:self.custmerBtn];
    [self.view addSubview:self.truckBtn];
    [self.view addSubview:self.memberBtn];
    [self.view addSubview:self.imageScrollView];
    [self.view addSubview:self.pageControl];
    [self insertImageViewInScroll];
    [self insertImageInImageView];
    
    //定时器启动
    self.timer.fireDate = [NSDate date];
    [self.view addSubview:self.billImage];
    [self.view addSubview:self.netSearchImage];
    [self.view addSubview:self.orderManagerImage];
    [self.view addSubview:self.moneyCenterImageView];
    [self addMask];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondsToScan:) name:@"homeScan" object:nil];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(void)respondsToNavBarRightButton:(UIButton *)sender {
    if (![[UserModel defaultUser] needAutoLogin]) {
        UIViewController * loginVC = [[WPLoginViewController alloc]init];
        [[[ControllerManager sharedManager] rootViewController] pushViewController:loginVC animated:YES];
        return;
    }
    [[[ControllerManager sharedManager] rootViewController]pushViewController:[[WPMsgViewController alloc]init] animated:YES];
}

- (void)respondsToScanBtn {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self initializeAlertControllerWithMessage:@"当前设备相机不可用"];
        return;
    }
    QRCodeViewController * qrVC = [[QRCodeViewController alloc]init];
    qrVC.isHome = YES;
    [[[ControllerManager sharedManager]rootViewController] pushViewController:qrVC animated:YES];
}
- (void)respondsToScan:(NSNotification *)notification {
    self.searchTextField.text = notification.object;
}
- (void)respondsToSearchBtn {
    [self.view endEditing:YES];
    WPFreightBillAskViewController * freighVC = [WPFreightBillAskViewController new];
    freighVC.QRCode = self.searchTextField.text;
    [[ControllerManager sharedManager].rootViewController pushViewController:freighVC animated:YES];
}
- (void)respondsToSelectionBtn:(UIButton *)sender {
    self.currentSelectedBtnIndex = sender.tag - 100;
    if (sender.tag == 101) {
        if (![UserModel defaultUser].needAutoLogin) {
            [self initializeAlertControllerWithMessage:@"请先登录" withHandelBlock:^(id action) {
                    [[[ControllerManager sharedManager] rootViewController] pushViewController:[[WPLoginViewController alloc]init] animated:YES];
            }];
            return;
        }
        [self pushToTruckViewController];
    }
    else if(sender.tag == 102) {
        UIViewController * VC = [[WPMemberViewController alloc]init];[[[ControllerManager sharedManager] rootViewController]pushViewController:VC animated:YES];
    }
}
- (void)pushToTruckViewController {
    if (![UserDataStoreModel readUserDataWithDataKey:@"truckStatus"]) {
        [[ControllerManager sharedManager].rootViewController pushViewController:[WPDriverCardViewController new] animated:YES];
        return;
    }
    switch ([[UserDataStoreModel readUserDataWithDataKey:@"truckStatus"] integerValue]) {
        case 3:
            [[ControllerManager sharedManager].rootViewController pushViewController:[WPTruckViewController new] animated:YES];
            break;
        case 1:
            [self initializeAlertControllerWithMessageAndDismiss:@"审核中\n请耐心等待"];
            break;
        default:
            [[ControllerManager sharedManager].rootViewController pushViewController:[WPDriverCardViewController new] animated:YES];
            break;
    }
}
- (void)respondsToTimer {
    [self.imageScrollView setContentOffset:DHFlexibleCenter(CGPointMake(2*320, 0)) animated:YES];
}
- (void)respondsToBillImage {
    [RYSendDateSeclectView showSendSelecionViewWithOperation:^(NSDictionary *operation) {
        if (operation) {
            WPBillCenterViewController *bVC = [WPBillCenterViewController new];
            bVC.beginDateString             = operation[@"beginDateString"];
            bVC.endDateString               = operation[@"endDateString"];
            bVC.consigneeTele               = operation[@"consigneeTele"];
            [self.navigationController pushViewController:bVC animated:YES];
        }
        else {
            [self initializeAlertControllerWithMessage:@"日期选择有误,重新选择日期？" withHandelBlock:^(id action) {
                [self respondsToBillImage];
            }];
        }
    }];
}

- (void)respondsToNetSearchImage {
    RYLatticeSearchViewController *rVC = [RYLatticeSearchViewController new];
    [self.navigationController pushViewController:rVC animated:YES];
}
- (void)respondsToOrderManagerImage {
    UIViewController * VC = [[WPOrderManagerViewController alloc]init];
    [[[ControllerManager sharedManager] rootViewController] pushViewController:VC animated:YES];
}
- (void)respondsToMomeyCenterImage {
    UIViewController * VC = [[WPPayCenterViewController alloc]init];
    [[[ControllerManager sharedManager] rootViewController] pushViewController:VC animated:YES];
}
#pragma mark - 系统协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //往右滑
    if (scrollView.contentOffset.x >= 2*CGRectGetWidth(self.view.bounds)) {
        NSString *firstObject = [_imageNames.firstObject mutableCopy];
        [_imageNames removeObject:firstObject];
        [_imageNames addObject:firstObject];
        self.pageControl.currentPage = self.pageControl.currentPage == 2? 0:self.pageControl.currentPage+1;
    }
    //往左滑
    else if (scrollView.contentOffset.x <= 0) {
        NSString *lastObject = [_imageNames.lastObject mutableCopy];
        [_imageNames removeObject:lastObject];
        [_imageNames insertObject:lastObject atIndex:0];
        self.pageControl.currentPage = self.pageControl.currentPage == 2? 0:self.pageControl.currentPage+1;
    }else {
        //停在中间
        return;
    }
    [self insertImageInImageView];
    //更新偏移量
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollView.bounds), 0);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //暂停timer
    _timer.fireDate = [NSDate distantFuture];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //从结束拖动开始计算延迟2s再启动
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
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
- (void)insertImageViewInScroll {
    _iamgeViews = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*320, 0, 320, 130) adjustWidth:NO];
        imageView.userInteractionEnabled = YES;
        [self.imageScrollView addSubview:imageView];
        //将图片视图植入——imageViews 便于便利数组
        [_iamgeViews addObject:imageView];
    }
}
- (void)insertImageInImageView {
    NSInteger index = 0;
    if (_imageNames.count == 1) {
        _imageNames = [NSMutableArray arrayWithArray:@[@"banner.png",@"banner.png",@"banner.png"]];
    }
    for (UIImageView *imageView in _iamgeViews) {
        imageView.image = IMAGE_CONTENT(_imageNames[index]);
        index++;
    }
}

#pragma mark - getter
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, 74, 230, 30) adjustWidth:NO];
            text.placeholder   = @"请输入您的运单号";
            text.borderStyle   = UITextBorderStyleRoundedRect;
            text.rightViewMode = UITextFieldViewModeAlways;
            text.leftViewMode  = UITextFieldViewModeAlways;
            
            UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) adjustWidth:YES];
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) adjustWidth:YES];
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 30) adjustWidth:YES];
            view.image = IMAGE_CONTENT(@"放大镜.png");
            [leftView addSubview:view];
            text.leftView = leftView;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(0, 5, 20, 20), YES);
            [btn setImage:IMAGE_CONTENT(@"code.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToScanBtn) forControlEvents:UIControlEventTouchUpInside];
            [rightView addSubview:btn];
            text.rightView = rightView;
            text.keyboardType = UIKeyboardTypeWebSearch;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.delegate = self;
            text;
        });
    }
    return _searchTextField;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(250, 74, 60, 30) adjustWidth:YES];
            [btn setTitle:@"查询" forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_RGB(240, 81, 51, 1) forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 5;
            [btn addTarget:self action:@selector(respondsToSearchBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _searchBtn;
}
- (UIButton *)custmerBtn {
    if (!_custmerBtn) {
        _custmerBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(40, 120, 60, 60) adjustWidth:YES];
            [btn setImage:IMAGE_CONTENT(@"customer.png") forState:UIControlStateNormal];
            [btn setImage:IMAGE_CONTENT(@"customer_1.png") forState:UIControlStateSelected];
            btn.selected = YES;
            btn.tag = 100;
            [btn addTarget:self action:@selector(respondsToSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _custmerBtn;
}
- (UIButton *)truckBtn {
    if (!_truckBtn) {
        _truckBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(130, 120, 60, 60) adjustWidth:YES];
            [btn setImage:IMAGE_CONTENT(@"car.png") forState:UIControlStateNormal];
            [btn setImage:IMAGE_CONTENT(@"car_1.png") forState:UIControlStateSelected];
            btn.tag = 101;
            [btn addTarget:self action:@selector(respondsToSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _truckBtn;
}
- (UIButton *)memberBtn {
    if (!_memberBtn) {
        _memberBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(220, 120, 60, 60) adjustWidth:YES];
            [btn setImage:IMAGE_CONTENT(@"coperatiom.png") forState:UIControlStateNormal];
            [btn setImage:IMAGE_CONTENT(@"coperatiom_1.png") forState:UIControlStateSelected];
            btn.tag = 102;
            [btn addTarget:self action:@selector(respondsToSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _memberBtn;
}
- (UIScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = ({
            UIScrollView * view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 180, ORIGIN_WIDTH, 130) adjustWidth:NO];
            view.showsHorizontalScrollIndicator = NO;
            view.showsVerticalScrollIndicator = NO;
            view.pagingEnabled = YES;
            view.bounces = NO;
            view.delegate = self;
            view;
        });
    }
    return _imageScrollView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = ({
            UIPageControl * control = [[UIPageControl alloc]initWithFrame:CGRectMake(250, 270, 60, 50) adjustWidth:NO];
            control.numberOfPages = 3;
            control.currentPage = 0;
            control.pageIndicatorTintColor = COLOR_RGB(230, 231, 232, 1);
            control.currentPageIndicatorTintColor = COLOR_RGB(140, 141, 145, 1);
            control;
        });
    }
    return _pageControl;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (UIImageView *)billImage {
    if (!_billImage) {
        _billImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 318, 145, 90) adjustWidth:NO];
            view.backgroundColor = COLOR_RGB(235, 159, 59, 1);
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(52.5, 10, 40, 40) adjustWidth:NO];
            imageView.image = IMAGE_CONTENT(@"yundanchaxun.png");
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 145, 40) adjustWidth:YES];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"对账中心";
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textColor = [UIColor whiteColor];
            [view addSubview:imageView];
            [view addSubview:label];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToBillImage)];
            [view addGestureRecognizer:gestureRecognizer];
            view;
        });
    }
    return _billImage;
}
- (UIImageView *)netSearchImage {
    if (!_netSearchImage) {
        _netSearchImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(165, 318, 145, 90) adjustWidth:NO];
            view.backgroundColor = COLOR_RGB(110, 183, 234, 1);
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(52.5, 10, 40, 40) adjustWidth:NO];
            imageView.image = IMAGE_CONTENT(@"wangdianchaxun.png");
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 145, 40) adjustWidth:YES];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"网点查询";
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textColor = [UIColor whiteColor];
            [view addSubview:imageView];
            [view addSubview:label];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToNetSearchImage)];
            [view addGestureRecognizer:gestureRecognizer];
            view;
        });
    }
    return _netSearchImage;
}
- (UIImageView *)orderManagerImage {
    if (!_orderManagerImage) {
        _orderManagerImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 418, 145, 90) adjustWidth:NO];
            view.backgroundColor = COLOR_RGB(107, 184, 207, 1);
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(52.5, 10, 40, 40) adjustWidth:NO];
            imageView.image = IMAGE_CONTENT(@"dingdan.png");
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 145, 40) adjustWidth:YES];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"订单管理";
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textColor = [UIColor whiteColor];
            [view addSubview:imageView];
            [view addSubview:label];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToOrderManagerImage)];
            [view addGestureRecognizer:gestureRecognizer];
            view;
        });
    }
    return _orderManagerImage;
}
- (UIImageView *)moneyCenterImageView {
    if (!_moneyCenterImageView) {
        _moneyCenterImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(165, 418, 145, 90) adjustWidth:NO];
            view.backgroundColor = COLOR_RGB(238, 145, 87, 1);
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(52.5, 10, 40, 40) adjustWidth:NO];
            imageView.image = IMAGE_CONTENT(@"fukuanzhongxin.png");
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 145, 40) adjustWidth:YES];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"付款中心";
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textColor = [UIColor whiteColor];
            [view addSubview:imageView];
            [view addSubview:label];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToMomeyCenterImage)];
            [view addGestureRecognizer:gestureRecognizer];
            view;
        });
    }
    return _moneyCenterImageView;
}
@end
