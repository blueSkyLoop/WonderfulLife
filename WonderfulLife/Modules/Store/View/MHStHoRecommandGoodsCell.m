//
//  MHStHoRecommandGoodsCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStHoRecommandGoodsCell.h"
#import "MHStHoRecommandGoodsView.h"

#import "MHStoreHomeModel.h"

#import "MHMacros.h"
#import "UIView+NIM.h"
#import "Masonry.h"

@interface MHStHoRecommandGoodsCell ()

@end

@implementation MHStHoRecommandGoodsCell

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setModel:(MHStoreHomeModel *)model{
    _model = model;
    CGFloat imageWidth = (MScreenW - 16*2 -13)/2;
    CGFloat itemHeight1 = imageWidth + 112;
    CGFloat itemHeight2 = imageWidth + 121;
    
    NSInteger cachCount = self.contentView.subviews.count;
    NSInteger newCount = model.recommend_coupon_list.count;
    if (cachCount > newCount) { //移除缓存
        NSInteger deleteCount = cachCount - newCount;
        for (NSInteger i = 0; i < deleteCount; i++) {
            [self.contentView.subviews.lastObject removeFromSuperview];
            cachCount --;
        }
    }
    for (NSInteger i = 0; i < cachCount; i++) {
        MHStHoRecommandGoodsView *goodsView = self.contentView.subviews[i];
        goodsView.goodsModel = model.recommend_coupon_list[i];
        goodsView.tag = i;
        if (i == cachCount-1) {
            if ( cachCount==newCount) {
                [goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }else{
                CGFloat x = i % 2 == 0 ? 16 : 16 + imageWidth + 13;
                CGFloat y = i / 2  == 0 ? 0 : itemHeight1;
                [goodsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(x);
                    make.top.mas_equalTo(y);
                    make.width.mas_equalTo(imageWidth);
                    make.height.mas_equalTo(y==0 ? itemHeight1 : itemHeight2);
                }];
            }
        }
    }
    
    for (NSInteger i = cachCount; i < newCount; i++) {
        MHStHoRecommandGoodsView *goodsView = [MHStHoRecommandGoodsView recommandGoodsView];
        goodsView.goodsModel = model.recommend_coupon_list[i];
        goodsView.tag = i;
        CGFloat x = i % 2 == 0 ? 16 : 16 + imageWidth + 13;
        CGFloat y = i / 2  == 0 ? 0 : itemHeight1;
        
        [self.contentView addSubview:goodsView];
        [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.top.mas_equalTo(y);
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(y==0 ? itemHeight1 : itemHeight2);
            if (i == newCount-1) {
                make.bottom.mas_equalTo(0);
            }
        }];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







