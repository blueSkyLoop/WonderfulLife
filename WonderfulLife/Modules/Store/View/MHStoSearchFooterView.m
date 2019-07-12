//
//  MHStoSearchFooterView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/13.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoSearchFooterView.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@interface MHStoSearchFooterView ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation MHStoSearchFooterView

#pragma mark - override

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.label = [UILabel new];
        _label.text = @"没有更多了";
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = MColorContent;
        [_label sizeToFit];
        [self.contentView addSubview:_label];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _label.center = CGPointMake(self.contentView.nim_width/2, self.contentView.nim_height/2);
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







