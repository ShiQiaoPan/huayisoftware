//
//  RYBasicModel.h
//  ShaoPingWuLiu
//
//  Created by renyong on 15/11/30.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ProNsi(nsi) @property (nonatomic, assign) NSInteger     (nsi)
#define ProBol(bol) @property (nonatomic, assign) BOOL          (bol)
#define ProNum(num) @property (nonatomic, strong) NSNumber     *(num)
#define ProStr(str) @property (nonatomic, copy)   NSString     *(str)
#define ProArr(arr) @property (nonatomic, strong) NSArray      *(arr)
#define ProObj(obj) @property (nonatomic, strong) NSObject     *(obj)
#define ProDic(dic) @property (nonatomic, strong) NSDictionary *(dic)


@interface RYBasicModel : NSObject


@end
