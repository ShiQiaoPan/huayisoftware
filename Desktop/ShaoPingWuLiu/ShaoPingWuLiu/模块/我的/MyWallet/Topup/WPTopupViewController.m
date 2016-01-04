//
//  WPTopupViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/12.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPTopupViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "URL.h"
#import "WPTopUpViewModel.h"

#define SelectBtnTag  10000
#define PartnerID @"2088121369619516"
#define SellerID @"6403796@qq.com"
#define PrivateKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAOUIv78KPoHZd3ptFcyQY4fw7/DTWN7qg/cp/25HPS1F/NybxVeDcr5w8QnQKUIkGsiHv2fCh4SVaQVEJ0RAsa7uRiCeFtaIOHMSLnb3I6MDiBMmeX7BcG1j/B+QYG0ZSQfTS7Dyo58Jc2cdO4HahSXBgR43yn8E+U3XniGFtVgFAgMBAAECgYEA3jO0w8VOi2/OKKp4gbR7u8GXJ9AD4pEnYr4OIJFg2vGRtv4xYQwYYIb2cwzPWmnoyjBZFHN4Qrsp3oAWkHMrbbO0wV+yydqkH0S3wwVJGN5/L1mqzRhFmgN6G5PpfmUERU+VfDkR6tR66ERebCcS1Y5g8kFCYGw4FjrAUXTsAsECQQD2rYDwM+wXcWp5wWNqhGkUnU8uT5cyGcbieEk9q6lr9qr6MkA4sQ6I5RBKwE4HXTtI13bFdo81+V+owxpgYWX5AkEA7bCNPKqQxvboF33qVwgP+QwICNcKT4LE+PuXU9pzAxyDgEasKxocdGO86GfbpqUwBEbMQyELryx/7G1yh7uVbQJBAO70QevtkC1ha3BIesKLQ7N5c2N8LA2XVMa7GM/Jw1PXXecB2J5SPa80neSbhrqxgKVeOyqrX608RYMYhCuLDhkCQHm8uTnfKjOddhXCGenlaTjnHp5YdSFwGq5jPYhnFAz956QljjytLPG3u6NUvj1F0af/EtM286MOqZ5QGB7IxqkCQQDgfBi+vpNYX3IDtgW4psFPizRqIIFf+mieQN0eHoBdHxb6uM2v9k9FNRsrrV+Ye2tFhimcamTliSJg2lz0PgbL"

@interface WPTopupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITextField * moneyCountText;
@property (nonatomic, strong) UIButton * alipayBtn;
@property (nonatomic, strong) UIImageView * topUpStyle;
@property (nonatomic, strong) UITableView * topUpTableView;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign)NSInteger TopUpStyleIndex;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPTopupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    self.TopUpStyleIndex = 0;
}
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text = @"充值";
    [self.view addSubview:self.moneyCountText];
    [self.view addSubview:self.topUpStyle];
    [self.view addSubview:self.topUpTableView];
    [self.view addSubview:self.alipayBtn];
}

#pragma mark - responds events
- (void)respondsToSelectBtn:(UIButton *)sender {
    [self selectTopUpStyleBtn:[NSIndexPath indexPathForItem:sender.tag - SelectBtnTag inSection:0]];
}
- (void)respondsToAlipayBtn {
    if (self.TopUpStyleIndex == 0) {
        [self alipay];
    } else {
        [self weiChatPay];
    }
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = DHFlexibleFrame(CGRectMake(280, 10, 30, 30), YES);
    [btn setImage:IMAGE_CONTENT(@"checkedPay@2x.png") forState:UIControlStateNormal];
    [btn setImage:IMAGE_CONTENT(@"checkedPaySelect@2x.png") forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(respondsToSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = SelectBtnTag + indexPath.row;
    [cell.contentView addSubview:btn];
    if (indexPath.row == 0) {
        btn.selected = YES;
        cell.imageView.image = IMAGE_CONTENT(@"alipay@2x.png");
        cell.textLabel.text = @"支付宝充值";
        cell.detailTextLabel.text = @"您可以通过支付宝充值";
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10*DHFlexibleVerticalMutiplier(), 49*DHFlexibleVerticalMutiplier(), 310*DHFlexibleVerticalMutiplier(), 1)];
        line.backgroundColor = COLOR_RGB(211, 212, 213, 1);
        [cell.contentView addSubview:line];
    } else {
        cell.imageView.image = IMAGE_CONTENT(@"wechatpay@2x.png");
        cell.textLabel.text = @"微信充值";
        cell.detailTextLabel.text = @"您可以通过微信充值";
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*DHFlexibleVerticalMutiplier();
}
//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectTopUpStyleBtn:indexPath];
}
#pragma mark - privae menthod
- (void)selectTopUpStyleBtn:(NSIndexPath *)indexPath {
    for (int i = 0; i < 2; i++) {
        UITableViewCell * cell = [self.topUpTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        ((UIButton *)[cell.contentView viewWithTag:SelectBtnTag + i]).selected = NO;
    }
    UITableViewCell * selectCell = [self.topUpTableView cellForRowAtIndexPath:indexPath];
    ((UIButton *)[selectCell.contentView viewWithTag:SelectBtnTag+ indexPath.row]).selected = YES;
    self.TopUpStyleIndex = indexPath.row;
}
#pragma mark - 支付宝充值
- (void)alipay {
    Order * order = [[Order alloc]init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = [self generateTradeNO];
    order.productName = @"邵平物流充值";
    order.productDescription = @"运费预支";
    order.amount = [NSString stringWithFormat:@"%.2f", 0.01];
    order.notifyURL = [NSString stringWithFormat:@"%@member/tify",BASIC_URL];
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    NSString * appScheme = @"alisdkShaoPingWuLiu";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        __weak typeof(self)weakself = self;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if (resultDic[@"resultStatus"]) {
                switch ([resultDic[@"resultStatus"] integerValue]) {
                    case 6001:
                        [weakself initializeAlertControllerWithMessageAndDismiss:@"您已取消付款"];
                        break;
                    case 6002:
                        [weakself initializeAlertControllerWithMessageAndDismiss:@"网络连接出错"];
                        break;
                    case 4000:
                        [weakself initializeAlertControllerWithMessageAndDismiss:@"订单支付失败"];
                        break;
                    case 8000:
                        [weakself initializeAlertControllerWithMessageAndDismiss:@"订单正在处理中"];
                        break;
                    case 9000:
                        [weakself initializeAlertControllerWithMessageAndDismiss:@"订单支付成功"];
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }
}
#pragma mark - 微信充值
- (void)weiChatPay {
    
}
#pragma mark - topup success
- (void)topUpWithBalance {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor grayColor];
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"充值中...";
   [WPTopUpViewModel submitTopUpWithBalance:self.moneyCountText.text WithSuccessBlock:^(NSString *success) {
       hud.labelText = @"充值成功";
       hud.detailsLabelText = nil;
       [hud hide:YES afterDelay:1.0];
   } failBlock:^(NSString *error) {
       hud.labelText = @"充值失败";
       hud.detailsLabelText = error;
       [hud hide:YES afterDelay:1.0];
   }];
}
#pragma mark - 充值订单生成
- (NSString *)generateTradeNO
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSDate * date = [NSDate date];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    NSString * basicNO = [NSString stringWithFormat:@"ShaoPingWuLiuAlipay%@%@", timeStr, [UserModel defaultUser].userID];
    NSMutableString * tradeNO = [NSMutableString stringWithString:basicNO];
    if (basicNO.length < 39) {
        for (int i = 0; i < 39 - basicNO.length; i++) {
            [tradeNO insertString:@"0" atIndex:tradeNO.length];
        }
    } else {
        [tradeNO substringToIndex:39];
    }
    return tradeNO;
}
#pragma mark - getter
- (UITextField *)moneyCountText {
    if (!_moneyCountText) {
        _moneyCountText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 80, ORIGIN_WIDTH, 40) adjustWidth:NO];
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40) adjustWidth:NO];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40) adjustWidth:NO];
            [leftView addSubview:lab];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = leftView;
            lab.text = @"充值金额：";
            lab.textColor = GARYTextColor;
            text.backgroundColor = [UIColor whiteColor];
            text.placeholder = @"（请输入充值金额）";
            text.keyboardType = UIKeyboardTypeDecimalPad;
            text.clearButtonMode = UITextFieldViewModeAlways;
            text;
        });
    }
    return _moneyCountText;
}
- (UIImageView *)topUpStyle {
    if (!_topUpStyle) {
        _topUpStyle = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyCountText.frame)/DHFlexibleVerticalMutiplier() + 15, 320, 40) adjustWidth:NO];
            view.image = IMAGE_CONTENT(@"topUpStyle@2x.png");
            view;
        });
    }
    return _topUpStyle;
}
- (UITableView *)topUpTableView {
    if (!_topUpTableView) {
        _topUpTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, CGRectGetMaxY(self.topUpStyle.frame)/DHFlexibleVerticalMutiplier(), ORIGIN_WIDTH, 100), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.scrollEnabled = NO;
            tableview.separatorColor = [UIColor clearColor];
            tableview;
        });
    }
    return _topUpTableView;
}

- (UIButton *)alipayBtn {
    if (!_alipayBtn) {
        _alipayBtn = ({
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.topUpTableView.frame)/DHFlexibleVerticalMutiplier()+40, 300, 40) adjustWidth:NO];
            [btn setTitle:@"充值" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10;
            [btn addTarget:self action:@selector(respondsToAlipayBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _alipayBtn;
}
@end
