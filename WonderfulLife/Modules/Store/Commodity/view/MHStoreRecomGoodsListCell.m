//
//  MHStoreRecomGoodsListCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRecomGoodsListCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "UIImageView+WebCache.h"
#import "MHStoreSearchModel.h"
#import "MHAliyunManager.h"

@implementation MHStoreRecomGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
    
    self.distanceBgView.layer.borderWidth = 1;
    self.distanceBgView.layer.borderColor = [MRGBColor(132, 146, 166) CGColor];
    self.distanceBgView.layer.cornerRadius = 4;
    self.distanceBgView.layer.masksToBounds = YES;
    UIView *view = [UIView new];
    view.backgroundColor = MColorDidSelectCell;
    self.selectedBackgroundView = view;
    self.merchantNameRightLayout.constant = 140 * MScale;
}

- (void)mh_configCellWithInfor:(MHStoreRecomGoodsListModel *)model{
    
    if(model.img_cover && model.img_cover.length){
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:model.img_cover] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
    }else{
        self.pictureView.image = MAvatar;
    }
    self.nameLabel.text = model.coupon_name;
    self.merchantNameLabel.text = model.merchant_name;
    
    if(model.coupon_price && model.coupon_price.length){
        NSString *priceStr = [NSString stringWithFormat:@"%@%@",@"￥",model.coupon_price];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MScale * 14] range:NSMakeRange(0, 1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MScale * 18] range:NSMakeRange(1, model.coupon_price.length)];
        self.priceLabel.attributedText = attrStr;
        
    }else{
        self.priceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    }
    if(model.retail_price && model.retail_price.length){
        NSString *retail_priceStr = [NSString stringWithFormat:@"%@%@%@",@"门市价：",@"¥",model.retail_price];
        NSUInteger length = [retail_priceStr length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:retail_priceStr];
        if([UIDevice currentDevice].systemVersion.floatValue >= 8.3){
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:MRGBColor(132, 146, 166) range:NSMakeRange(0, length)];
            [attri addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, length)];
        }else{
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:MRGBColor(132, 146, 166) range:NSMakeRange(0, length)];
        }
        [self.marketPriceLabel setAttributedText:attri];
        
    }else{
        self.marketPriceLabel.attributedText = nil;
    }
    
    if(model.distance && ![model.distance isEqual:[NSNull null]] && model.distance.length){
        self.distanceBgView.hidden = NO;
        self.distanLabel.text = model.distance;
    }else{
        self.distanceBgView.hidden = YES;
        self.distanLabel.text = nil;
        
    }
    self.saleLabel.text = [NSString stringWithFormat:@"%@%ld",@"销量：",model.coupon_sales];
    
}

- (void)setSearchModel:(MHStoreSearchGoodsModel *)searchModel{
    _searchModel = searchModel;
    
    MHOOSImageModel *imageModel = searchModel.img_cover.firstObject;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:imageModel.url] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];

    self.nameLabel.text = searchModel.coupon_name;
    self.merchantNameLabel.text = searchModel.merchant_name;
    
    if(searchModel.coupon_price && searchModel.coupon_price.length){
        NSString *priceStr = [NSString stringWithFormat:@"%@%@",@"￥",searchModel.coupon_price];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MScale * 14] range:NSMakeRange(0, 1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MScale * 18] range:NSMakeRange(1, searchModel.coupon_price.length)];
        self.priceLabel.attributedText = attrStr;
        
    }else{
        self.priceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    }
    if(searchModel.retail_price && searchModel.retail_price.length){
        NSString *retail_priceStr = [NSString stringWithFormat:@"%@%@%@",@"门市价：",@"¥",searchModel.retail_price];
        NSUInteger length = [retail_priceStr length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:retail_priceStr];
        if([UIDevice currentDevice].systemVersion.floatValue >= 8.3){
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:MRGBColor(132, 146, 166) range:NSMakeRange(0, length)];
            [attri addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, length)];
        }else{
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:MRGBColor(132, 146, 166) range:NSMakeRange(0, length)];
        }
        [self.marketPriceLabel setAttributedText:attri];
        
    }else{
        self.marketPriceLabel.attributedText = nil;
    }
    
    if(searchModel.distance && ![searchModel.distance isEqual:[NSNull null]] && searchModel.distance.length){
        self.distanceBgView.hidden = NO;
        self.distanLabel.text = searchModel.distance;
    }else{
        self.distanceBgView.hidden = YES;
        self.distanLabel.text = nil;
        
    }
    self.saleLabel.text = [NSString stringWithFormat:@"%@%ld",@"销量：",searchModel.coupon_sales];
}


@end
