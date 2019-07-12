//
//  MHStoreGoodsDetailBottomView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsDetailBottomView.h"
#import "LCommonModel.h"
#import "Masonry.h"
#import "MHMacros.h"

@implementation MHStoreGoodsDetailBottomView

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.clipsToBounds = YES;
    UIView *lineView = [UIView new];
    lineView.backgroundColor = MRGBColor(211, 220, 230);
    [self addSubview:lineView];
    [self addSubview:self.priceLable];
    [self addSubview:self.doorPriceLable];
    [self addSubview:self.buyButton];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@.5);
    }];
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_doorPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLable.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.doorPriceLable.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@42);
        make.width.equalTo(@103);
    }];
    
    for(CALayer *layer in _buyButton.superview.layer.sublayers){
        if(layer.name && [layer.name isEqualToString:@"buttonShadow"]){
            layer.shadowOffset = CGSizeMake(0, 1);
            layer.shadowRadius = 4;
            [layer layoutIfNeeded];
            break;
        }
    }
    
    
}

- (void)configBottomViewWithModel:(MHStoreGoodsDetailModel *)model{
    
    NSString *price = model.coupon_price?:@" ";
    NSMutableAttributedString *attribuStrPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",price]];
    UIFont *afont;
    if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
        afont = [UIFont systemFontOfSize:MScale * 24 weight:UIFontWeightMedium];
    }else{
        afont = [UIFont systemFontOfSize:MScale * 24];
    }
    [attribuStrPrice addAttribute:NSFontAttributeName value:afont range:NSMakeRange(1, [price length])];
    self.priceLable.attributedText = attribuStrPrice;
    
    NSString *retail_priceStr = [NSString stringWithFormat:@"%@%@",@"¥",model.retail_price?:@" "];
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
    
    [self.doorPriceLable setAttributedText:attri];
    //下架了或者没有库存
    if(model.sale_status == 1 || model.inventory <= 0){
        self.buyButton.enabled = NO;
    }else{
        self.buyButton.enabled = YES;
    }
    if(model.sale_status == 1){
        [self.buyButton setTitle:@"已下架" forState:UIControlStateNormal];
    }else{
        [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
}

#pragma mark - lazyload
- (UILabel *)priceLable{
    if(!_priceLable){
        UIFont *afont;
        if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
            afont = [UIFont systemFontOfSize:MScale * 20 weight:UIFontWeightMedium];
        }else{
            afont = [UIFont systemFontOfSize:MScale * 20];
        }
        _priceLable = [LCommonModel quickCreateLabelWithFont:afont textColor:MRGBColor(252, 61, 91)];
    }
    return _priceLable;
}
- (UILabel *)doorPriceLable{
    if(!_doorPriceLable){
        _doorPriceLable = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 16] textColor:MRGBColor(132, 146, 166)];
    }
    return _doorPriceLable;
}

- (MHThemeButton *)buyButton{
    if(!_buyButton){
        _buyButton = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
            _buyButton.titleLabel.font = [UIFont systemFontOfSize:MScale * 16 weight:UIFontWeightMedium];
        }else{
            _buyButton.titleLabel.font = [UIFont systemFontOfSize:MScale * 16];
        }
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyButton.layer.cornerRadius = 2;
        _buyButton.layer.masksToBounds = YES;
        
        _buyButton.enabled = NO;
        
    }
    return _buyButton;
}

@end
