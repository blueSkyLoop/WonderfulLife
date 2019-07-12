//
//  MHMineMerchantHeaderView.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerchantHeaderView.h"

#import "MHMineMerchantInfoModel.h"

#import "MHMacros.h"
#import "UIImage+Color.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+Category.h"
#import "UILabel+isNull.h"
#import "NSObject+isNull.h"

#import "PYPhotoBrowser.h"

@interface MHMineMerchantHeaderView ()

/** 背景图 */
@property (strong,nonatomic) UIImageView *BGImage;

/** 头像 */
@property (strong,nonatomic) PYPhotosView *icon;

/**
 *  主标题
 */
@property (strong,nonatomic) UILabel *titleLB;

/** 内容*/
@property (strong,nonatomic) UILabel *contentLB;


/** 右箭头*/
@property (nonatomic, strong) UIImageView  *arrowIcon;

/** 标签*/
@property (nonatomic, strong) UILabel  *tagLab;

@property (nonatomic, strong) UIButton  *infoBtn;

@property (nonatomic, copy)   infoBlock block;

@end

@implementation MHMineMerchantHeaderView
static float headerView_H = 184 ;

#pragma mark - life cycle
- (instancetype)init {
    if ([super init]) {
        [self setUI];
    }return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setUI];
    }return self;
}

+ (MHMineMerchantHeaderView *)merCreatHeaderViewWithFrame:(CGRect)frame  block:(infoBlock)block{
    MHMineMerchantHeaderView * view = [[MHMineMerchantHeaderView alloc] initWithFrame:frame];
    view.block = block ;
    return view ;
}

- (void)reloadDataWitModel:(MHMineMerchantInfoModel *)model {
//    [self.icon sd_setImageWithURL:model.merchant_cover placeholderImage:MAvatar];
    
    [self.icon setThumbnailUrls:@[model.merchant_cover]];
    [self.icon setOriginalUrls:@[model.merchant_cover_origin]];
    
    [self.titleLB mh_isNullText:model.name];
    [self.contentLB mh_isNullText:model.merchant_address];
    self.tagLab.hidden = [NSObject isNull:model.merchant_category_name];
    [self.tagLab mh_isNullText:model.merchant_category_name];
    
    [self layoutIfNeeded];
    
    CGRect  imageFrame = self.icon.frame ;
    self.icon.layer.cornerRadius = imageFrame.size.width*0.5  ;
    self.icon.layer.masksToBounds = YES ;
}

#pragma mark - SetUI
- (void)setModel:(MHMineMerchantInfoModel *)model {
    _model = model ;
    
}


- (void)setUI {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self addSubview:self.BGImage];
    [self addSubview:self.icon];
    [self addSubview:self.titleLB];
    [self addSubview:self.contentLB];
    [self addSubview:self.arrowIcon];
    [self addSubview:self.tagLab];
    [self addSubview:self.infoBtn];
    
    
    [_BGImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(98);
        make.right.mas_equalTo(-24);
        make.height.offset(14);
        make.width.offset(6);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BGImage).offset(24);
        make.bottom.equalTo(self.BGImage).offset(-30);
        make.width.height.offset(80);
    }];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(12);
        make.right.equalTo(self.arrowIcon.mas_left).offset(- 30);
        make.height.offset(25);
        make.top.equalTo(self.icon.mas_top).offset(4);
    }];
    
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_left);
        make.bottom.lessThanOrEqualTo(self).offset(- 10);
        make.height.offset(20);
        make.width.offset(42);
    }];
    
    
    
    [_contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_left);
        make.top.equalTo(self.titleLB.mas_bottom).offset(3);
        make.right.equalTo(self.arrowIcon.mas_left).offset(-5);
        make.bottom.equalTo(self.tagLab.mas_top).offset(-5);
    }];
    
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_top);
        make.left.equalTo(self.titleLB.mas_left);
        make.height.equalTo(self.icon.mas_height);
        make.right.mas_equalTo(0);
    }];
    
    
    

}

- (void)infoAction{
    if (self.block) {
        self.block(self);
    }
}


#pragma mark - lazyload
- (UIImageView *)BGImage{
    if(!_BGImage){
        _BGImage = [UIImageView new];
        _BGImage.image = [UIImage mh_gradientImageWithBounds:CGRectMake(0, 0, MScreenW, headerView_H) direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
    }
    return _BGImage;
}


- (PYPhotosView *)icon {
    if (!_icon) {
        _icon = [PYPhotosView new];
    }return _icon ;
}
- (UIImageView *)arrowIcon {
    if (!_arrowIcon) {
        _arrowIcon = [UIImageView new];
        _arrowIcon.image = [UIImage imageNamed:@"S-rightArrow"];
    }return _arrowIcon ;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel new];
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.font = MFont(18.0);
    }return _titleLB;
}
- (UILabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [UILabel new];
        _contentLB.textColor = [UIColor whiteColor];
        _contentLB.font = MFont(12.0);
        _contentLB.numberOfLines = 0 ;
    }return _contentLB;
}

- (UILabel *)tagLab {
    if (!_tagLab) {
        _tagLab = [UILabel new];
        _tagLab.textColor = [UIColor whiteColor];
        _tagLab.font = MFont(12.0);
        _tagLab.layer.cornerRadius = 6;
        _tagLab.layer.borderColor = [UIColor whiteColor].CGColor;
        _tagLab.layer.borderWidth = 0.5;
        _tagLab.textAlignment = NSTextAlignmentCenter;
    }return _tagLab;
}

- (UIButton *)infoBtn {
    if (!_infoBtn) {
        _infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_infoBtn setTitle:@"" forState:UIControlStateNormal];
        [_infoBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    }return _infoBtn ;
}

@end
