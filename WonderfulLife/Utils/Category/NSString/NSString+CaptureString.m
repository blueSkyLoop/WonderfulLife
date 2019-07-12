//
//  NSString+CaptureString.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSString+CaptureString.h"

@implementation NSString (CaptureString)

+ (BOOL)mh_stringCaptureWithAllString:(NSString *)allStr keyword:(NSString *)keyword{
    
    NSRange tmpRange = [allStr rangeOfString:keyword];

    if (tmpRange.location == NSNotFound)
    {
        return NO;
    }else
    {
        return YES;
    }
}
@end
