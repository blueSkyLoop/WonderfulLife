//
//  UILabel+HLLineSpacing.m
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/1.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import "UILabel+HLLineSpacing.h"

@implementation UILabel (HLLineSpacing)

+ (CGFloat)hl_heightWithlineSpacing:(CGFloat)lineSpacing
                               text:(NSString*)text
                           fontSize:(CGFloat)fontSize
                              width:(CGFloat)width {
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label hl_setLineSpacing:lineSpacing text:text];
    [label sizeToFit];
    return CGRectGetHeight(label.frame);
}

- (void)hl_setLineSpacing:(CGFloat)lineSpacing
                     text:(NSString*)text {
    
    lineSpacing = [self changeLineSpacing:lineSpacing];
    
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

- (CGFloat)changeLineSpacing:(CGFloat)lineSpacing {
    
    CGFloat fontSize = self.font.pointSize;
    if (fontSize<13) {
        return lineSpacing-2;
    } else if (fontSize>13) {
        if (fontSize<18) {
            return lineSpacing-3;
        } else if(fontSize>18) {
            return lineSpacing-4;
        } else {
            return lineSpacing-3.5;
        }
    } else {
        return lineSpacing-2.5;
    }
}

@end
