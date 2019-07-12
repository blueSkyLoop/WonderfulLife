//
//  MHStHoRecommandGoodsView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStHoRecommandGoodsView.h"
#import "MHStoreHomeModel.h"

#import "UIImageView+WebCache.h"

@interface MHStHoRecommandGoodsView ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MHStHoRecommandGoodsView

+ (instancetype)recommandGoodsView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setGoodsModel:(MHStHomeGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.img_cover] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
    [self.nameLabel setText:goodsModel.coupon_name];
    self.salesLabel.text = goodsModel.coupon_sales;
    self.priceLabel.text = goodsModel.coupon_price;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (IBAction)buttonDidClick {
    if ([self.delegate respondsToSelector:@selector(goodsDetailWithIndex:)]) {
        [self.delegate goodsDetailWithIndex:self.tag];
    }
}
#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







