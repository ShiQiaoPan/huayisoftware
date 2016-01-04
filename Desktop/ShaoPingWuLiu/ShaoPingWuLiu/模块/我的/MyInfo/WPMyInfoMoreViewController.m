//
//  WPMyInfoMoreViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPMyInfoMoreViewController.h"
#import "WPPhoneViewController.h"
#import "NetWorkingManager+ChangeName.h"
#import "NetWorkingManager+JoinVIP.h"
#import "ImageHandle.h"
#import "MyInfoViewModel.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";

@interface WPMyInfoMoreViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    NSArray * _infoDataSource;
}
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UITableView * infoTableView;
@property (nonatomic, strong) UIImagePickerController * imagePickerVC;
@property (nonatomic, assign) UIImagePickerControllerSourceType imageSource;

- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPMyInfoMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - init
- (void)initializeDataSource {
    _infoDataSource = @[@"修改用户名",
                        @"关联手机号码",
                        @"申请签约"];
}
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    self.titleLable.text = @"我的资料";
    [self.rightButton removeFromSuperview];
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.headImageView];
    [self configStarWithStarCount:self.starCount];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.infoTableView];
}
#pragma mark - responds events
- (void)UesrImageClicked {
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
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"默认头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        __weak typeof(self)weakself = self;
        weakself.headImageView.image = IMAGE_CONTENT(@"head_gray.png");
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:deleteAction];
    [alertVC addAction:imageAction];
    [alertVC addAction:defaultAction];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertVC addAction:archiveAction];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    UIImage * showImage = [ImageHandle imageWithImageSimple:image scaledToSize:DHFlexibleSize(CGSizeMake(160, 160), YES)];
    NSData * data = [NSData data];
    if (UIImagePNGRepresentation(showImage)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(showImage);
    }
    else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(showImage, 1.0);
    }
    if (data.bytes == 0) {
        [self initializeAlertControllerWithMessageAndDismiss:@"目前仅支持jpg/png格式的图片"];
        return;
    }
    [ImageHandle saveImage:showImage WithName:@"headImage.png"];
    NSData * imageData = [ImageHandle readImageWithImageName:@"headImage.png"];
    __weak typeof(self)weakself = self;
    [MyInfoViewModel submitHeadImageWithImageFile:[ImageHandle imageFileWithImageName:@"headImage.png"] andImageData:imageData successBlock:^(NSString *success) {
        weakself.headImageView.image = showImage;
    } failBlock:^(NSString *error) {
        [weakself initializeAlertControllerWithMessageAndDismiss:@"上传图片失败"];
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 10) {
        return NO;
    }
    return YES;
}
#pragma mark - private menthods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)configStarWithStarCount:(NSInteger)starCount {
    for (int i = 0; i < 5; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.bounds = DHFlexibleFrame(CGRectMake(0, 0, 20, 20), YES);
        btn.center = DHFlexibleCenter(CGPointMake(i * 20 +220, 98));
        [btn setImage:IMAGE_CONTENT(@"star_1.png") forState:UIControlStateNormal];
        [btn setImage:IMAGE_CONTENT(@"star.png") forState:UIControlStateSelected];
        if (i < starCount) {
            btn.selected = YES;
        }
        [self.view addSubview:btn];
    }
}
- (void)submitApply {
    if (self.isSigned) {
        [self initializeAlertControllerWithMessageAndDismiss:@"您已是签约客户"];
        return;
    }
    [self initializeAlertControllerWithMessage:@"是否提交您的个人资料申请签约"withHandelBlock:^(id action) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor grayColor];
        hud.labelText = @"请稍候";
        hud.detailsLabelText = @"正在提交申请";
        [NetWorkingManager joinVIPWithSuccessHandler:^(id responseObject) {
           if ([responseObject[@"code"] integerValue]== 0) {
               if (responseObject[@"errMsg"]) {
                   hud.labelText = responseObject[@"errMsg"];
                   hud.detailsLabelText = @"请耐心等待审核";
               } else {
               }
           } else {
               hud.labelText = @"提交失败";
               if (responseObject[@"errMsg"]) {
                   hud.detailsLabelText = responseObject[@"errMsg"];
               } else {
                   hud.detailsLabelText = @"请稍候尝试";
               }
           }
            [hud hide:YES afterDelay:1.0];
       } failureHandler:^(NSError *error) {
           hud.labelText = @"申请失败";
           hud.detailsLabelText = error.localizedDescription;
           [hud hide:YES afterDelay:2.0];
       }];
    }];
}
- (void)modifyName {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请输入您的昵称" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self)weakself = self;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = weakself.nameLabel.text;
        textField.delegate = weakself;
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString * nickName = [alertVC textFields].firstObject.text;
        if (nickName.length == 0) {
            [weakself initializeAlertControllerWithMessage:@"昵称不能为空"];
        }
        else if ([nickName isEqualToString:self.userName]) {
            [weakself initializeAlertControllerWithMessage:@"昵称与原来相同"];
        }
        else {
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.color = [UIColor grayColor];
            hud.labelText = @"请稍候";
            hud.detailsLabelText = @"昵称修改中";
            [NetWorkingManager changeNameWithNickname:nickName successHandler:^(id responseObject) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    hud.labelText = @"昵称修改成功";
                } else {
                    hud.labelText = @"网络数据错误";
                }
                hud.detailsLabelText = nil;
                weakself.nameLabel.text = nickName;
                [hud hide:YES afterDelay:1.0];
            } failureHandler:^(NSError *error) {
                hud.labelText = error.localizedDescription;
                hud.detailsLabelText = nil;
                [hud hide:YES afterDelay:2.0];
            }];
        }
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - system protocol
#pragma mark - 协议UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _infoDataSource[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
//用户点击了某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self modifyName];
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[[WPPhoneViewController alloc]init] animated:YES];
    }
    if (indexPath.row == 2) {
        [self submitApply];
    }
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = ({
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 100) adjustWidth:NO];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _backView;
}
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = ({
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(20, 84, 70, 70) adjustWidth:YES];
            NSData * headData = [ImageHandle readImageWithImageName:@"headImage.png"];
            view.image = headData.bytes > 0 ?[UIImage imageWithData:headData]: IMAGE_CONTENT(@"head_gray.png");
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(UesrImageClicked)];
            [view addGestureRecognizer:ges];
            view.userInteractionEnabled = YES;
            view.layer.cornerRadius = 35 * DHFlexibleVerticalMutiplier();
            view.layer.masksToBounds = YES;
            view;
        });
    }
    return _headImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(110, 84, 100, 30) adjustWidth:YES];
            label.text = _userName;
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _nameLabel;
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = ({
            UITextField * text = [[UITextField alloc]initWithFrame:CGRectMake(110, 114, 200, 30) adjustWidth:YES];
            text.userInteractionEnabled = NO;
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 40) adjustWidth:YES];
            imageView.image = IMAGE_CONTENT(@"tablet.png");
            text.leftViewMode = UITextFieldViewModeAlways;
            text.leftView = imageView;
            text.textColor = COLOR_RGB(211, 212, 213, 1);
            text.text = [UserModel defaultUser].phoneNumber;
            text;
        });
    }
    return _phoneTextField;
}
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = ({
            UITableView * tableview = [[UITableView alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 174, ORIGIN_WIDTH, ORIGIN_HEIGHT), NO) style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.tableFooterView = [UIView new];
            tableview.pagingEnabled = NO;
            tableview.scrollEnabled = NO;
            tableview.separatorColor = COLOR_RGB(210, 211, 212, 1);
            tableview.backgroundColor = [UIColor clearColor];
            tableview;
        });
    }
    return _infoTableView;
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
