//
//  NSMutableAttributedString+MHColor.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;
@interface NSMutableAttributedString (MHColor)

/**
 *  富文本 文字前景颜色
 *
 *  @param colors 数组<UIColor *>
 *  @param ranges 数组<包装NSRange的NSValue>
 */
- (void)mh_attributedStringWithColorArray:(NSArray<UIColor *> *)colors ranges:(NSArray <NSValue*>*)ranges;
@end
