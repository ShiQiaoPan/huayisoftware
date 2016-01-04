//
//  AdviceFeedbackViewController.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/11/10.
//  Copyright (c) 2015年 HuaYiSoftware. All rights reserved.
//

#import "WPAdviceFeedbackViewController.h"
#import "WKAlertView.h"
#import "NetWorkingManager+AdiviceSave.h"

static const NSInteger wordCount = 120;
static  NSString *TEXT = @"闪退、卡屏或界面错位...(请控制在120字以内)";

@interface WPAdviceFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView * adviceTextView;/**< 建议反馈 */
@property (nonatomic, strong) UIButton * sendBtn;/**< 发送按钮 */\
@property (nonatomic, strong) UIWindow * alertWindow;
- (void)initializeDataSource; /**< 初始化数据源 */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation WPAdviceFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.adviceTextView.text = @"";
}
#pragma mark - init
- (void)initializeDataSource {
    
}
- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_RGB(239, 243, 244, 1);
    self.titleLable.text = @"建议反馈";
    UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 65, 40) adjustWidth:YES];
    backLabel.text = @"返回";
    backLabel.font = [UIFont systemFontOfSize:17*DHFlexibleHorizontalMutiplier()];
    backLabel.textColor = [UIColor whiteColor];
    [self.baseNavigationBar addSubview:backLabel];
    [self.rightButton removeFromSuperview];
    [self.view addSubview:self.adviceTextView];
    [self.view addSubview:self.sendBtn];
}
#pragma mark - responds events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)respondsToSendBtn {
    if (self.adviceTextView.text.length == 0) {
        [self initializeAlertControllerWithMessage:@"请填写反馈"];
        return;
    }
    [self.view endEditing:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor grayColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"请稍候";
    hud.detailsLabelText = @"提交反馈中";
    __weak typeof(self)weakself = self;
    [NetWorkingManager saveAdviceWithAdviceDetail:self.adviceTextView.text successHandler:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            [hud hide:YES];
           weakself.alertWindow = [WKAlertView showAlertViewWithTitle:@"感谢您的宝贵建议" detail:@"我们会尽快解决您的问题" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
               weakself.alertWindow.hidden = YES;
               weakself.alertWindow = nil;
           }];
        } else {
           hud.labelText = @"提交失败";
            if (responseObject[@"errMsg"]) {
                hud.detailsLabelText = responseObject[@"errMsg"];
            } else {
                hud.detailsLabelText = @"网络数据错误";
            }
            [hud hide:YES afterDelay:1.0];
        }
    } failureHandler:^(NSError *error) {
        hud.labelText = @"提交失败";
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark - system protocol
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:TEXT]) {
        self.adviceTextView.text = @"";
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange == nil && textView.text.length > wordCount) {
        textView.text = [textView.text substringToIndex:wordCount];
    }
}


#pragma mark - getter
- (UITextView *)adviceTextView {
    if (!_adviceTextView) {
        _adviceTextView = ({
            UITextView * view = [[UITextView alloc]initWithFrame:CGRectMake(10, 74, 300, 140) adjustWidth:NO];
            view.text = TEXT;
            view.layer.borderWidth = 1;
            view.layer.borderColor = COLOR_RGB(211, 212, 213, 1).CGColor;
            view.delegate = self;
            view;
        });
    }
    return _adviceTextView;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = DHFlexibleFrame(CGRectMake(243, 220, 60, 30), YES);
            [btn setTitle:@"发送" forState:UIControlStateNormal];
            btn.backgroundColor = REDBGCOLOR;
            btn.layer.cornerRadius = 8*DHFlexibleVerticalMutiplier();
            [btn addTarget:self action:@selector(respondsToSendBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _sendBtn;
}
@end
