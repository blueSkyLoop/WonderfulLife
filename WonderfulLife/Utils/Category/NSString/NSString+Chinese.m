//
//  NSString+Chinese.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSString+Chinese.h"

@implementation NSString (Chinese)

- (BOOL)isChinese{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

@end
