//
//  UITextView+lineSpace.m
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/1.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import "UITextView+HLLineSpace.h"

@implementation UITextView (HLLineSpace)

+ (CGFloat)hl_heightWithText:(NSString *)text
                 fontSize:(CGFloat)fontSize
                    width:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing {
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    textView.font = [UIFont systemFontOfSize:fontSize];
    [textView hl_setText:text lineSpacing:lineSpacing];
    [textView sizeToFit];
    return CGRectGetHeight(textView.frame);
}

- (void)hl_setText:(NSString*)text lineSpacing:(CGFloat)lineSpace {
    
    lineSpace = [self changeLineSpace:lineSpace];
    
    if (lineSpace < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    self.attributedText = attributedString;
}

- (CGFloat)changeLineSpace:(CGFloat)lineSpace {
    
    CGFloat fontSize = self.font.pointSize;
    if (fontSize<13) {
        return lineSpace-2;
    } else if (fontSize>13) {
        if (fontSize<18) {
            return lineSpace-3;
        } else if(fontSize>18) {
            return lineSpace-4;
        } else {
            return lineSpace-3.5;
        }
    } else {
        return lineSpace-2.5;
    }
}

@end
