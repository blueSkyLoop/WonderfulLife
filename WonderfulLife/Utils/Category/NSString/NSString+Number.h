//
//  NSString+Number.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Number)
- (BOOL)isPureInt;
- (BOOL)isPureNumandCharacters:(NSString *)string;
-(BOOL)isOnlyhasNumberAndpointWithString;
@end
