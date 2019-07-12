//
//  YYLabel+Category.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <YYText/YYText.h>

@interface YYLabel (Category)
/**
 *  获取每行的字符串内容，数组的数量即：总行数
 *
 *  @parma   UILabel
 *
 *  @return  NSArray
 */
- (NSArray *)mh_getLinesArrayOfStringInLabel ;



/**
 *  改变行间距
 */
- (void)mh_changeLineWithSpace:(float)space;

/** 
 *  改变行间距(富文本)
 */
- (void)mh_changeAttributedStringLineWithSpace:(float)space ;

/**
 *  改变字间距
 */
- (void)mh_changeWordWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)mh_changeWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace ;

- (void)mh_setAttributedWithAttributeName:(NSString *)attributeName font:(UIFont *)font;


@end
