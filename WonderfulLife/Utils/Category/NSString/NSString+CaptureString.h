//
//  NSString+CaptureString.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CaptureString)

/**
 *  对比 A字符串是否包含 B字符串
 *
 *  @parma   allStr：全部内容    keyword：关键字
 *
 *  @return  YES ,NO
 */

+ (BOOL)mh_stringCaptureWithAllString:(NSString *)allStr keyword:(NSString *)keyword;
@end
