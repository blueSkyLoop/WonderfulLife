//
//  MHMineQrInfoHeaderView.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineQrInfoHeaderView.h"

#import "MHMineMerchantInfoModel.h"

#import "MHMacros.h"
#import "UIImage+Color.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+Category.h"
#import "UILabel+isNull.h"

#import "PYPhotoBrowser.h"
#import "MHLogMacros.h"

@interface MHMineQrInfoHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *intLab;

@property (weak, nonatomic) IBOutlet PYPhotosView *cover;
@end


@implementation MHMineQrInfoHeaderView
+ (instancetype)mineQRInfoHeaderView:(MHMineMerchantInfoModel *)model {
    MHMineQrInfoHeaderView * view = [[NSBundle mainBundle] loadNibNamed:@"MHMineQrInfoHeaderView" owner:nil options:nil].lastObject;
    view.model = model ;
    return view;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgImage.image = [UIImage mh_gradientImageWithBounds:CGRectMake(0, 0, MScreenW, CGRectGetHeight(self.frame)) direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
    self.nameLab.font = MFont(MScale* 25);
}


- (void)setModel:(MHMineMerchantInfoModel *)model {
    _model = model ;
    
    [self.nameLab mh_isNullText:model.name];
    
    self.intLab.text = [NSString stringWithFormat:@"爱心积分:%@",model.score];
    
    [self.intLab mh_isNullWithDataSourceText:model.score allText:[NSString stringWithFormat:@"爱心积分:%@",model.score] isNullReplaceString:@""];
    
    [self.cover setThumbnailUrls:@[model.user_s_img]];
    [self.cover setOriginalUrls:@[model.user_img]];

    [self layoutIfNeeded];
    CGRect  imageFrame = self.cover.frame ;
    self.cover.layer.cornerRadius = imageFrame.size.width*0.5  ;
    self.cover.layer.masksToBounds = YES ;

}

@end
