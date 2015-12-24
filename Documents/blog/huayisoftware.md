#改变segement字体


    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20],NSFontAttributeName ,nil];
    [control setTitleTextAttributes:dic forState:UIControlStateNormal];
    

#画虚线
     
     - (void)addDottedLine {
		    CAShapeLayer * layer = [CAShapeLayer layer];
	    layer.frame = self.view.bounds;
	    layer.fillColor = [UIColor clearColor].CGColor;
	    [layer setLineWidth:1];
	    [layer setLineJoin:kCALineJoinRound];
	    [layer setLineDashPattern:[NSArray arrayWithObjects:@(5), @(6), nil]];
	    layer.path = self.path.CGPath;
	    layer.backgroundColor = [UIColor clearColor].CGColor;
	    layer.strokeColor = REDBGCOLOR.CGColor;          /**< 画笔颜色 */
	    [self.memberScrollView.layer addSublayer:layer];
}
#获取长按手势


        CGPoint point = [gesture locationInView:self.msgTableView];
        NSIndexPath * indexPath = [self.msgTableView indexPathForRowAtPoint:point];
        
        
#支付宝集成
1. 导入支付宝sdk包括
   (1) alipaySDK.bundle
   
   (2)alipaySDK.framework
   
   (3)APAuthV2Info.h/APAuthV2Info.m
   
   (4)libcrypto.a
   
   (5)libssl.a
   
   (6)openssl可以生成私钥
      
      1）.终端输入 openssl
      
      2) .生成私钥 genrsa -out rsa_private_key.pem 1024
      
      3) .生成公钥 rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
      
      4) .将私钥转为pkcs8格式pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt
   
   (7)order.h
   
   (8)util
   
   报错-v可以在build setting - search ->header search path 拖入一次装支付宝sdk的文件夹
   
2. 导入依赖库 alipaySDK.framework/systemconfiguration.framework/coreTelephony.framework/quartzCore.framework/libz.dylib/coreText.framework/CoreGraphics.framework/UIKit.framework/Foundation.framework/libssl.a/libcrypto.a
3. 添加白名单 target--> info-->添加NSAllowsArbitraryLoads --布尔值--yes
-->新建key为LSApplicationQueriesSchemes 的数组添加
alipay/alipayshare
4. 调用支付接口参数必传 价格最多保留2位小数


#
       Order * order = [[Order alloc]init];
	    order.partner = PartnerID;//支付宝的账号
	    order.seller = SellerID;//支付宝的收钱ID
	    order.tradeNO = [self generateTradeNO];//订单号
	    order.productName = @"充值";//商品标题
	    order.productDescription = @"运费预支";//商品描述
	    order.amount = [NSString stringWithFormat:@"%.2f", 0.01];//需要支付多少钱
	    order.notifyURL = BASIC_URL;//支付完成回调接口(通知服务器端交易结果)
	    order.service = @"mobile.securitypay.pay";//接口名称，固定值
	    order.paymentType = @"1";//支付类型默认为1商品购买
	    order.inputCharset = @"utf-8";//参数编码字符集商户网站使用的编码格式固定为utf-8
	    order.itBPay = @"30m";//未付款交易的超时时间
	    order.showUrl = @"m.alipay.com";
	    //回调的app
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
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }
    #oc

[ios9适配]<http://www.jianshu.com/p/a8cce94d508e>

[MACDown语法]<http://www.appinn.com/markdown>
#微信支付
 