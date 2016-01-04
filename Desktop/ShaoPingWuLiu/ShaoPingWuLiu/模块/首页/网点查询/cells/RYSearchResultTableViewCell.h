//
//  RYSearchResultTableViewCell.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSearchResult.h"

@protocol  SearchCellDelegate<NSObject>
- (void)searchCellSegClickWithSegIndex:(NSInteger)index and:(RYSearchResult *) model;
@end

@interface RYSearchResultTableViewCell : UITableViewCell

@property (nonatomic, assign) id <SearchCellDelegate> delegate;

@property (nonatomic, strong) RYSearchResult *model;

@end
