//
//  DHTabViewController.m
//  DeepBreathingFramework
//
//  Created by DreamHack on 15-8-11.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHTabViewController.h"
#import "WPSendSelectionView.h"
#import "RYLatticeSearchViewController.h"
#import "ControllerManager.h"
#import "RYPickingGoodsViewController.h"
#import "WPLoginViewController.h"

typedef NS_ENUM(NSUInteger, ViewTag) {
    ButtonTag = 100
};
@interface DHTabViewController ()

@property (nonatomic, copy)   NSMutableArray * viewControllers;
@property (nonatomic, copy)   NSArray * barItemImages;
@property (nonatomic, copy)   NSArray *barItemSelectedImages;
@property (nonatomic, assign) NSUInteger selectedControllerIndex;
@property (nonatomic, strong) UIView * buttonContainerView;
@property (nonatomic, strong) UIView * childControllerContainerView;
- (void)initializeAppearance;

@end

@implementation DHTabViewController

#pragma mark - initializer
- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [self initWithViewControllers:viewControllers barItemImages:@[]barItemSelectedImages:@[]];
    return self;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers barItemImages:(NSArray *)barItemImages
{
    self = [self initWithViewControllers:viewControllers barItemImages:barItemImages barItemSelectedImages:@[]];
    return self;
}
- (instancetype)initWithViewControllers:(NSArray *)viewControllers barItemImages:(NSArray *)barItemImages barItemSelectedImages:(NSArray *)barItemSelectedImages {
    self = [super init];
    if (self) {
        self.selectedControllerIndex = 0;
        self.viewControllers = viewControllers;
        self.barItemImages = barItemImages;
        self.barItemSelectedImages = barItemSelectedImages;
    }
    return self;
}
- (instancetype)init
{
    self = [self initWithViewControllers:@[]];
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppearance];
}
#pragma mark - action/callback
- (void)resetController {
    // 移除当前显示的controller
    UIViewController * currentController = self.viewControllers[self.selectedControllerIndex];
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
    [currentController willMoveToParentViewController:nil];
    self.viewControllers = nil;
    NSArray * controllerClassNames =@[@"WPHomePageViewController",
                                      @"WPConsignmentViewController",
                                      @"WPMyInfoViewController"];
    NSMutableArray * VCS = [NSMutableArray arrayWithCapacity:0];
    [controllerClassNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = NSClassFromString(obj);
        //            *stop = YES;/**< 停止遍历 */
        UIViewController *controller = [[class alloc]init];
        [VCS addObject:controller];
    }];
    self.viewControllers = [NSArray arrayWithArray:VCS];
    for (int i = 0; i < self.viewControllers.count; i++) {
         UIButton * currentButton = (UIButton *)[self.buttonContainerView viewWithTag:ButtonTag + i];
        if (i == 0) {
            currentButton.selected = YES;
        } else {
            currentButton.selected = NO;
        }
        self.selectedControllerIndex = 0;
    }
    UIViewController * selectedController = self.viewControllers[0];
    [self addChildViewController:selectedController];
}
- (void)action_onButton:(UIButton *)sender
{
    NSUInteger index = sender.tag - ButtonTag;
    if (index == self.selectedControllerIndex) {
        return;
    }
    if (index == 1) {
        [WPSendSelectionView showSendSelecionViewWithSize:CGSizeMake(SCREEN_SIZE.width * 0.75, 180) Complete:^(NSInteger result) {
            if (result) {
                RYLatticeSearchViewController * VC = [[RYLatticeSearchViewController alloc]init];
                [[[ControllerManager sharedManager]rootViewController]pushViewController:VC animated:YES];
            } else {
                [[[ControllerManager sharedManager]rootViewController]pushViewController:[RYPickingGoodsViewController new] animated:YES];
            }
        }];
        return;
    }
    if (index == 2) {
        if (![UserModel defaultUser].needAutoLogin) {
            [[[ControllerManager sharedManager]rootViewController]pushViewController:[WPLoginViewController new] animated:YES];
            return;
        }
    }
    
    if (index != 0 && self.view.subviews.count > 2) {
        [self.view.subviews.lastObject removeFromSuperview];
    }
    NSUInteger currentButtonTag = self.selectedControllerIndex + ButtonTag;
    UIButton * currentButton = (UIButton *)[self.buttonContainerView viewWithTag:currentButtonTag];
    currentButton.selected = NO;
    sender.selected = YES;
    // 移除当前显示的controller
    UIViewController * currentController = self.viewControllers[self.selectedControllerIndex];
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
    [currentController willMoveToParentViewController:nil];
    // 加载选择的controller
    UIViewController * selectedController = self.viewControllers[index];
    [self addChildViewController:selectedController];
    
    self.selectedControllerIndex = index;
}

#pragma mark - private methods

- (void)initializeAppearance
{
    if (self.viewControllers.count == 0) {
        return;
    }
    [self.view addSubview:self.childControllerContainerView];
    [self.view addSubview:self.buttonContainerView];
    
    // 默认加载第一个controller的内容
    UIViewController * firstViewController = self.viewControllers.firstObject;
    [self addChildViewController:firstViewController];
    
    // 初始化切换controller的按钮
    
    /**< 遍历数组 */
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(action_onButton:) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = DHFlexibleFrame(CGRectMake(0, 0, 40, 40), YES);
        button.center = DHFlexibleCenter(CGPointMake(idx * 110 + 50,  35));
        if (self.barItemImages.count > 0) {
            [button setImage:IMAGE_CONTENT(self.barItemImages[idx])  forState:UIControlStateNormal];
        }
        if (self.barItemSelectedImages.count > 0) {
            [button setImage:IMAGE_CONTENT(self.barItemSelectedImages[idx]) forState:UIControlStateSelected];
        }        else {
            [button setTitle:[NSString stringWithFormat:@"%lu",idx + 1] forState:UIControlStateNormal];
        }
        button.tag = ButtonTag + idx;
        if (idx == 0) {
            button.selected = YES;
        }
        [self.buttonContainerView addSubview:button];
    }];
    
}

#pragma mark - override
- (void)addChildViewController:(UIViewController *)childController
{
    [super addChildViewController:childController];
    [self.childControllerContainerView addSubview:childController.view];
    childController.view.frame = CGRectOffset(self.view.frame, 0, 0);
    [childController didMoveToParentViewController:self];
}
#pragma mark - getter
- (UIView *)buttonContainerView
{
    if (!_buttonContainerView) {
        _buttonContainerView = ({
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,ORIGIN_HEIGHT-60, ORIGIN_WIDTH, 60) adjustWidth:NO];
            view;
        });
    }
    return _buttonContainerView;
}
- (UIView *)childControllerContainerView
{
    if (!_childControllerContainerView) {
        _childControllerContainerView = ({
            UIView * view = [[UIView alloc] initWithFrame:self.view.bounds];
            view;
        });
    }
    return _childControllerContainerView;
    
}



@end
