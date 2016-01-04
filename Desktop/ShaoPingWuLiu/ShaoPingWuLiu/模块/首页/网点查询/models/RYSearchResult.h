//
//  RYSearchResult.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "RYBasicModel.h"

@interface RYSearchResult : RYBasicModel

ProStr(result_name);
ProNsi(result_distance);
ProStr(result_address);
ProStr(result_tel);
@property (nonatomic, strong) AMapGeoPoint *result_location;

@end
