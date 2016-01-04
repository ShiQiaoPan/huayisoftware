//
//  ConfirmBankCardNumber.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/9.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "ConfirmBankCardNumber.h"

@implementation ConfirmBankCardNumber
+ (NSString *)isBankCardNum:(NSString *)bankCardNum {
    if (bankCardNum.length == 0 || bankCardNum.length < 16 || bankCardNum.length > 19 ) {
        return @"银行卡位数不正确";
    }
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[bankCardNum length];
    int lastNum = [[bankCardNum substringFromIndex:cardNoLength-1] intValue];
    
    bankCardNum = [bankCardNum substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i >= 1;i--) {
        NSString *tmpString = [bankCardNum substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0) {
        NSString * bankBin = [bankCardNum substringToIndex:6];
        NSString * ehgitBin = [bankCardNum substringToIndex:8];
        NSString * bankBinPath =  [[NSBundle mainBundle]pathForAuxiliaryExecutable:@"WPBankBins.plist"];
        NSString * bankNamePath = [[NSBundle mainBundle]pathForAuxiliaryExecutable:@"WPBankNames.plist"];
        NSArray * bankBins = [NSArray arrayWithContentsOfFile:bankBinPath];
        NSArray * bankNames = [NSArray arrayWithContentsOfFile:bankNamePath];
        for (int i = 0; i < bankBins.count; i++) {
            if ([bankBin isEqualToString:bankBins[i]]||[ehgitBin isEqualToString:bankBins[i]]) {
                return bankNames[i];
                break;
            }
        }
        return @"未收录的卡";
    } else {
        return @"不是正确格式的银行卡";
    }
}

@end
