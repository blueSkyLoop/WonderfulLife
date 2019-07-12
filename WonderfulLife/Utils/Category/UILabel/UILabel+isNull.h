//
//  UILabel+isNull.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (isNull)

/** 直接赋值 text*/
- (void)mh_isNullText:(NSString *)text ;


/** 
 *  判断 text 数据源，
 *  赋值拼接好的 allText
 *  当数据源为空 ，替换显示的字符串 replace
 */
- (void)mh_isNullWithDataSourceText:(NSString *)text allText:(NSString *)allText isNullReplaceString:(NSString *)replace;

@end
