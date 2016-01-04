//
//  WPDriverCardViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/24.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPDriverCardViewController.h"
#import "NetWorkingManager+TruckBasic.h"
#import "ImageHandle.h"


@interface WPDriverCardViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIBezierPath * linepath;
@property (nonatomic, strong) UITextField * titleText;
@property (nonatomic, strong) UITextField * truckNumText;
@property (nonatomic, strong) UITextField * truckCardText;
@property (nonatomic, strong) UIButton * carambBtn;
@property (nonatomic, strong) UIImageView * introImage;
@property (nonatomic, strong) UITextField * introText;
@property (nonatomic, strong) UIButton * submintBtn;
@property (nonatomic, strong) UIImagePickerController * imagePickerVC;
@property (nonatomic, assign) UIImagePickerControllerSourceType imageSource;

- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPDriverCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    [self.rightButton removeFromSuperview];
    self.titleLable.text = @"车辆";
    [self.view addSubview:self.titleText];
    [self addLineWithYPosition:CGRectGetMaxY(self.titleText.frame)];
    [self.view addSubview:self.truckNumText];
    [self addLineWithYPosition:CGRectGetMaxY(self.truckNumText.frame)];
    [self.view addSubview:self.truckCardText];
    [self addLineWithYPosition:CGRectGetMaxY(self.truckCardText.frame)];
    [self.view addSubview:self.carambBtn];
    [self.view addSubview:self.introImage];
    [self.view addSubview:self.introText];
    [self.view addSubview:self.submintBtn];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.view.bounds;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = COLOR_RGB(210, 211, 212, 1).CGColor;/**< 画笔颜色 */
    layer.path = self.linepath.CGPath;
    [self.view.layer addSublayer:layer];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToCaramBtn {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        __weak typeof(self)weakself = self;
        weakself.imageSource = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakself presentViewController:self.imagePickerVC animated:YES completion:nil];
    }];;
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        __weak typeof(self)weakself = self;
        self.imageSource = UIImagePickerControllerSourceTypeCamera;
        [weakself presentViewController:self.imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"从图库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        __weak typeof(self)weakself = self;
        self.imageSource = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [weakself presentViewController:self.imagePickerVC animated:YES completion:nil];
        
    }];
    // 判断是否支持相机
    [alertVC addAction:cancelAction];
    [alertVC addAction:deleteAction];
    [alertVC addAction:imageAction];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertVC addAction:archiveAction];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)respondsToSubmintBtn {
    if (self.truckNumText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写车牌号"];
        return;
    }
    if (self.truckCardText.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写车辆行驶证号"];
        return;
    }
    NSData* imageData = [NSData data];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(self.introImage.image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(self.introImage.image);
    }
    else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(self.introImage.image, 1.0);
    }
    if (!imageData.bytes) {
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"正在上传";
    __weak typeof(self)weakself = self;
    [NetWorkingManager submitTruckBasicWithDrivinglicense:self.truckCardText.text andPlateNumber:self.truckNumText.text imageData:imageData andImageFile:@"driveCard.png" successHandler:^(id responseObject, AFHTTPRequestOperation *operation) {
        if ([((NSDictionary *)operation)[@"code"] integerValue] == 0) {
            hud.labelText = @"上传成功";
            hud.detailsLabelText = @"请耐心等待审核通过";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        } else {
            hud.labelText = @"上传失败";
            if (((NSDictionary *)operation)[@"errMsg"]) {
                hud.detailsLabelText = ((NSDictionary *)operation)[@"errMsg"];
            } else {
                hud.detailsLabelText = @"未知错误";
            }
        }
        [hud hide:YES afterDelay:1.0];

    } failureHandler:^(id responseObject, NSError *error) {
        hud.labelText = @"上传失败";
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:2.0];

    }];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    UIImage * showImage = [ImageHandle imageWithImageSimple:image scaledToSize:DHFlexibleSize(CGSizeMake(160, 130), YES)];
    self.introImage.image = showImage;
}
#pragma mark - private methods
- (void)addLineWithYPosition :(CGFloat)y {
    [self.linepath moveToPoint:CGPointMake(0, y)];
    [self.linepath addLineToPoint:CGPointMake(320*DHFlexibleHorizontalMutiplier(), y)];
    self.linepath.lineWidth = 1;
}
#pragma mark - getter
- (UITextField *)titleText {
    if (!_titleText) {
        _titleText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, 74, 320, 40) adjustWidth:NO];
            text.userInteractionEnabled = NO;
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = leftView;
            text.text = @"绑定信息（必填）";
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _titleText;
}
- (UITextField *)truckNumText {
    if (!_truckNumText) {
        _truckNumText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleText.frame), 320*DHFlexibleHorizontalMutiplier(), 40*DHFlexibleVerticalMutiplier())];
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = leftView;
            text.placeholder = @"车牌号";
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _truckNumText;
}
- (UITextField *)truckCardText {
    if (!_truckCardText) {
        _truckCardText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.truckNumText.frame), 320*DHFlexibleHorizontalMutiplier(), 40*DHFlexibleVerticalMutiplier())];
            UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40) adjustWidth:NO];
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = leftView;
            text.placeholder = @"车辆行驶证号";
            text.backgroundColor = [UIColor whiteColor];
            text;
        });
    }
    return _truckCardText;
}
- (UIButton *)carambBtn {
    if (!_carambBtn) {
        _carambBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(40, CGRectGetMaxY(self.truckCardText.frame)/DHFlexibleVerticalMutiplier()+50, 40, 40), YES);
            [btn setImage:IMAGE_CONTENT(@"camera.png") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(respondsToCaramBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;

        });
    }
    return _carambBtn;
}
- (UIImageView *)introImage {
    if (!_introImage) {
        _introImage = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(140, CGRectGetMaxY(self.truckCardText.frame)/DHFlexibleVerticalMutiplier()+10, 160, 130) adjustWidth:YES];
            view.image = IMAGE_CONTENT(@"truckIntroBg.png");
            view;
        });
    }
    return _introImage;
}
- (UITextField *)introText {
    if (!_introText) {
        _introText = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.introImage.frame)/DHFlexibleVerticalMutiplier(), 310, 30) adjustWidth:NO];
            text.text = @"审核通过之后才能使用后续功能";
            text.textColor = COLOR_RGB(92, 175, 248, 1);
            text.userInteractionEnabled = NO;
            text;
        });
    }
    return _introText;
}
- (UIButton *)submintBtn {
    if (!_submintBtn) {
        _submintBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(10, CGRectGetMaxY(self.introText.frame)/DHFlexibleVerticalMutiplier(), 300, 40), NO);
            [btn setTitle:@"提交" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 10 * DHFlexibleVerticalMutiplier();
            [btn addTarget:self action:@selector(respondsToSubmintBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _submintBtn;
}
- (UIBezierPath *)linepath {
    if (!_linepath) {
        _linepath = [UIBezierPath bezierPath];
    }
    return _linepath;
}
- (UIImagePickerController *)imagePickerVC {
    if (!_imagePickerVC) {
        _imagePickerVC = [[UIImagePickerController alloc]init];
        _imagePickerVC.delegate = self;
        _imagePickerVC.allowsEditing = YES;
        _imagePickerVC.sourceType = self.imageSource;
    }
    return _imagePickerVC;
}
@end
