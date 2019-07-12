//
//  UILabel+LinesString.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LinesString)

/**
 *  获取每行的字符串内容，数组的数量即：总行数
 *
 *  @parma   UILabel
 *
 *  @return  NSArray
 */
- (NSArray *)mh_getLinesArrayOfStringInLabel:(UILabel *)label ;

@end
