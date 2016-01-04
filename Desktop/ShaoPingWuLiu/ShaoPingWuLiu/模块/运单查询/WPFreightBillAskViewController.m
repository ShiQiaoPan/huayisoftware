//
//  WPOrderViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPFreightBillAskViewController.h"
#import "QRCodeViewController.h"
#import "WPBillAskTableViewCell.h"
#import "WPFreightBillViewModel.h"

#define BILLTXTCOLOR [UIColor colorWithRed:151/255.0 green:152/255.0 blue:153/255.0 alpha:1]
static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPFreightBillAskViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITextField * searchTextField;/**< 查询输入框 */
@property (nonatomic, strong) UIButton * scanBtn;/**< 扫描按钮 */
@property (nonatomic, strong) UIButton * searchBtn;/**< 查找按钮 */
@property (nonatomic, strong) UITableView * logisticsTabView;/**< 物流表格视图 */
@property (nonatomic, strong) NSMutableArray * logisticsDataSource;/**< 物流数据 */
@property (nonatomic, strong) UIView * headView;/**< 表格头视图 */
@property (nonatomic, strong) UITextField * headTitTxt;/**< 物流跟踪标题 */
@property (nonatomic, strong) UITextField * billNoText;/**< 运单号 */
@property (nonatomic, strong) UITextField * sourceText;/**< 信息来源 */
@property (nonatomic, strong) UIImageView * noDataImageView;/**< 无数据图 */
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */



@end

@implementation WPFreightBillAskViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"detailScan" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    if (self.QRCode.length) {
        [self askWithQRCode:self.QRCode];
    }
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    [self.titleLable removeFromSuperview];
    [self.baseNavigationBar addSubview:self.searchTextField];
    [self.baseNavigationBar addSubview:self.searchBtn];
    [self.view addSubview:self.noDataImageView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondsToScan:) name:@"detailScan" object:nil];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToScan:(NSNotification *)notification {
    self.searchTextField.text = notification.object;
    self.billNoText.text = notification.object;
}
- (void)respondsToScanBtn {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self initializeAlertControllerWithMessage:@"当前设备相机不可用"];
        return;
    }
    QRCodeViewController * qrVC = [[QRCodeViewController alloc]init];
    qrVC.isHome = NO;
    [self.navigationController pushViewController:qrVC animated:YES];
}
- (void)respondsToSearchBtn {
    [self.view endEditing:YES];
    [self askWithQRCode:self.searchTextField.text];
}
#pragma mark system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logisticsDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPBillAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[WPBillAskTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.firstImage.superview) {
        [cell.firstImage removeFromSuperview];
    }
    if (cell.sencondImage.superview) {
        [cell.sencondImage removeFromSuperview];
    }
    
    cell.titleLab.text = self.logisticsDataSource[indexPath.row][@"PorcessTime"];
    cell.detailLab.text = self.logisticsDataSource[indexPath.row][@"Process"];
    if (indexPath.row == 0) {
        [cell addSubview:cell.firstImage];
        cell.titleLab.textColor = REDBGCOLOR;
        cell.detailLab.textColor = REDBGCOLOR;
    } else {
        [cell addSubview:cell.sencondImage];
        cell.titleLab.textColor = BILLTXTCOLOR;
        cell.detailLab.textColor = BILLTXTCOLOR;
    }
    if (indexPath.row != self.logisticsDataSource.count - 1) {
        [cell addSubview:cell.lineView];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62*DHFlexibleVerticalMutiplier();
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 87 * DHFlexibleVerticalMutiplier();
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headView;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.billNoText.text = self.searchTextField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.searchTextField) {
        [self askWithQRCode:self.searchTextField.text];
    }
    return YES;
}
#pragma mark - private methods 
- (void)askWithQRCode:(NSString*)QRCode {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"查询中";
    __weak typeof(self)weakself = self;
    [WPFreightBillViewModel getFreightResultWithBillNum:QRCode WithSuccessBlock:^(NSArray *myInfo) {
        hud.labelText = @"查询成功";
        hud.detailsLabelText = @"加载数据中...";
        [hud hide:YES afterDelay:1.0];
        weakself.logisticsDataSource = [NSMutableArray arrayWithArray:myInfo];
        if (weakself.noDataImageView.superview) {
            [weakself.noDataImageView removeFromSuperview];
        }
        [weakself.view addSubview:weakself.logisticsTabView];
    } failBlock:^(NSString *error) {
        hud.labelText = @"查询失败";
        hud.detailsLabelText = error;
        [hud hide:YES afterDelay:2.0];
        if (!weakself.noDataImageView.superview) {
            [weakself.view addSubview:weakself.noDataImageView];
        }
    }];

}
#pragma mark - getter
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
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(35, 30, 225, 30) adjustWidth:NO];
            text.placeholder   = @"请输入您的运单号";
            text.borderStyle   = UITextBorderStyleRoundedRect;
            text.rightViewMode = UITextFieldViewModeAlways;
            text.leftViewMode  = UITextFieldViewModeAlways;
            
            UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) adjustWidth:YES];
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) adjustWidth:YES];
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 30, 30) adjustWidth:YES];
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
            text.adjustsFontSizeToFitWidth = YES;
            text.text = self.QRCode;
            text;
        });
    }
    return _searchTextField;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(265, 30, 45, 30) adjustWidth:NO];
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
- (UITableView *)logisticsTabView {
    if (!_logisticsTabView) {
        _logisticsTabView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 64, ORIGIN_WIDTH , ORIGIN_HEIGHT - 64), NO) style:UITableViewStyleGrouped];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorColor = [UIColor clearColor];
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _logisticsTabView;
}
- (UIView *)headView {
    if (!_headView) {
        _headView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 88) adjustWidth:NO];
            view.backgroundColor = [UIColor clearColor];
            [view addSubview:self.headTitTxt];
            [view addSubview:self.billNoText];
            [view addSubview:self.sourceText];
            view;
        });
    }
    return _headView;
}
- (UITextField *)headTitTxt {
    if (!_headTitTxt) {
        _headTitTxt = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 30) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * billLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 24) adjustWidth:NO];
            UIImageView * pin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22) adjustWidth:YES];
            pin.center = DHFlexibleCenter(CGPointMake(20, 12));
            pin.image = IMAGE_CONTENT(@"order_marker.png");
            [billLeftView addSubview:pin];
            text.text = @"物流跟踪";
            text.textColor = COLOR_RGB(111, 112, 113, 1);
            text.font = [UIFont systemFontOfSize:14*DHFlexibleHorizontalMutiplier()];
            text.leftView = billLeftView;
            text.textColor = BILLTXTCOLOR;
            text.enabled = NO;
            text.backgroundColor = [UIColor whiteColor];
            text;

        });
    }
    return _headTitTxt;
}
- (UITextField *)billNoText {
    if (!_billNoText) {
        _billNoText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 30, 320, 24) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * billLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 85, 24) adjustWidth:NO];
            UILabel * bill = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 50, 24) adjustWidth:NO];
            bill.text = @"运单号：";
            bill.font = [UIFont systemFontOfSize:12*DHFlexibleHorizontalMutiplier()];
            bill.textColor = BILLTXTCOLOR;
            [billLeftView addSubview:bill];
            text.leftView = billLeftView;
            text.textColor = BILLTXTCOLOR;
            text.enabled = NO;
            text.text = self.QRCode;
            text.font = [UIFont systemFontOfSize:12 * DHFlexibleHorizontalMutiplier()];
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _billNoText;
}
- (UITextField *)sourceText {
    if (!_sourceText) {
        _sourceText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 50, 320, 28) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            UIView * billLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 24) adjustWidth:NO];
            UILabel * bill = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 60, 24) adjustWidth:NO];
            bill.text = @"信息来源：";
            bill.font = [UIFont systemFontOfSize:12*DHFlexibleHorizontalMutiplier()];
            bill.textColor = BILLTXTCOLOR;
            [billLeftView addSubview:bill];
            text.leftView = billLeftView;
            text.textColor = BILLTXTCOLOR;
            text.enabled = NO;
            text.text = @"邵平物流";
            text.font = [UIFont systemFontOfSize:12 * DHFlexibleHorizontalMutiplier()];
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _sourceText;
}
@end
