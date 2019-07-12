//
//  MHStoreShopSummaryCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreShopSummaryCell.h"

#import "MHStoShopDetailModel.h"
#import "MHStoShopSummaryModel.h"

#import "MHAliyunManager.h"
#import "MHMacros.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface MHStoreShopSummaryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *starContainerView;

@end

@implementation MHStoreShopSummaryCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    self.distanceLabel.layer.cornerRadius = 4;
    self.distanceLabel.layer.borderColor = MColorFootnote.CGColor;
    self.distanceLabel.layer.masksToBounds = YES;
    self.distanceLabel.layer.borderWidth = 1;
    UIView *view = [UIView new];
    view.backgroundColor = MColorDidSelectCell;
    self.selectedBackgroundView = view;
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = self.starContainerView.subviews[i];
        button.selected = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setShopModel:(MHStoShopDetailModel *)shopModel{
    _shopModel = shopModel;
    MHOOSImageModel *imageModel = shopModel.img_cover.firstObject;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageModel.url] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
    self.nameLabel.text = shopModel.merchant_name;
    self.summaryLabel.text = shopModel.merchant_summary;
    
    if (shopModel.distance.length) {
        self.distanceLabel.text = shopModel.distance;
        self.distanceLabel.hidden = NO;
        [self.distanceLabel sizeToFit];
        CGFloat width = self.distanceLabel.frame.size.width + 9;
        [self.distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width > 44 ? width : 44));
        }];
    }else{
        self.distanceLabel.hidden = YES;
    }
    
    [self.starContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = idx < shopModel.star;
    }];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",shopModel.average_spend];
}

- (void)setSummaryModel:(MHStoShopSummaryModel *)summaryModel{
    _summaryModel = summaryModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:summaryModel.img_cover] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
    self.nameLabel.text = summaryModel.merchant_name;
    self.summaryLabel.text = summaryModel.merchant_summary;
    
    if (summaryModel.distance) {
        self.distanceLabel.text = summaryModel.distance;
        [self.distanceLabel sizeToFit];
        CGFloat width = self.distanceLabel.frame.size.width + 9;
        [self.distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width > 44 ? width : 44));
        }];
    }else{
        self.distanceLabel.hidden = YES;
    }
    
    [self.starContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = idx < summaryModel.star;
    }];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",summaryModel.average_spend];
}
#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







