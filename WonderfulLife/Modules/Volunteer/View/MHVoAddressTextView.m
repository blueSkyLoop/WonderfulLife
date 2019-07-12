//
//  MHVoAddressTextView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAddressTextView.h"
#import "MHMacros.h"

@interface MHVoAddressTextView ()

@end

@implementation MHVoAddressTextView{
    CGFloat kMaxLength;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        kMaxLength = 50;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)setType:(MHVoAddressTextViewType)type{
    _type = type;
    if (type == MHVoAddressTextViewTypeIntroduce) {
        kMaxLength = 300;
        [self addSubview:self.placeHolderLabel];
    }
}

-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    
    self.placeHolderLabel.hidden = toBeString.length;
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (UILabel *)placeHolderLabel{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"请输入自我介绍";
        _placeHolderLabel.textColor = MRGBColor(192, 204, 218);
        _placeHolderLabel.frame = CGRectMake(5, 8, 0, 0);
        [_placeHolderLabel sizeToFit];
    }
    return _placeHolderLabel;
}
@end
