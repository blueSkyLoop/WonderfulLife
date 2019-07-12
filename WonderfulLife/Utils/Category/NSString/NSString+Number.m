//
//  NSString+Number.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSString+Number.h"

@implementation NSString (Number)

- (BOOL)isPureInt{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    BOOL number = [scan scanInt:&val] && [scan isAtEnd];
    return number;
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

-(BOOL)isOnlyhasNumberAndpointWithString{
    
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString *filter=[[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [self isEqualToString:filter];
    
}

@end
