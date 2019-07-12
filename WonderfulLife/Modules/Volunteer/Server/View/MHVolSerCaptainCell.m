//
//  MHVolSerCaptainCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerCaptainCell.h"
@interface MHVolSerCaptainCell()


@end


@implementation MHVolSerCaptainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mh_imageView.userInteractionEnabled = YES;
    CGRect  imageFrame = self.mh_imageView.frame ;
    self.mh_imageView.layer.cornerRadius = imageFrame.size.width*0.5  ;
    self.mh_imageView.layer.masksToBounds = YES ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView)];
    [self.mh_imageView addGestureRecognizer:tap];
}
- (IBAction)callAction:(id)sender {
//    self.phoneBtn.userInteractionEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(CaptainCellDidClickCallButtonAtIndexPath:sender:)]) {
        [self.delegate CaptainCellDidClickCallButtonAtIndexPath:self.indexPath sender:sender];
    }
}

- (void)tapHeadView {
    if ([self.delegate respondsToSelector:@selector(CaptainCellDidClickHeadViewAtIndexPath:)]) {
        [self.delegate CaptainCellDidClickHeadViewAtIndexPath:self.indexPath];
    }
}

@end
