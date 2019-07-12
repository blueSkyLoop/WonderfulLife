//
//  MHOwnerCheckView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHOwnerCheckView.h"
#import "MHMacros.h"

@implementation MHOwnerCheckView{
    CGFloat cornerRadius;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        if (MScreenW == 320) {
            cornerRadius = 5.1;
        }else if (MScreenW == 375){
            cornerRadius = 6;
        }else{
            cornerRadius = 6.6;
        }
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MRGBColor(211,220,230).CGColor;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (BOOL)becomeFirstResponder{
    self.layer.borderColor = MRGBColor(71,86,105).CGColor;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    self.layer.borderColor = MRGBColor(211,220,230).CGColor;
    return [super resignFirstResponder];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position{
    
    CGRect originalRect = [super caretRectForPosition:position];
    CGFloat width = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    
    if (self.text.length && [self deptNumInputShouldNumber:self.text]) {
        originalRect.origin.x=20+width;
    }else{
        originalRect.origin.x=12+width;
    }
    return originalRect;
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

#define kMaxLength 1
-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position && toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
    }else{
        if (toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}


@end
