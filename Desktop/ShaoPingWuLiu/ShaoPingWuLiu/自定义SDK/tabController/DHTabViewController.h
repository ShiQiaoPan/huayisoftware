//
//  DHTabViewController.h
//  DeepBreathingFramework
//
//  Created by DreamHack on 15-8-11.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHTabViewController : UIViewController

@property (nonatomic, copy, readonly) NSArray * viewControllers;
@property (nonatomic, copy, readonly) NSArray * barItemImages;
@property (nonatomic, copy, readonly) NSArray *barItemSelectedImages;
@property (nonatomic, strong, readonly) UIView * buttonContainerView;
- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers barItemImages:(NSArray *)barItemImages;
- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers barItemImages:(NSArray *)barItemImages barItemSelectedImages:(NSArray *)barItemSelectedImages;
- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers;
- (void)resetController;

@end
