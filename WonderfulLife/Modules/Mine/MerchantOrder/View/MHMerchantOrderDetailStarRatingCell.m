//
//  MHMerchantOrderDetailStarRatingCell.m
//  WonderfulLife
//
//  Created by zz on 27/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailStarRatingCell.h"

@interface MHMerchantOrderDetailStarRatingCell ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *merchantStarsLevel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *goodsStarsLevel;
@end

@implementation MHMerchantOrderDetailStarRatingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)mh_configCellWithInfor:(id)model {
    
}

- (IBAction)touchedMerchantStarsLevelEvent:(UIButton *)sender {
    NSUInteger idx = sender.tag - 659;
    [self showMerchantStarsLevel:idx];
    if ([self.delegate respondsToSelector:@selector(mh_touchedMerchantReviewLevelStars:)]) {
        [self.delegate mh_touchedMerchantReviewLevelStars:@(idx)];
    }
}


- (IBAction)touchedGoodsStarsLevelEvent:(UIButton *)sender {
    NSUInteger idx = sender.tag - 669;
    [self showGoodsStarsLevel:idx];
    if ([self.delegate respondsToSelector:@selector(mh_touchedGoodsReviewLevelStars:)]) {
        [self.delegate mh_touchedGoodsReviewLevelStars:@(idx)];
    }
}


- (void)showMerchantStarsLevel:(NSUInteger)levels {

    [_merchantStarsLevel enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < levels) {
            obj.selected = YES;
        }else {
            obj.selected = NO;
        }
    }];
    
}

- (void)showGoodsStarsLevel:(NSUInteger)levels {
    [_goodsStarsLevel enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < levels) {
            obj.selected = YES;
        }else {
            obj.selected = NO;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
