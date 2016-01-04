//
//  WPAreaPickView.m
//  picker
//
//  Created by WeiPan on 15/11/27.
//  Copyright © 2015年 Sylar. All rights reserved.
//

#import "WPAreaPickView.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface WPAreaPickView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView * pickView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * determineButton;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, copy) void (^complete)(NSMutableArray *result);
@property (nonatomic, strong)NSDictionary * areaDic;/**< 初始数据源 */
@property (nonatomic, strong)NSMutableArray * province;/**< 省份数组 */
@property (nonatomic, strong)NSMutableArray * city;/**< 城市数组 */
@property (nonatomic, strong)NSMutableArray * district;/**< 地区数组 */
@property (nonatomic, copy)NSString * selectedProvince;/**< 选中的省份 */

@end
@implementation WPAreaPickView
+ (WPAreaPickView *)showViewWithcomplete:(void(^)(NSMutableArray *result))complete {
    WPAreaPickView * pickview = [[WPAreaPickView alloc]initWithComplete:complete];
    [pickview show];
    return pickview;
}
- (instancetype)initWithComplete:(void(^)(NSMutableArray *date))complete {
    self = [super init];
    if (self) {
        self.complete = complete;
        [self initDataSource];
        [self initalizeUserInterface];
    }
    return self;
}
- (void)initDataSource {
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    self.areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    /**< 省份排序 */
    NSArray * components = [self.areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    self.province = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sortedArray count]; i++) {
        NSString * index = [sortedArray objectAtIndex:i];
        NSArray * tmp = [[self.areaDic objectForKey: index] allKeys];
        [self.province addObject: [tmp objectAtIndex:0]];
    }
    
    NSString * index = [sortedArray objectAtIndex:0];
    NSString * selectedProvince = [self.province objectAtIndex:0];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [[self.areaDic objectForKey:index]objectForKey:selectedProvince]];
    
    NSArray * cityArray = [dic allKeys];
    NSDictionary * cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    self.city = [[NSMutableArray alloc] initWithArray: [cityDic allKeys]];
    
    NSString * selectedCity = [self.city objectAtIndex: 0];
    self.district = [[NSMutableArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
}
- (void)initalizeUserInterface {
    [self addSubview:self.titleLabel];
    [self addSubview:self.determineButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.pickView];
}
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - 50)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 50)];
    path.lineWidth = 2;
    UIColor *color = [UIColor orangeColor];
    [color setStroke];
    [path stroke];
}

#pragma mark - responds events
- (void)confirmation {
    NSMutableArray * array = [NSMutableArray array];
    NSInteger provinceIndex = [self.pickView selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self.pickView selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [self.pickView selectedRowInComponent:DISTRICT_COMPONENT];
    
    NSString * provinceStr = [self.province objectAtIndex:provinceIndex];
    NSString * cityStr = [self.city objectAtIndex: cityIndex];
    NSString * districtStr = [self.district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    [array addObject:provinceStr];
    [array addObject:cityStr];
    [array addObject:districtStr];
    _complete(array);
    [self hide];
}
#pragma mark---协议UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == PROVINCE_COMPONENT) {
        return [self.province count];
    }
    else if (component == CITY_COMPONENT) {
        return [self.city count];
    }
    else {
        return [self.district count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == PROVINCE_COMPONENT) {
        return [self.province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [self.city objectAtIndex: row];
    }
    else {
        return [self.district objectAtIndex: row];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
        myView.adjustsFontSizeToFitWidth = YES;
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.adjustsFontSizeToFitWidth = YES;
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        self.selectedProvince = [self.province objectAtIndex: row];
        NSDictionary * tmp = [NSDictionary dictionaryWithDictionary: [self.areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: self.selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        if (self.city.count > 0) {
            [self.city removeAllObjects];
        }
        self.city = [[NSMutableArray alloc] initWithArray: array];
        if (self.district.count > 0) {
            [self.district removeAllObjects];
        }
        NSDictionary * cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        self.district = [[NSMutableArray alloc] initWithArray: [cityDic objectForKey: [self.city objectAtIndex: 0]]];
        [self.pickView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [self.pickView  selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.pickView  reloadComponent: CITY_COMPONENT];
        [self.pickView  reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [self.province indexOfObject: self.selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:[self.areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: self.selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        if (self.district.count > 0) {
            [self.district removeAllObjects];
        }
        self.district = [[NSMutableArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [self.pickView  selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.pickView  reloadComponent: DISTRICT_COMPONENT];
    }
}
#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
            label.backgroundColor = [UIColor orangeColor];
            label.text = @"地址选择";
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithRed:232/255.0 green:233/255.0 blue:232/255.0 alpha:1];
            label;
        });
    }
    return _titleLabel;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelbutton.frame = CGRectMake(10, CGRectGetHeight(self.bounds) - 40, 50, 37);
            cancelbutton.backgroundColor = [UIColor orangeColor];
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelbutton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            cancelbutton;
        });
    }
    return _cancelButton;
}
- (UIButton *)determineButton {
    if (!_determineButton) {
        _determineButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60, CGRectGetHeight(self.bounds) - 40, 50, 37);
            button.backgroundColor = [UIColor orangeColor];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(confirmation) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _determineButton;
}
- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = ({
            UIPickerView * view = [[UIPickerView alloc]init];
            view.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.95, CGRectGetHeight(self.bounds) * 0.5);
            view.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
            view.dataSource = self;
            view.delegate = self;
            view.showsSelectionIndicator = NO;
            view;
        });
    }
    return _pickView;
}


@end
