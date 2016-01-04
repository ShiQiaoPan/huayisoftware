//
//  RYPickingGoodsViewController.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/23.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAreaPickView.h"
#import "RYPickingGoodsViewController.h"
#import "WPAddressManagerViewController.h"
#import "WPMoreDiscountViewController.h"
#import "NetWorkingManager+PackingCargo.h"
#import "WPMoreDiscountViewModel.h"
#import "WPAddAddressViewController.h"

#define pSpace              10
#define pButtonEnabledColor COLOR_RGB(200, 200, 200, 1)

@interface RYPickingGoodsViewController ()
<MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate,RYPickGoodAddressDeLegate>
@property (weak, nonatomic) IBOutlet UITextField *consignorName;     /**< 发货人姓名   */
@property (weak, nonatomic) IBOutlet UITextField *consignorTel;      /**< 发货人电话   */
@property (weak, nonatomic) IBOutlet UITextField *consignorAddress;  /**< 发货人地址   */
@property (weak, nonatomic) IBOutlet UILabel     *destinationLabel;  /**< 收货城市    */
@property (weak, nonatomic) IBOutlet UILabel     *provinceSelectLabel;/**< 省        */
@property (weak, nonatomic) IBOutlet UIButton    *provinceSelectButton;/**< 选择省    */
@property (weak, nonatomic) IBOutlet UILabel     *citySelectLabel;   /**< 市         */
@property (weak, nonatomic) IBOutlet UIButton    *citySelectButton;  /**< 选择市      */
@property (weak, nonatomic) IBOutlet UILabel     *countySelectLabel; /**< 县         */
@property (weak, nonatomic) IBOutlet UIButton    *countySelectButton;/**< 选择县      */
@property (weak, nonatomic) IBOutlet UITextField *cargoName;         /**< 货物名称    */
@property (weak, nonatomic) IBOutlet UITextField *cargoNumber;       /**< 货物件数    */
@property (weak, nonatomic) IBOutlet UITextField *cargoWeight;       /**< 货物重量    */
@property (weak, nonatomic) IBOutlet UITextField *cargoVolume;       /**< 货物体积    */
@property (weak, nonatomic) IBOutlet UIButton    *heavyCargoBut;     /**< 选择重货    */
@property (weak, nonatomic) IBOutlet UIButton    *paoCargoBut;       /**< 选择抛货    */
@property (weak, nonatomic) IBOutlet UILabel     *preferentialLabel; /**< 优惠券      */
@property (weak, nonatomic) IBOutlet UIView      *consigneeInfoView; /**< 收货人视图  */
@property (weak, nonatomic) IBOutlet UITextField *consigneeName;     /**< 收货人姓名  */
@property (weak, nonatomic) IBOutlet UITextField *consigneeTel;      /**< 收货人电话  */
@property (weak, nonatomic) IBOutlet UITextField *consigneeAddress;  /**< 收货人地址  */
@property (weak, nonatomic) IBOutlet UIView      *remarksView;       /**< 备注视图    */
@property (weak, nonatomic) IBOutlet UITextField *remarksContents;   /**< 备注内容    */
@property (weak, nonatomic) IBOutlet UIButton    *submitButton;      /**< 提交按钮    */
@property (weak, nonatomic) IBOutlet UIView      *remarZoomView;     /**< 备注视图－缩 */
@property (weak, nonatomic) IBOutlet UIScrollView*backScrollView;    /**< 背景滚动视图 */
@property (weak, nonatomic) IBOutlet UITextField *remarksZoomContents;/**<备注内容－缩 */
@property (weak, nonatomic) IBOutlet UIButton    *submitZoomButton;  /**< 提交按钮－缩 */
@property (weak, nonatomic) IBOutlet UIView      *consignorView;     /**< 发货人视图  */
@property (weak, nonatomic) IBOutlet UIView      *cargoView;         /**< 货物信息视图 */
@property (weak, nonatomic) IBOutlet UIView      *preferentialView;  /**< 优惠券视图 */
@property (nonatomic, copy)          NSString    *cargoKinds;        /**< 重货/抛货   */
@property (nonatomic, copy)          NSString    *destinationArea;   /**< 目的地      */
@property (nonatomic, strong)        MAMapView   *thyMapView;        /**< 地图       */
@property (nonatomic, strong)        AMapSearchAPI *thySearch;       /**< 附近搜索    */
@property (nonatomic, strong)        CLLocation  *currentLocation;   /**< 当前定位位置 */
@property (nonatomic, strong)        UITableView *provinceTableView; /**< 省   表    */
@property (nonatomic, strong)        UITableView *cityTableView;     /**< 城市 表     */
@property (nonatomic, strong)        UITableView *countyTableView;   /**< 县   表    */

- (void)initializeDataSource;    /**< 初始化数据源   */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation RYPickingGoodsViewController {
    BOOL _isConsigniorAddress;
    NSArray *_provinceArray;
    NSArray *_cityArray;
    NSArray *_countyArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self)weakself = self;
    _currentLocation = nil;
    [NetWorkingManager getdestinationCitySuccessHandler:^(id responseObject) {
        NSLog(@"%@", responseObject);
        _provinceArray = [responseObject copy];
        _cityArray     = [NSArray array];
        _countyArray   = [NSArray array];
        [weakself.provinceTableView reloadData];
    } FailureHandler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    [WPMoreDiscountViewModel getDiscountDetailWithSuccessBlock:^(NSArray *discount) {
        weakself.preferentialLabel.text = [NSString stringWithFormat:@"%ld张优惠劵可用", [discount count]];
    } failBlock:^(NSString *error) {
        weakself.preferentialLabel.text = error;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
    [self initializeDataSource];
}
#pragma mark - init
- (void)initializeDataSource {
    self.cargoKinds      = @"";
    self.destinationArea = @"";
}
- (void)initializeUserInterface {
    [self.view addSubview:self.thyMapView];
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text      = @"上门接货";
    self.submitButton.layer.cornerRadius      = 4;
    self.submitButton.layer.masksToBounds     = YES;
    self.submitZoomButton.layer.cornerRadius  = 4;
    self.submitZoomButton.layer.masksToBounds = YES;
    UITapGestureRecognizer *provinceTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProvince:)];
    [self.provinceSelectLabel addGestureRecognizer:provinceTapG];
    
    UITapGestureRecognizer *cityTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)];
    [self.citySelectLabel addGestureRecognizer:cityTapG];
    UITapGestureRecognizer *countyTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCounty:)];
    [self.countySelectLabel addGestureRecognizer:countyTapG];
    self.citySelectLabel.hidden    = YES;
    self.citySelectButton.hidden   = YES;
    self.countySelectLabel.hidden  = YES;
    self.countySelectButton.hidden = YES;
    UITapGestureRecognizer *couponTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponSelect)];
    [self.preferentialLabel addGestureRecognizer:couponTapG];
    [self.backScrollView addSubview:self.provinceTableView];
    [self.backScrollView addSubview:self.cityTableView];
    [self.backScrollView addSubview:self.countyTableView];
}

#pragma mark - tabelView delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.provinceTableView) {
        return _provinceArray.count;
    }
    else if (tableView == self.cityTableView) {
        return _cityArray.count;
    }
    else if (tableView == self.countyTableView) {
        return _countyArray.count;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.provinceSelectButton.frame.size.height;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier  = @"selectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    if (tableView == self.provinceTableView) {
        cell.textLabel.text = _provinceArray[indexPath.row][@"cname"];
    }
    else if (tableView == self.cityTableView) {
        cell.textLabel.text = _cityArray[indexPath.row][@"cname"];
    }
    else if (tableView == self.countyTableView) {
        cell.textLabel.text = _countyArray[indexPath.row][@"cname"];
    }
    UIView *botV = [[UIView alloc] initWithFrame:CGRectMake(0, self.provinceSelectButton.frame.size.height - 2, self.provinceTableView.frame.size.width, 1)];
    botV.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:botV];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.provinceTableView) {
        self.provinceSelectLabel.text  = [NSString stringWithFormat:@"%@", cell.textLabel.text];
        [self userInteractionOperation:YES];
        [self updateTableViewFrame];
        _cityArray = [_provinceArray[indexPath.row][@"canshipcities"] copy];
        NSLog(@"%@", _cityArray);
        [self.cityTableView reloadData];
        if (!_cityArray.count) {
            self.citySelectLabel.hidden    = YES;
            self.citySelectButton.hidden   = YES;
        }
        else {
            self.citySelectLabel.hidden    = NO;
            self.citySelectButton.hidden   = NO;
        }
        self.destinationArea = self.provinceSelectLabel.text;
    }
    else if (tableView == self.cityTableView) {
        self.citySelectLabel.text      = [NSString stringWithFormat:@"%@", cell.textLabel.text];
        [self userInteractionOperation:YES];
        [self updateTableViewFrame];
        _countyArray = [_cityArray[indexPath.row][@"canshipcities"]copy];
        [self.countyTableView reloadData];
        if (!_countyArray.count) {
            self.countySelectLabel.hidden  = YES;
            self.countySelectButton.hidden = YES;
        }
        else {
            self.countySelectLabel.hidden  = NO;
            self.countySelectButton.hidden = NO;
        }
        self.destinationArea = [NSString stringWithFormat:@"%@ %@", self.destinationArea, self.citySelectLabel.text];
    }
    else if (tableView == self.countyTableView) {
        self.countySelectLabel.text    = [NSString stringWithFormat:@"%@", cell.textLabel.text];
        [self userInteractionOperation:YES];
        [self updateTableViewFrame];
        self.destinationArea = [NSString stringWithFormat:@"%@ %@", self.destinationArea, self.countySelectLabel.text];
    }
    tableView.hidden = YES;
}

- (void) updateTableViewFrame {
//    self.provinceTableView.frame = CGRectMake(self.provinceSelectLabel.frame.origin.x, CGRectGetMaxY(self.provinceSelectButton.frame) + 10, self.provinceSelectLabel.frame.size.width + self.provinceSelectButton.frame.size.width, 80);
//    self.cityTableView.frame     = CGRectMake(self.citySelectLabel.frame.origin.x, self.provinceTableView.frame.origin.y, self.citySelectLabel.frame.size.width + self.citySelectButton.frame.size.width, 80);
//    self.countyTableView.frame   = CGRectMake(self.countySelectLabel.frame.origin.x, CGRectGetMaxY(self.countySelectButton.frame) + 10, self.countySelectLabel.frame.size.width + self.countySelectButton.frame.size.width, 80);
    
    CGRect provinceRect          = self.provinceTableView.frame;
    provinceRect.origin.x        = self.provinceSelectLabel.frame.origin.x;
    self.provinceTableView.frame = provinceRect;
    
    CGRect cityRect              = self.cityTableView.frame;
    cityRect.origin.x            = self.citySelectLabel.frame.origin.x;
    self.cityTableView.frame     = cityRect;
    
    CGRect countyRect            = self.countyTableView.frame;
    countyRect.origin.x          = self.countySelectLabel.frame.origin.x;
    self.countyTableView.frame   = countyRect;
}

#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
        _currentLocation = [userLocation.location copy];
}
#pragma mark - AMapSearchDelegate
- (void) searchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"request :%@, error :%@", request, error);
}
- (void) onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
//    NSString *title = response.regeocode.addressComponent.city;
//    if (title.length == 0)
//    { title = response.regeocode.addressComponent.province; }
//    thyMapView.userLocation.title    = title;
    if (_isConsigniorAddress) { self.consignorAddress.text = response.regeocode.formattedAddress;}
    else                      {self.consigneeAddress.text  = response.regeocode.formattedAddress;}
}
#pragma mark - respond events
- (void) reGeoAction {
    if (_currentLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location   = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [self.thySearch AMapReGoecodeSearch:request];
    }
    else {[self initializeAlertControllerWithMessage:@"定位失败,请检查本应用GPS是否开启"];}
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void) couponSelect {
    WPMoreDiscountViewController * moreDiscountVC = [[WPMoreDiscountViewController alloc]init];
    moreDiscountVC.isSelect = YES;
    [self.navigationController pushViewController:moreDiscountVC animated:YES];
}
- (IBAction)consigniorAddressButtonClicked:(UIButton *)sender {
    WPAddressManagerViewController * addressVC = [[WPAddressManagerViewController alloc]init];
    addressVC.isSelect = YES;
    addressVC.isPost = YES;
    addressVC.delegate = self;
    [self.navigationController pushViewController:addressVC animated:YES];

}
- (IBAction)getConsigniorLocation:(UIButton *)sender {
    [self.view endEditing:YES];
    _isConsigniorAddress = YES;
    [self reGeoAction];
}

- (IBAction)selectProvince:(UIButton *)sender {
    if (_provinceArray.count) {
        [self.view endEditing:YES];
        self.provinceTableView.hidden  = !self.provinceTableView.hidden;
        self.citySelectLabel.hidden    = YES;
        self.citySelectButton.hidden   = YES;
        self.countySelectLabel.hidden  = YES;
        self.countySelectButton.hidden = YES;
        [self userInteractionOperation:NO];
    }
    else {
        [self initializeAlertControllerWithMessage:@"未获取到城市，请稍后再试"];
    }
    
}
- (IBAction)selectCity:(UIButton *)sender {
    [self.view endEditing:YES];
    self.cityTableView.hidden      = !self.cityTableView.hidden;
    self.countySelectLabel.hidden  = YES;
    self.countySelectButton.hidden = YES;
    [self userInteractionOperation:NO];
}
- (IBAction)selectCounty:(UIButton *)sender {
    [self.view endEditing:YES];
    self.countyTableView.hidden    = !self.countyTableView.hidden;
    [self userInteractionOperation:NO];
}

- (void) userInteractionOperation:(BOOL) open {
    self.consignorView.userInteractionEnabled     = open;
    self.cargoView.userInteractionEnabled         = open;
    self.preferentialView.userInteractionEnabled  = open;
    self.consigneeInfoView.userInteractionEnabled = open;
    self.remarZoomView.userInteractionEnabled     = open;
    self.remarksView.userInteractionEnabled       = open;
    self.backScrollView.scrollEnabled             = open;
}

- (IBAction)cargoTypeButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        self.heavyCargoBut.selected = NO;
        self.paoCargoBut.selected   = NO;
    }
    sender.selected                 = !sender.selected;
    self.cargoKinds = !self.heavyCargoBut.selected && !self.paoCargoBut.selected ? @"" : self.heavyCargoBut.selected ? @"重货" : @"抛货";
}
- (IBAction)fillingMoreButtonClicked:(UIButton *)sender {
    if (self.consigneeInfoView.hidden){
        self.remarksContents.text   = self.remarksZoomContents.text;
        self.consigneeName.text     = @"";
        self.consigneeTel.text      = @"";
        self.consigneeAddress.text  = @"";
    }
    else { self.remarksZoomContents.text = self.remarksContents.text;}
    self.consigneeInfoView.hidden   = !self.consigneeInfoView.hidden;
    self.remarksView.hidden         = !self.remarksView.hidden;
    self.remarZoomView.hidden       = !self.remarZoomView.hidden;
    [sender setImage:[UIImage imageNamed:self.consigneeInfoView.hidden ? @"picking_down" :@"picking_up"]  forState:UIControlStateNormal];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.frame.size.width, self.consigneeInfoView.hidden ? CGRectGetMaxY(self.remarZoomView.frame) : CGRectGetMaxY(self.remarksView.frame));
    
}
- (IBAction)consigneeAddressButtonClicked:(UIButton *)sender {
    WPAddressManagerViewController * addressVC = [[WPAddressManagerViewController alloc]init];
    addressVC.isSelect = YES;
    addressVC.isPost = NO;
    addressVC.delegate = self;
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (IBAction)getConsigneeLocation:(UIButton *)sender {
    [self.view endEditing:YES];
    _isConsigniorAddress = NO;
    [self reGeoAction];
}
- (IBAction)submitButtonClicked:(UIButton *)sender {
    if ([self loginStatus]) {
        [self setSubmitButtonsWhenButtonStatusNormal:NO];
        [self postDataResqust];
    }
}

- (void) setSubmitButtonsWhenButtonStatusNormal:(BOOL) isNormal {
    self.submitButton.enabled = isNormal;
    self.submitZoomButton.enabled = isNormal;
}

- (void) postDataResqust {
    if ([self.consignorName.text isEqualToString:@""] ||
        [self.consignorTel.text isEqualToString:@""]     ||
        [self.consignorAddress.text isEqualToString:@""] ||
        [self.cargoName.text isEqualToString:@""]        ||
        [self.cargoNumber.text isEqualToString:@""]      ||
        [self.cargoWeight.text isEqualToString:@""]      ||
        [self.cargoVolume.text isEqualToString:@""]
        ) {
        [self initializeAlertControllerWithMessage:@"请填写完整必填资料"];
        [self setSubmitButtonsWhenButtonStatusNormal:YES];
    }
    else {
        NSDictionary *dict = [@{
                       @"id":[UserModel defaultUser].userID,
                       @"username":[UserModel defaultUser].phoneNumber,
                       @"iname":self.consignorName.text,
                       @"iphone":self.consignorTel.text,
                       @"isite":self.consignorAddress.text,
                       @"icity":self.destinationArea,
                       @"articlename":self.cargoName.text,
                       @"number":[NSNumber numberWithInt:[self.cargoNumber.text intValue]],
                       @"weight":[NSNumber numberWithDouble:[self.cargoWeight.text floatValue]],
                       @"volume":[NSNumber numberWithDouble:[self.cargoVolume.text floatValue]],
                       @"articletype":self.cargoKinds,
                       @"dname":self.consigneeName.text,
                       @"dphone":self.consigneeTel.text,
                       @"dsite":self.consigneeAddress.text,
                       @"remarks":self.consigneeInfoView.hidden ? self.remarksZoomContents.text : self.remarksContents.text
                                   } copy];
        [NetWorkingManager submitPackingOrderWithParamsDict:dict SuccessHandler:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"success"]  isEqual: @1]) {
                [self initializeAlertControllerWithMessage:@"提交成功" withHandelBlock:^(id action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            [self setSubmitButtonsWhenButtonStatusNormal:YES];
        } FailureHandler:^(NSError *error) {
            [self setSubmitButtonsWhenButtonStatusNormal:YES];
        }];
    }
}
#pragma mark - private protocol
- (void)refreshPostAddressWith:(NSString *)address {
    self.consignorAddress.text = address;
}
- (void)refreshReciveAddressWith:(NSString *)address {
    self.consigneeAddress.text = address;
}
#pragma mark - getter
- (MAMapView *)thyMapView {
    if (!_thyMapView) {
        [MAMapServices sharedServices].apiKey = gaoDeKey;
        _thyMapView = [[MAMapView alloc] initWithFrame:CGRectMake(-1000, 1000, 1, 1)];
        _thyMapView.delegate                   = self;
        _thyMapView.showsUserLocation          = YES;
        _thyMapView.showsCompass               = NO;
        _thyMapView.showsScale                 = NO;
    }
    return _thyMapView;
}
- (AMapSearchAPI *)thySearch {
    if (!_thySearch) {
        _thySearch = [[AMapSearchAPI alloc] initWithSearchKey:gaoDeKey Delegate:self];
    }
    return _thySearch;
}
- (UITableView *)provinceTableView {
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.provinceSelectLabel.frame.origin.x, CGRectGetMaxY(self.provinceSelectButton.frame) + 10, self.provinceSelectLabel.frame.size.width + self.provinceSelectButton.frame.size.width, 80) style:UITableViewStylePlain];
        _provinceTableView.backgroundColor = [UIColor whiteColor];
        _provinceTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _provinceTableView.delegate        = self;
        _provinceTableView.dataSource      = self;
        _provinceTableView.hidden          = YES;
    }
    return _provinceTableView;
}
- (UITableView *)cityTableView {
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.citySelectLabel.frame.origin.x, self.provinceTableView.frame.origin.y, self.citySelectLabel.frame.size.width + self.citySelectButton.frame.size.width, 80) style:UITableViewStylePlain];
        _cityTableView.backgroundColor = [UIColor whiteColor];
        _cityTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _cityTableView.delegate        = self;
        _cityTableView.dataSource      = self;
        _cityTableView.hidden          = YES;
    }
    return _cityTableView;
}
- (UITableView *)countyTableView {
    if (!_countyTableView) {
        _countyTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.countySelectLabel.frame.origin.x, CGRectGetMaxY(self.countySelectButton.frame) + 10, self.countySelectLabel.frame.size.width + self.countySelectButton.frame.size.width, 80) style:UITableViewStylePlain];
        _countyTableView.backgroundColor = [UIColor whiteColor];
        _countyTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _countyTableView.delegate        = self;
        _countyTableView.dataSource      = self;
        _countyTableView.hidden          = YES;
    }
    return _countyTableView;
}


@end
