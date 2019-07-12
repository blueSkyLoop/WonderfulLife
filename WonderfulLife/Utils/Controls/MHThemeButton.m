//
//  MHThemeButton.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHThemeButton.h"
#import "MHMacros.h"
#import "UIImage+Color.h"

@interface MHThemeButton ()

@end

@implementation MHThemeButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        [self setupLayerWithEnable:self.enabled];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupLayerWithEnable:self.enabled];
    }
    return self;
}

- (void)setupLayerWithEnable:(BOOL)enable{
    if (enable) {
        self.subLayer.shadowColor = MRGBAColor(255,73,73,0.3).CGColor;
    }else{
        self.subLayer.shadowColor = MRGBAColor(239,242,247,1).CGColor;
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self.superview.layer insertSublayer:self.subLayer below:self.layer];
}

- (void)setNoShadow:(BOOL)noShadow{
    _noShadow = noShadow;
    if (noShadow) {
        [self.subLayer removeFromSuperlayer];
    }
}

- (void)setup {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:19];
    
    [self setBackgroundImage:[UIImage mh_imageGradientSetMainColorWithBounds:self.bounds] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage mh_imageGradientSetMainHighlightColorWithBounds:self.bounds] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage mh_imageWithColor:MRGBColor(229, 233, 242)] forState:UIControlStateDisabled];
    self.layer.cornerRadius = MCornerRadius;
    self.layer.masksToBounds = YES;
    [self setValue:@"0" forKey:@"buttonType"];
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self setupLayerWithEnable:enabled];
}

- (CALayer *)subLayer{
    if (_subLayer == nil) {
        _subLayer = [CALayer layer];
        _subLayer.name = @"buttonShadow";
        _subLayer.shadowOffset = CGSizeMake(0, 2);
        _subLayer.shadowRadius = 8;
        _subLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _subLayer.shadowOpacity = 1;
        
    }
    return _subLayer;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _subLayer.frame = self.frame;
}

- (void)setCenter:(CGPoint)center{
    [super setCenter:center];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _subLayer.position = center;
    [CATransaction commit];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _subLayer.frame = self.frame;
}

@end
