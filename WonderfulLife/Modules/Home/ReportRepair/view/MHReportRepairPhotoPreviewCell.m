//
//  MHReportRepairPhotoPreviewCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairPhotoPreviewCell.h"
#import "UIImageView+WebCache.h"
#import "MHReportRepairPhotoPreViewModel.h"

@implementation MHReportRepairPhotoPreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)showIndicator{
    self.Indicator.hidden = NO;
    if(![self.Indicator isAnimating]){
        [self.Indicator startAnimating];
    }
}
-(void)hideIndicator{
    
    if([self.Indicator isAnimating]){
        [self.Indicator stopAnimating];
    }
}

- (void)mh_configCellWithInfor:(MHReportRepairPhotoPreViewModel *)model{
    [self hideIndicator];
    if(model.type == 1){
        
        [self showIndicator];
        __weak __typeof(self)weakSelf= self;
        [self.picTureView sd_setImageWithURL:[NSURL URLWithString:model.bigPicUrl] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong __typeof(self)strongSelf = weakSelf;
            if(image){
                strongSelf.picTureView.image = image;
            }
            [strongSelf hideIndicator];
        }];
        
    }else if(model.type == 2){
        UIImage *image = [UIImage imageNamed:model.bigPicName];
        self.picTureView.image = image?:[UIImage imageNamed:@"StHoRePlaceholder"];
        
    }else if(model.type == 3){
        self.picTureView.image = model.bigImage?:[UIImage imageNamed:@"StHoRePlaceholder"];
    }
}


@end
