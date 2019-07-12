//
//  YYLabel+Category.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "YYLabel+Category.h"

@implementation YYLabel (Category)
- (NSArray *)mh_getLinesArrayOfStringInLabel{
    
    NSString *text = [self text];
    UIFont *font = [self font];
    CGRect rect = [self frame];
    
    if (text) {
        CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
        CFRelease(myFont);
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
        NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
        NSMutableArray *linesArray = [[NSMutableArray alloc]init];
        for (id line in lines) {
            CTLineRef lineRef = (__bridge  CTLineRef )line;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            NSString *lineString = [text substringWithRange:range];
            CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
            CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
            [linesArray addObject:lineString];
        }
        
        CGPathRelease(path);
        CFRelease( frame );
        CFRelease(frameSetter);
        return (NSArray *)linesArray;
        
    }
    return nil;
}

- (void)mh_changeLineWithSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

- (void)mh_changeAttributedStringLineWithSpace:(float)space {
    
//    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.attributedText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}


- (void)mh_changeWordWithSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

- (void)mh_changeWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

- (void)mh_setAttributedWithAttributeName:(NSString *)attributeName font:(UIFont *)font{
    //富文本对象
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSRange attRange = [self.text rangeOfString:attributeName];
    
    //富文本样式  NSFontAttributeName
    [aAttributedString addAttribute:attributeName             //文字字体
                              value:font
                              range:attRange];
    self.attributedText = aAttributedString;
}

@end
