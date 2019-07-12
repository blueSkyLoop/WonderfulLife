//
//  UILabel+Attributed.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Attributed)

- (void)mh_setAttributedWithRange:(NSRange)range attributeName:(NSString *)attributeName font:(UIFont *)font;
@end
