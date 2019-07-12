//
//  NSString+CountComma.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CountComma)

/** 数字每隔3位添加一个逗号, 包含小数（小数有多少位，就显示多少位）*/
+(NSString *)mh_countNumAndChangeformat:(NSString *)num ;
@end
