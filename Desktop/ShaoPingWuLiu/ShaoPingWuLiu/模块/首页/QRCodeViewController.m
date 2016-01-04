//
//  QRCodeViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/25.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)UIButton         * backButton;/**< 返回按钮 */
@property (nonatomic, strong)AVCaptureSession * session;   /**< 输入输出桥梁协调数据从输入设备到输出对象 */
@property (nonatomic, strong)AVCaptureDevice  * device;    /**< 设备 */
@property (nonatomic, strong)AVCaptureDeviceInput       * input;  /**< 输入 */
@property (nonatomic, strong)AVCaptureMetadataOutput    * output; /**< 输出 */
@property (nonatomic, strong)AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, strong)UIImageView * centerView;/**< 中央扫描区域 */
@property (nonatomic, strong)UIView      * leftView;  /**< 左边遮罩区域 */
@property (nonatomic, strong)UIView      * rightView; /**< 右边遮罩区域 */
@property (nonatomic, strong)UIView      * upView;    /**< 上边遮罩区域 */
@property (nonatomic, strong)UIView      * downView;  /**< 下边遮罩区域 */
@property (nonatomic, strong)UIImageView * lineView;  /**< 扫描框中间的线 */
@property (nonatomic, strong)UILabel     * msgLabel;  /**< 提示文本 */

- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
    [self.view addSubview:self.upView];
    [self.view addSubview:self.downView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.msgLabel];
    [self.view addSubview:self.backButton];
    if (![self.session canAddInput:self.input] || ![self.session canAddOutput:self.output]) {
        return;
    }
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    /**< 右上角为原点高宽互换了 */
    self.output.rectOfInterest = CGRectMake(CGRectGetMinY(self.centerView.frame)/self.view.frame.size.height,1- CGRectGetMaxX(self.centerView.frame)/self.view.frame.size.width, CGRectGetHeight(self.centerView.frame)/self.view.frame.size.height, CGRectGetWidth(self.centerView.frame)/self.view.frame.size.width);
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
    
}
#pragma mark - responds events
- (void)respondsToBackBtn:(UIButton *)sender {
    [self.session stopRunning];
    self.session = nil;
    [self.previewLayer removeFromSuperlayer];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - system protocol
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (self.isHome) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"homeScan" object:metadataObject.stringValue userInfo:nil];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"detailScan" object:metadataObject.stringValue userInfo:nil];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(CGRectGetMidX(self.centerView.frame)-30, CGRectGetMaxY(self.msgLabel.frame), 60, 40);
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:25]];
            [btn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _backButton;
}
- (AVCaptureDevice *)device {
    if (!_device) {
        //获取摄像设备
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
- (AVCaptureDeviceInput *)input {
    if (!_input) {
        _input = ({
            AVCaptureDeviceInput * put = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
            put;
        });
    }
    return _input;
}
- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        _output = ({
            AVCaptureMetadataOutput * put = [[AVCaptureMetadataOutput alloc]init];
            [put setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            put;
        });
    }
    return _output;
}
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = ({
            AVCaptureVideoPreviewLayer * layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            layer.frame = self.view.layer.bounds;
            layer;
        });
    }
    return _previewLayer;
}
- (UIImageView *)centerView {
    if (!_centerView) {
        _centerView = ({
            UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ORIGIN_WIDTH-60, ORIGIN_WIDTH-60) adjustWidth:YES];
            centerView.center = self.view.center;
            centerView.image = IMAGE_CONTENT(@"扫描框@2x.png");
            centerView.contentMode = UIViewContentModeScaleAspectFit;
            centerView.backgroundColor = [UIColor clearColor];
            centerView;
        });
    }
    return _centerView;
}
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = ({
            //左侧的view
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(self.centerView.frame), ORIGIN_HEIGHT*DHFlexibleVerticalMutiplier())];
            view.alpha = 0.5;
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _leftView;
}
- (UIView *)rightView {
    if (!_rightView) {
        _rightView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.centerView.frame), 0, ORIGIN_WIDTH * DHFlexibleHorizontalMutiplier() - CGRectGetMaxX(self.centerView.frame), ORIGIN_HEIGHT*DHFlexibleVerticalMutiplier())];
            view.alpha = 0.5;
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _rightView;
}
- (UIView *)upView {
    if (!_upView) {
        _upView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.centerView.frame), 0, CGRectGetWidth(self.centerView.frame), CGRectGetMinY(self.centerView.frame))];
            view.alpha = 0.5;
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _upView;
}
- (UIView *)downView {
    if (!_downView) {
        _downView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.centerView.frame), CGRectGetMaxY(self.centerView.frame), CGRectGetWidth(self.centerView.frame), ORIGIN_HEIGHT*DHFlexibleVerticalMutiplier() - CGRectGetMaxY(self.centerView.frame))];
            view.alpha = 0.5;
            view.backgroundColor = [UIColor blackColor];
            view;
        });
    }
    return _downView;
}
- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = ({
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.centerView.frame), 2)];
            line.image = IMAGE_CONTENT(@"扫描线@2x.png");
            line.center = self.view.center;
            line.contentMode = UIViewContentModeScaleAspectFill;
            line.backgroundColor = [UIColor clearColor];
            line;
        });
    }
    return _lineView;
}
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = ({
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.centerView.frame)+20, self.view.frame.size.width, 40)];
            lab.text = @"将二维码放入框内,即可自动扫描";
            lab.textAlignment = NSTextAlignmentCenter;
            lab;
        });
    }
    return _msgLabel;
}
@end
