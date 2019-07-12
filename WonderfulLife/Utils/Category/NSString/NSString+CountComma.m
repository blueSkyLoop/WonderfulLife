//
//  NSString+CountComma.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSString+CountComma.h"

@implementation NSString (CountComma)
+(NSString *)mh_countNumAndChangeformat:(NSString *)num
{

    NSString *point = @".";
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    
    
    BOOL isContains = [num containsString:point];

    if (isContains) {
        NSRange range = [num rangeOfString:point];
        NSString *lastStr = [num substringFromIndex:range.location + 1];
        
        NSString *zero = @"0";
        NSString * Formatter = @"###,##0.";
        NSNumber *lengthNum = [NSNumber numberWithInteger:lastStr.length];
        
        int length = [lengthNum intValue] ;
        
        for (int i = 0 ; i < length; i ++) {
            Formatter = [NSString stringWithFormat:@"%@%@",Formatter,zero] ;
        }
        [numberFormatter setPositiveFormat:Formatter];
    }else {
        [numberFormatter setPositiveFormat:@"###,##0"];
    }
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:num.doubleValue]];
    
    
    return formattedNumberString;
}
@end
