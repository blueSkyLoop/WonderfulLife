//
//  MHCultivateContentCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCultivateContentCell.h"
#import "MHVoCultivateContentModel.h"
#import <UIImageView+WebCache.h>
#import "MHMacros.h"
#import "UIView+NIM.h"
@interface MHCultivateContentCell ()
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel *lable;
@end

@implementation MHCultivateContentCell{
    CGFloat scale;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        scale = MScreenW/375;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 96*scale)];
        [self.contentView addSubview:imageView];
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        self.imageView = imageView;
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [button sizeToFit];
//        button.center = imageView.center;
//        [self.contentView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.nim_bottom+8*scale, frame.size.width, 50*scale)];
        label.numberOfLines = 2;
        label.font = MFont(15*scale);
        label.textColor = MColorTitle;
        [self.contentView addSubview:label];
        self.lable = label;
    }
    return self;
}

- (void)setModel:(MHVoCultivateContentModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
    self.lable.text = model.subject;
    [self.lable sizeToFit];
}


@end




