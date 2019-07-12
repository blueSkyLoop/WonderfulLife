//
//  MHStHoRecommandShopView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStHoRecommandShopView.h"

#import "MHStoreHomeModel.h"

#import "UIView+NIM.h"
#import "UIImageView+WebCache.h"

@interface MHStHoRecommandShopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *starContainerView;

@end

@implementation MHStHoRecommandShopView

+ (instancetype)recommandShopView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

#pragma mark - override
- (void)awakeFromNib{
    [super awakeFromNib];
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.starContainerView.subviews[i];
        imageView.highlighted = YES;
    }
}

- (void)setShopModel:(MHStHoShopModel *)shopModel{
    _shopModel = shopModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shopModel.img_cover] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
    [self.label setText:shopModel.merchant_name];
    [self.starContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < shopModel.star) {
            obj.highlighted = YES;
        }else{
            obj.highlighted = NO;            
        }
    }];
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - 按钮点击

- (IBAction)buttonDidClick {
    if ([self.delegate respondsToSelector:@selector(shopDetailWithIndex:)]) {
        [self.delegate shopDetailWithIndex:self.tag];
    }
}

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







