//
//  MHPlaceholderTextView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHPlaceholderTextView.h"
#import "Masonry.h"

@interface MHPlaceholderTextView()

@property (nonatomic,strong)UILabel *placeholderLabel;

@end

@implementation MHPlaceholderTextView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init{
    self = [super init];
    if(self){
        [self addPlaceholderLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addPlaceholderLabel];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self addPlaceholderLabel];
    }
    return self;
}

- (void)setPlaceholderSize:(CGFloat)placeholderSize{
    if(_placeholderSize != placeholderSize){
        _placeholderSize = placeholderSize;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.placeholderLabel.font = [UIFont systemFontOfSize:width / 375.0 * _placeholderSize];
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    if(_placeholderColor != placeholderColor){
        _placeholderColor = placeholderColor;
        self.placeholderLabel.textColor = _placeholderColor;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    if(_placeholder != placeholder){
        _placeholder = placeholder;
        self.placeholderLabel.text = _placeholder;
    }
    
}

- (void)makePlaceholderHidden:(BOOL)isHidden{
    self.placeholderLabel.hidden = isHidden;
}

- (void)addPlaceholderLabel{
    [self addSubview:self.placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(7);
        make.right.lessThanOrEqualTo(self.mas_right);
    }];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)notification{
    __block NSString *atext = self.text;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!atext || [atext length] == 0){
            self.placeholderLabel.hidden = NO;
        }else{
            self.placeholderLabel.hidden = YES;
        }
        
    });
    
}

- (UILabel *)placeholderLabel{
    if(!_placeholderLabel){
        _placeholderLabel = [UILabel new];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _placeholderLabel.font = [UIFont systemFontOfSize:width / 375.0 * 17];
        _placeholderLabel.textColor = [UIColor colorWithRed:192 / 255.0 green:204 / 255.0 blue:218 / 255.0 alpha:1.0];
    }
    return _placeholderLabel;
}

@end
