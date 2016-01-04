//
//  WPMsgViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/6.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMsgViewController.h"
#import "WPMsgCell.h"

static CGFloat lableWidth = 244.0;
@interface WPMsgViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView * noDataImageView;
@property (nonatomic, strong) NSMutableArray * msgDataSource;
@property (nonatomic, strong) UITableView * msgTableView;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */@end

@implementation WPMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - init
- (void)initializeDataSource {
    NSArray * arr = @[@"您好，您的订单201510010001已确认，接货车辆川A30741，驾驶员李三，电话18117804911，请你准备好货物", @"您好，您的订单201510010001已确认", @"您好，您的订单201510010001已确认，接货车辆川A30741，驾驶员李三，电话13809022025，请你准备好货物", @"您好，账户18117804911成功充值1000.00元，您的账户余额为2541.00元", @"您好，账户18117804911支出1000.00元"];
    self.msgDataSource = [NSMutableArray arrayWithArray:arr];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"消息中心";
    if (self.msgDataSource.count == 0) {
        [self.view addSubview:self.noDataImageView];
    }
    [self.view addSubview:self.msgTableView];
}
#pragma mark - responds events
- (void)respondsToLlongPressDelete:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state ==UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.msgTableView];
        NSIndexPath * indexPath = [self.msgTableView indexPathForRowAtPoint:point];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除信息" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        __weak typeof(self)weakself = self;
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakself.msgDataSource removeObjectAtIndex:indexPath.section];
            [weakself.msgTableView reloadData];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.msgDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgcellIdentity"];
    if (!cell) {
        UINib * nib = [UINib nibWithNibName:@"WPMsgCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    cell.msgContentLabel.attributedText = [self configStringWithString:self.msgDataSource[indexPath.section]];
    UILongPressGestureRecognizer * ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToLlongPressDelete:)];
    [cell addGestureRecognizer:ges];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * head = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 244, 20)];
    head.text = @"10-29 14:00:59";
    head.textAlignment = NSTextAlignmentCenter;
    head.backgroundColor = [UIColor clearColor];
    return head;
}
//设置每一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heiht = [self culculateHeightWithText:self.msgDataSource[indexPath.section] font:[UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()]];
    if ((int)heiht % 40 < 10) {
        heiht += 20;
    }
    return heiht;
}
//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSRange phoneRange = [self.msgDataSource[indexPath.section] rangeOfString:@"电话"];
    if (phoneRange.length == 0|| phoneRange.location == NSNotFound) {
        return;
    }
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",[self.msgDataSource[indexPath.section] substringWithRange:NSMakeRange(phoneRange.location+2, 11)]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
#pragma mark - private menthods
- (CGFloat)culculateHeightWithText:(NSString *)text font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:DHFlexibleSize(CGSizeMake(180, MAXFLOAT), NO)  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.height;
}

- (NSMutableAttributedString *)configStringWithString:(NSString *)string {
    
    NSString * phoneStr = @"电话";
    NSString * topupStr = @"充值";
    NSString * balanceStr = @"余额为";
    NSString * payStr = @"支出";
    
    NSMutableAttributedString * AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange phoneRange = [string rangeOfString:phoneStr];
    NSRange topupRange = [string rangeOfString:topupStr];
    NSRange balanceRange = [string rangeOfString:balanceStr];
    NSRange payRange = [string rangeOfString:payStr];
    
    if (phoneRange.location != NSNotFound && phoneRange.length != 0) {
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(30, 181, 240, 1) range:NSMakeRange(phoneRange.location+2, 11)];
        [AttributedStr addAttribute:NSUnderlineColorAttributeName value:COLOR_RGB(30, 181, 240, 1) range:NSMakeRange(phoneRange.location + 2, 11)];
        [AttributedStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(phoneRange.location+2, 11)];
    }
    if (topupRange.location != NSNotFound && topupRange.length != 0) {
        NSString * yuanStr = @"元";
        NSRange yuanrange = [[string substringFromIndex:topupRange.location] rangeOfString:yuanStr];
        
        if (yuanrange.location != NSNotFound && yuanrange.length != 0) {
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(242, 106, 89, 1) range:NSMakeRange(topupRange.location+2, yuanrange.location - 1)];
        }
        
        
    }
    if (balanceRange.location != NSNotFound && balanceRange.length != 0) {
        NSString * yuanStr = @"元";
        NSRange yuanrange = [[string substringFromIndex:balanceRange.location] rangeOfString:yuanStr];
        
        if (yuanrange.location != NSNotFound && yuanrange.length != 0) {
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(242, 106, 89, 1) range:NSMakeRange(balanceRange.location+3, yuanrange.location - 2)];
        }
    }
    if (payRange.location != NSNotFound && payRange.length != 0) {
        NSString * yuanStr = @"元";
        NSRange yuanrange = [[string substringFromIndex:payRange.location] rangeOfString:yuanStr];
        
        if (yuanrange.location != NSNotFound && yuanrange.length != 0) {
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(242, 106, 89, 1) range:NSMakeRange(payRange.location+2, yuanrange.location - 1)];
        }
    }
    
    return AttributedStr;
    
}
#pragma mark - getter
- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80,  151*80/102) adjustWidth:NO];
            view.center = self.view.center;
            view.image = IMAGE_CONTENT(@"暂无信息null@2x.png");
            view;
        });
    }
    return _noDataImageView;
}
- (UITableView *)msgTableView {
    if (!_msgTableView) {
        _msgTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(38, 64, lableWidth, 568-64), NO) style:UITableViewStyleGrouped];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview.backgroundColor = [UIColor clearColor];
            tableview.showsHorizontalScrollIndicator = NO;
            tableview.showsVerticalScrollIndicator = NO;
            tableview;
        });
    }
    return _msgTableView;
}
@end
