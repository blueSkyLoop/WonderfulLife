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
    CGFloat labelWidth;
    CGFloat scale;
    CGFloat font;
}

- (instancetype)initWithType:(MHHobbyButtonType)type{
    if (self = [super init]) {
        _type = type;
//        scale = MScreenW/375;
        labelTop = 6;
        labelWidth = 60;
        font = 15;
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        [self setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        scale = MScreenW/375;
        labelTop = 8*scale;
        labelWidth = 79*scale;
        font = 16*scale;
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        [self setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        [self setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
        scale = MScreenW/375;
        labelTop = 8*scale;
        labelWidth = 79*scale;
        font = 16*scale;
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
    if (self.type) {
        self.imageView.nim_size = CGSizeMake(58, 58);
        self.imageView.nim_centerX = self.nim_width/2;
        
        [self.titleLabel sizeToFit];
        self.titleLabel.nim_top = self.imageView.nim_bottom + labelTop;
        self.titleLabel.nim_centerX = self.nim_width/2;

    }else{
        self.imageView.nim_width = self.nim_width;
        self.imageView.nim_height = self.imageView.nim_width;
        self.imageView.nim_origin = CGPointZero;
        
        [self.titleLabel sizeToFit];
        self.titleLabel.nim_centerX = self.nim_width/2;
        self.titleLabel.nim_top = self.imageView.nim_bottom + labelTop;
        
        self.deleteButton.nim_right = self.nim_width;
        
    }
}
@end





