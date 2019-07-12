//
//  UITextView+lineSpace.h
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/1.
//  Copyright © 2016年 com.cn. All rights reserved.
//
//  ****** Tip ******
//  photoshop需要进行字间距转换
//  如果UI是使用sketch则无需使用下列方法进行额外转换

#import <UIKit/UIKit.h>

@interface UITextView (HLLineSpace)




/// 设置字间距
- (void)hl_setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/// 计算文本高度
+ (CGFloat)hl_heightWithText:(NSString *)text
                 fontSize:(CGFloat)fontSize
                    width:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing;
@end
