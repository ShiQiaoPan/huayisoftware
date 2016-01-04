//
//  RYCommentViewController.m
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/17.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYCommentViewController.h"
#import "NetWorkingManager+OrderManager.h"

#define attBeginTag 210
#define effBeginTag 215
#define com_defaultText @"说说对我们的评价吧"

@interface RYCommentViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel    *ordercontentLabel;
@property (weak, nonatomic) IBOutlet UILabel    *attitudeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel    *efficiencyScoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton   *submitButton;

- (void)initializeDataSource;    /**< 初始化数据源   */
- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation RYCommentViewController {
    NSNumber *_attitudeScore;
    NSNumber *_efficiencyScore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - init
- (void)initializeDataSource {
    _attitudeScore   = @5;
    _efficiencyScore = @5;
}

- (void)initializeUserInterface {
    self.view.backgroundColor = BGCOLOR;
    self.titleLable.text      = @"评论";
    [self setUI];
}

#pragma mark - 设置UI
- (void) setUI {
    _commentTextView.layer.cornerRadius = 2;
    _commentTextView.layer.borderWidth  = 1;
    _commentTextView.layer.borderColor  = [[UIColor colorWithWhite:0.78f alpha:1] CGColor];
    _commentTextView.delegate           = self;
    _submitButton.layer.cornerRadius    = 4;
    _submitButton.layer.masksToBounds   = YES;
    _submitButton.backgroundColor       = REDBGCOLOR;
}

#pragma mark - but clicked events
- (IBAction)attitudeStarButtonsClicked:(UIButton *)sender {
    for (int i = attBeginTag; i <= attBeginTag + 4; i++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:i];
        [but setImage:[UIImage imageNamed:@"comment_star_deSel.png"] forState:UIControlStateNormal];
    }
    for (int i = attBeginTag; i <= sender.tag; i++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:i];
        [but setImage:[UIImage imageNamed:@"comment_star_sel.png"] forState:UIControlStateNormal];
    }
    _attitudeScoreLabel.text = [NSString stringWithFormat:@"%ld分", sender.tag - attBeginTag + 1];
    _attitudeScore           = [NSNumber numberWithInteger:(sender.tag - attBeginTag + 1)];
}
- (IBAction)efficiencyStarButtonsClicked:(UIButton *)sender {
    for (int i = effBeginTag; i <= effBeginTag + 4; i++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:i];
        [but setImage:[UIImage imageNamed:@"comment_star_deSel.png"] forState:UIControlStateNormal];
    }
    for (int i = effBeginTag; i <= sender.tag; i++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:i];
        [but setImage:[UIImage imageNamed:@"comment_star_sel.png"] forState:UIControlStateNormal];
    }
    _efficiencyScoreLabel.text = [NSString stringWithFormat:@"%ld分", sender.tag - effBeginTag + 1];
    _efficiencyScore           = [NSNumber numberWithInteger:(sender.tag - effBeginTag + 1)];
}

- (IBAction)submitButtonClicked:(UIButton *)sender {
    [NetWorkingManager postCommentWithId:self.model.commitid AndDetailComment:[self.commentTextView.text isEqualToString:com_defaultText] ? @"评论为空。" : self.commentTextView.text AndAttitude:_attitudeScore AndAging:_efficiencyScore SuccessHandler:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:@0]) {
//            [self initializeAlertControllerWithMessage:@"评论成功"];
        }
    } failureHandler:^(NSError *error) {
//        [self initializeAlertControllerWithMessage:@"提交失败"];
    }];
//    [self initializeAlertControllerWithMessage:@"提交成功" withHandelBlock:^(id action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
}

#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == _commentTextView && [_commentTextView.text isEqualToString:com_defaultText]) {
        _commentTextView.text = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _commentTextView && range.location >= 150) {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == _commentTextView && [textView.text isEqualToString:@""]) {
        textView.text = com_defaultText;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
*/

@end
