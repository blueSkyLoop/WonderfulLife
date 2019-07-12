//
//  NSString+HLDeal.m
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "NSString+HLDeal.h"

@implementation NSString (HLDeal)

- (NSString *)hl_dealPhone {
    NSArray *dealArray = @[@" ",@"+86",@"-",@"+",@"(",@")",@"（",@"）",@"#",@"*"];
    NSString *resultString = [self copy];
    for (NSString *rp in dealArray)
        resultString = [resultString stringByReplacingOccurrencesOfString:rp withString:@""];
    return resultString;
}

@end
