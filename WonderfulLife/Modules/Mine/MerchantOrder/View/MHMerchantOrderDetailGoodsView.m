//
//  MHMerchantOrderDetailGoodsView.m
//  WonderfulLife
//
//  Created by zz on 25/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailGoodsView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHMerchantOrderDetailModel.h"
#import "UIImageView+WebCache.h"

@interface MHMerchantOrderDetailGoodsView ()
@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *goodsName;
@property (nonatomic,strong) UILabel *shopDistance;
@property (nonatomic,strong) UILabel *goodsPrice;
@property (nonatomic,strong) UILabel *goodsOriginalPrice;
@property (nonatomic,strong) UILabel *shopName;

@property(nonatomic,strong)UIView *whiteView;
@property(nonatomic,strong)UIImageView *arrowImageView;

@property (nonatomic,strong) NSNumber *merchantID;
@property (nonatomic,strong) NSNumber *goodID;

@end

@implementation MHMerchantOrderDetailGoodsView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self layoutAllSubviews];
        [self mh_addGestureEvents];
        
    }
    return self;
}

- (void)mh_addGestureEvents {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapfoodBaseView)];
    [_whiteView addGestureRecognizer:gesture];
}

- (void)tapfoodBaseView {
    if ([self.delegate respondsToSelector:@selector(mh_touchedGoodsBaseView:)]) {
        [self.delegate mh_touchedGoodsBaseView:self.goodID];
    }
}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel *)model {
    if (model.coupon_img_cover) {
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.coupon_img_cover]];
    }else {
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img_cover]];
    }
    self.goodsName.text = model.coupon_name;
    self.shopName.text = model.merchant_name;
    
    self.merchantID = model.merchant_id;
    self.goodID = model.coupon_id;
    
    self.shopDistance.text = model.distance?:@"";
    if ([model.goods_type isEqualToNumber:@0]) {
        self.goodsPrice.text = model.coupon_price?[NSString stringWithFormat:@"¥ %@",model.coupon_price]:@"";
        
        if (model.retail_price) {
            [self attributePrice:[NSString stringWithFormat:@"¥ %@",model.retail_price]];
        }
    }
    
}

- (void)attributePrice:(NSString *)price {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSRange range = NSMakeRange(0, price.length);
    [attributedStr addAttribute:NSForegroundColorAttributeName
                    value:MColorToRGB(0X99A9BF)
                    range:range];
    [attributedStr addAttribute:NSStrikethroughStyleAttributeName
                          value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                          range:range];
    [attributedStr addAttribute:NSStrikethroughColorAttributeName value:MColorToRGB(0X99A9BF) range:range];
    self.goodsOriginalPrice.attributedText = attributedStr;
    
}

- (void)layoutAllSubviews {
    _whiteView = [UIView new];
    _whiteView.backgroundColor = MColorDidSelectCell;
    [self addSubview:_whiteView];
    [self.contentView addSubview:self.shopName];
    [self.contentView addSubview:self.arrowImageView];

    [_whiteView addSubview:self.goodsImageView];
    [_whiteView addSubview:self.goodsName];
    [_whiteView addSubview:self.shopDistance];
    [_whiteView addSubview:self.goodsPrice];
    [_whiteView addSubview:self.goodsOriginalPrice];
    
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.mas_right).mas_offset(-16);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shopName.mas_right).mas_offset(-8);
        make.centerY.mas_equalTo(self.shopName);
        make.height.mas_equalTo(12);
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.whiteView);
        make.size.mas_equalTo(80);
    }];
    
    [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whiteView.mas_right).mas_offset(-16);
        make.top.mas_equalTo(self.goodsImageView);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(130); //限制价格位数9位+小数点后两位
    }];
    
    [self.goodsOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goodsPrice.mas_right);
        make.top.mas_equalTo(self.goodsPrice.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(130); //限制价格位数9位+小数点后两位
    }];

    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.goodsImageView);
        make.right.mas_lessThanOrEqualTo(self.goodsPrice.mas_left);
    }];
    
    [self.shopDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.goodsName.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(self.goodsName);
    }];

    self.shopName.userInteractionEnabled = YES;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedMerchantName:)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.shopName addGestureRecognizer:gesture];

}

- (void)touchedMerchantName:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(mh_touchedMerchantShopName:)]) {
        [self.delegate mh_touchedMerchantShopName:self.merchantID];
    }
}

#pragma mark - Getter
- (UIImageView*)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [UIImageView new];
        _goodsImageView.image = [UIImage imageNamed:@"mi_AboutUs"];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (UIImageView*)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"common_right_arrow"];
    }
    return _arrowImageView;
}


- (UILabel *)goodsName {
    if (!_goodsName) {
        _goodsName = [UILabel new];
        _goodsName.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
        _goodsName.textColor = MColorTitle;
    }
    return _goodsName;
}

- (UILabel *)shopDistance {
    if (!_shopDistance) {
        _shopDistance = [UILabel new];
        _shopDistance.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
        _shopDistance.textColor = MColorToRGB(0X99A9BF);
    }
    return _shopDistance;
}

- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [UILabel new];
        _goodsPrice.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
        _goodsPrice.textColor = MColorTitle;
        _goodsPrice.textAlignment = NSTextAlignmentRight;
    }
    return _goodsPrice;
}

- (UILabel *)goodsOriginalPrice {
    if (!_goodsOriginalPrice) {
        _goodsOriginalPrice = [UILabel new];
        _goodsOriginalPrice.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
        _goodsOriginalPrice.textColor = MColorToRGB(0X99A9BF);
        _goodsOriginalPrice.textAlignment = NSTextAlignmentRight;
    }
    return _goodsOriginalPrice;
}

- (UILabel *) shopName {
    if (!_shopName) {
        _shopName = [UILabel new];
        _shopName.font = [UIFont systemFontOfSize:14.f];
        _shopName.textColor = MColorTitle;
        _shopName.textAlignment = NSTextAlignmentLeft;
    }
    return _shopName;
}

@end
