//
//  MHHobbyButton.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHobbyButton.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@implementation MHHobbyButton{
    CGFloat labelTop;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
        if (MScreenW == 320) {
            labelTop = 6.8;
        }else if (MScreenW == 375){
            labelTop = 8;
        }else if (MScreenW == 414){
            labelTop = 8.8;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
        if (MScreenW == 320) {
            labelTop = 6.8;
        }else if (MScreenW == 375){
            labelTop = 8;
        }else if (MScreenW == 414){
            labelTop = 8.8;
        }
    }
    return self;
}

- (void)setCustom:(BOOL)custom{
    _custom = custom;
    if (custom) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"Vo_hobby_delete"] forState:UIControlStateNormal];
        [self.deleteButton sizeToFit];
        
        [self addSubview:self.deleteButton];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.nim_width = self.nim_width;
    self.imageView.nim_height = self.imageView.nim_width;
    self.imageView.nim_origin = CGPointZero;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.nim_centerX = self.nim_width/2;
    self.titleLabel.nim_top = self.imageView.nim_bottom + labelTop;
    
    self.deleteButton.nim_right = self.nim_width;
}
@end





