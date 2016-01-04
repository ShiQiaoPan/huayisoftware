//
//  LatticeSearchViewController.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/10.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYLatticeSearchViewController.h"
#import "RYSearchResultTableViewCell.h"
#import "RYPickingGoodsViewController.h"
#import "RYSearchResult.h"

#define keyWords @"绍平物流"

@interface RYLatticeSearchViewController () <UISearchBarDelegate,MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate, SearchCellDelegate>

- (void)initializeDataSource;    /**< 初始化数据源   */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation RYLatticeSearchViewController {
    UIScrollView   *thyScrollow;     // 背景Scrollow
    UISearchBar    *thySearchBar;    // 搜索栏
    UITableView    *thyTableView;    // 表
    NSMutableArray *allDataArray;    // 数据源
    NSMutableArray *searchResults;   // 有效数据源
    MAMapView      *thyMapView;      // 地图
    AMapSearchAPI  *thyNearSearch;   // 附近搜索
    CLLocation     *currentLocation; // 当前定位位置
    NSMutableArray *annotations;     // 大头针s
    RYSearchResult *currentModel;    // 当前model
    UITableView    *bottomTB;        // 底部表
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    currentLocation = nil;
    if (thyTableView && searchResults.count) {
        [thyTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    if (!allDataArray) { allDataArray  = [NSMutableArray array];}
    if (!searchResults) { searchResults = [NSMutableArray array];}
    if (!annotations) { annotations   = [NSMutableArray array];}
}
- (void) initializeUserInterface {
    [self.rightButton setTitle:@"地图" forState:UIControlStateNormal];
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"网点查询";
    [self createThySearchBar];
    [self createThyScrollowView];
    [self createThyTableView];
    [self initThyMapView];
    [self initThyNearSearch];
}

#pragma mark - 创建Scrollow
- (void) createThyScrollowView {
    if (!thyScrollow) {
        thyScrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thySearchBar.frame), SCREEN_SIZE.width, SCREEN_SIZE.height - self.baseNavigationBar.frame.size.height - thySearchBar.frame.size.height)];
        thyScrollow.scrollEnabled   = NO;
        thyScrollow.contentSize     = CGSizeMake(thyScrollow.frame.size.width * 2, thyScrollow.frame.size.height);
        thyScrollow.contentOffset   = CGPointMake(0, 0);
        [self.view addSubview:thyScrollow];
    }
}

#pragma mark - 创建searchBar
- (void) createThySearchBar {
    if (!thySearchBar) {
        thySearchBar             = [[UISearchBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.baseNavigationBar.frame), SCREEN_SIZE.width, NavBar_Height)];
        thySearchBar.placeholder = @"请输入城市、营业部名称";
        thySearchBar.delegate    = self;
        [self.view addSubview:thySearchBar];
    }
}

#pragma mark - 创建表
- (void) createThyTableView {
    if (!thyTableView) {
        thyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, thyScrollow.frame.size.width, thyScrollow.frame.size.height) style:UITableViewStylePlain];
        thyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        thyTableView.dataSource     = self;
        thyTableView.delegate       = self;
        [thyScrollow addSubview:thyTableView];
    }
}

#pragma mark - 导航右按钮回调方法
- (void) respondsToNavBarRightButton:(UIButton *) sender {
    sender.hidden             = YES;
    [thySearchBar resignFirstResponder];
    thyScrollow.contentOffset = CGPointMake(thyScrollow.frame.size.width, 0);
    [self hideBottomTB];
}

#pragma mark - 导航左按钮回调方法
- (void) respondsToNavBarLeftButton {
    if (thyScrollow.contentOffset.x == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [thySearchBar resignFirstResponder];
        thyScrollow.contentOffset   = CGPointMake(0, 0);
        self.rightButton.hidden     = NO;
    }
}
#pragma mark - searchBarDelegate
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hideBottomTB];
    [thySearchBar resignFirstResponder];
    [self reloadDataArrayWithSearchWords:thySearchBar.text];
}

#pragma mark - init
- (void) initThyMapView {
    if (!thyMapView) {
        [MAMapServices sharedServices].apiKey = gaoDeKey;
        thyMapView = [[MAMapView alloc] initWithFrame:CGRectMake(thyScrollow.frame.size.width, 0, thyScrollow.frame.size.width, thyScrollow.frame.size.height)];
        thyMapView.delegate                   = self;
        thyMapView.showsUserLocation          = YES;
        thyMapView.showsCompass               = NO;
        thyMapView.showsScale                 = NO;
        [thyScrollow addSubview:thyMapView];
    }
}
- (void) initThyNearSearch {
    if (!thyNearSearch) {
        thyNearSearch = [[AMapSearchAPI alloc] initWithSearchKey:gaoDeKey Delegate:self];
    }
}

#pragma mark - searchKit方法
- (void) reGeoAction {
    if (currentLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location   = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        [thyNearSearch AMapReGoecodeSearch:request];
    }
}
- (void) placeSearchAction{
    NSLog(@"搜索------------");
    if (currentLocation) {
        NSLog(@"搜索11111111");
        AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
        request.location   = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        request.radius     = 30000;
        request.city       = @[@"成都"];
        request.sortrule   = 1;
        request.searchType = AMapSearchType_PlaceAround;
        request.keywords   = keyWords;
        [thyNearSearch AMapPlaceSearch:request];
    }
}

#pragma mark - 具体信息
- (void) alertViewWith:(MAAnnotationView *) view {
    if (!bottomTB) {
        float height;
        if (SCREEN_SIZE.width == 320) { height =170;}
        else { height = 200;}
        bottomTB = [[UITableView alloc] initWithFrame:CGRectMake(0, thyMapView.frame.size.height - height, thyMapView.frame.size.width, height) style:UITableViewStylePlain];
        bottomTB.separatorStyle = UITableViewCellSeparatorStyleNone;
        bottomTB.dataSource     = self;
        bottomTB.delegate       = self;
        bottomTB.scrollEnabled  = NO;
        [thyMapView addSubview:bottomTB];
    }
    else {
        [bottomTB reloadData];
        if (bottomTB.hidden) { bottomTB.hidden = NO; }
    }
    for (RYSearchResult *model in searchResults) {
        if (model.result_location.latitude == view.annotation.coordinate.latitude && model.result_location.longitude == view.annotation.coordinate.longitude) { currentModel = model; }
    }
}
#pragma mark - 隐藏底部表
- (void) hideBottomTB {
    if (bottomTB && !bottomTB.hidden) { bottomTB.hidden = YES; }
}
#pragma mark - Handle URL Scheme
- (NSString *)getApplicationName{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

- (NSString *)getApplicationScheme{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    return scheme;
}
#pragma mark - SearchCellDelegate
- (void)searchCellSegClickWithSegIndex:(NSInteger)index and:(RYSearchResult *)model{
    if (!index) {
        [self.navigationController pushViewController:[RYPickingGoodsViewController new] animated:YES]; }
    else {
        MARouteConfig *config  = [MARouteConfig new];
        config.startCoordinate = currentLocation.coordinate;
        config.destinationCoordinate = CLLocationCoordinate2DMake(model.result_location.latitude, model.result_location.longitude);
        config.appName         = [self getApplicationName];
        config.appScheme       = [self getApplicationScheme];
        config.routeType       = MARouteSearchTypeDriving;
        config.transitStrategy = MATransitStrategyFastest;
        config.drivingStrategy = MADrivingStrategyShortest;
        if (![MAMapURLSearch openAMapRouteSearch:config]) {
            [MAMapURLSearch getLatestAMapApp];
        }
    }
}
#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    static int i = 0;
    if (updatingLocation && !currentLocation) {
        currentLocation = [userLocation.location copy];
        [self placeSearchAction];
        [thyMapView setCenterCoordinate:currentLocation.coordinate animated:YES];
    }
    if (!i && !currentLocation) {
        [self initializeAlertControllerWithMessage:@"定位失败,请检查本应用GPS是否开启"];
    }
    i++;
}
- (void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    { [self reGeoAction]; }
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        view.image = [UIImage imageNamed:@"select_search_position"];
        [self alertViewWith:view];
    }
}
- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        view.image = [UIImage imageNamed:@"deselect_search_position"];
    }
}

- (MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier    = @"annotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView   = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"deselect_search_position"];
        annotationView.canShowCallout = NO;
        annotationView.centerOffset   = CGPointMake(0, -18);
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *reuseIndetifier    = @"annotationUserLoIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView   = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"user_location"];
        annotationView.canShowCallout = NO;
        annotationView.centerOffset   = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void) searchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"request :%@, error :%@", request, error);
}
- (void) onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    { title = response.regeocode.addressComponent.province; }
    thyMapView.userLocation.title    = title;
    thyMapView.userLocation.subtitle = response.regeocode.formattedAddress;
}
- (void) onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response {
    NSLog(@"搜索结果－－－－－－－－－－－－－");
    NSLog(@"%ld",(long)response.count);
    NSLog(@"%@", response.suggestion);
    [allDataArray removeAllObjects];
    for (AMapPOI *p in response.pois) {
        NSLog(@"%@", p.description);
        RYSearchResult *model = [RYSearchResult new];
        model.result_name     = p.name;
        model.result_distance = p.distance;
        model.result_tel      = p.tel;
        model.result_address  = p.address;
        model.result_location = p.location;
        [allDataArray addObject:model];
    }
    [self reloadDataArrayWithSearchWords:nil];
}
#pragma mark - dataArray重新加载
- (void) reloadDataArrayWithSearchWords:(NSString *) searchWords {
    if (!searchWords) { searchResults = [allDataArray mutableCopy];}
    else {
        [searchResults removeAllObjects];
        for (RYSearchResult *model in allDataArray) {
            if ([model.result_name rangeOfString:searchWords].location != NSNotFound || [model.result_address rangeOfString:searchWords].location != NSNotFound) { [searchResults addObject:model];
            }
        }
    }
    [thyMapView removeAnnotations:annotations];
    [annotations removeAllObjects];
    [thyTableView reloadData];
    if (searchResults.count) {
        for (RYSearchResult *model in searchResults) {
            MAPointAnnotation *annotation = [MAPointAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(model.result_location.latitude, model.result_location.longitude);
            [thyMapView addAnnotation:annotation];
            [annotations addObject:annotation];
        }
    }
    else { [self initializeAlertControllerWithMessage:@"暂无搜索结果"]; }
}

#pragma mark - tableView delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == thyTableView) { return searchResults.count;}
    else if (tableView == bottomTB) { return 1;}
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier  = @"searchResultCell";
    RYSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell              = [[[NSBundle mainBundle] loadNibNamed:@"RYSearchResultTableViewCell" owner:self options:nil] lastObject];
    }
    if (tableView        == thyTableView) { [cell setModel:searchResults[indexPath.row]];}
    else if (tableView   == bottomTB) { [cell setModel:currentModel];}
    cell.delegate         = self;
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"内存警告");
    [super didReceiveMemoryWarning];
}

@end
