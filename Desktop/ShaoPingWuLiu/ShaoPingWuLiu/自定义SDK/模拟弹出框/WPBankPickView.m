//
//  WPAnyPickView.m
//  LikeAlertView
//
//  Created by rimi on 15/9/7.
//  Copyright © 2015年 魏攀. All rights reserved.
//

#import "WPBankPickView.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPBankPickView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSources;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * determineButton;
@property (nonatomic, strong) UIView * footView;
@property (nonatomic, copy) void (^complete)(NSMutableDictionary *result);
@end
@implementation WPBankPickView

+ (WPBankPickView *)showViewWithDataSources:(NSArray *)dataSource complete:(void (^)(NSMutableDictionary *))complete{
    WPBankPickView * pickview = [[WPBankPickView alloc]initWithDataSources:dataSource complete:complete];
    [pickview show];
    return pickview;
}
- (instancetype)initWithDataSources:(NSArray *)dataSource complete:(void(^)(NSMutableDictionary *date))complete {
    if (dataSource.count < 3) {
        self = [super initWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.7, dataSource.count * 40 + 120)];
    } else {
        self = [super initWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.7, 300)];
    }
    
    if (self) {
        self.dataSources = dataSource;
        self.complete = complete;
        [self initalizeUserInterface];
    }
    return self;
}
- (void)initalizeUserInterface {
    [self addSubview:self.titleLabel];
    [self addSubview:self.determineButton];
    [self addSubview:self.tableView];
}
#pragma mark - responds events
- (void)respondsToSelectionBtn:(UIButton *)sender {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSources[sender.tag]];
    [dic setObject:cell.textLabel.text forKey:@"bankAndCard"];
    self.complete(dic);
    [self hide];
}
- (void)confirmation {
    self.complete([NSMutableDictionary dictionary]);
    [self hide];
}
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * cardNum = self.dataSources[indexPath.row][@"cardnumber"];
    NSString * fourCardNum = [cardNum substringFromIndex:cardNum.length - 4];
    NSString * bankName = self.dataSources[indexPath.row][@"bankname"];
    NSRange dianRange = [bankName rangeOfString:@"·"];
    if (dianRange.location != NSNotFound && dianRange.length != 0) {
        NSString * onlyBankName = [bankName substringToIndex:dianRange.location];
        NSString * bankcard = [NSString stringWithFormat:@"%@(%@)", onlyBankName, fourCardNum];
        cell.textLabel.text = bankcard;
    } else {
        NSString * bankcard = [NSString stringWithFormat:@"%@(%@)", bankName, fourCardNum];
        cell.textLabel.text = bankcard;
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 60, 5, 30, 30);
    [btn setImage:IMAGE_CONTENT(@"checked_1.png") forState:UIControlStateNormal];
    [btn setImage:IMAGE_CONTENT(@"checked.png") forState:UIControlStateSelected];
    btn.tag = indexPath.row;
    
    
    [btn addTarget:self action:@selector(respondsToSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    return cell;
}
#pragma mark - UITableViewDelegate
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSources[indexPath.row]];
    [dic setObject:cell.textLabel.text forKey:@"bankAndCard"];
    self.complete(dic);
    [self hide];
}
#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40)];
            label.text = @"选择银行卡";
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _titleLabel;
}

- (UIButton *)determineButton {
    if (!_determineButton) {
        _determineButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60, CGRectGetHeight(self.bounds) - 40, 50, 40);
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button setTitleColor:COLOR_RGB(57, 162, 252, 1) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _determineButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height - CGRectGetHeight(self.titleLabel.bounds)-CGRectGetHeight(self.determineButton.bounds)) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.pagingEnabled = NO;
            tableview.separatorColor = [UIColor grayColor];
            tableview.tableFooterView = self.footView;
            tableview;
        });
    }
    return _tableView;
}
- (UIView *)footView {
    if (!_footView) {
        _footView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.bounds) - 20, 40)];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bounds)- 20, 40)];
            lab.adjustsFontSizeToFitWidth = YES;
            lab.text = @"使用其他银行卡";
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmation)];
            [view addGestureRecognizer:ges];
            [view addSubview:lab];
            view;
        });
    }
    return _footView;
}
@end
