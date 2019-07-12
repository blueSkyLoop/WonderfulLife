//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)
/**
 *  改变行间距
 */
- (void)mh_changeLineWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)mh_changeWordWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)mh_changeWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace ;
@end
