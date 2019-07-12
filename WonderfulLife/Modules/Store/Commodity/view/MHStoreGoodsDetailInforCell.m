//
//  MHStoreGoodsDetailInforCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsDetailInforCell.h"
#import "LCommonModel.h"

#import "MHStoreGoodsDetailModel.h"

@interface MHStoreGoodsDetailInforCell()

@property (nonatomic,strong)MHStoreGoodsDetailModel *amodel;

@end

@implementation MHStoreGoodsDetailInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.merchantBgView addGestureRecognizer:tap];
    
    [self.evaluateBgView addSubview:self.starView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)mh_configCellWithInfor:(MHStoreGoodsDetailModel *)model{
    self.amodel = model;
    self.starView.currentScore = model.star;
    self.merchantNameLabel.text = model.merchant_name;
    self.dateLabel.text = [NSString stringWithFormat:@"%@%@%@",model.expiry_time_begin?:@"",(model.expiry_time_begin && model.expiry_time_end)?@"至":@"",model.expiry_time_end?:@""];
    
    if(model.distance && ![model.distance isEqual:[NSNull null]] && model.distance.length){
        self.distanceLabel.text = model.distance;
        self.distanceTitleLabel.text = @"当前距离：";
        self.distanceTopLaout.constant = 12;
    }else{
        
        self.distanceTitleLabel.text = nil;
        self.distanceTopLaout.constant = 0;
        
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    self.merchantBgView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.merchantBgView.userInteractionEnabled = YES;
        
    });
    if(self.merchantClikBlock){
        self.merchantClikBlock();
    }
}

- (XHStarRateView *)starView{
    if(!_starView){
        _starView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 16 * 5 + 3 * 4, 14) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:^(CGFloat currentScore) {
                
        } normalImage:[UIImage imageNamed:@"StoreHomeStarHighlight"] selectedImage:[UIImage imageNamed:@"StoreHomeStarGray"]];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

@end
