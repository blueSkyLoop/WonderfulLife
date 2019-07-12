//
//  MHHomeCommunityCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeCollectionCommunityCell.h"
#import "MHMacros.h"
#import "MHHomeArticle.h"
#import "UIImageView+WebCache.h"

@implementation MHHomeCollectionCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mh_subject setTextAlignment:NSTextAlignmentLeft];
    self.mh_imageView.layer.cornerRadius = 3;
    self.mh_imageView.clipsToBounds = YES;
//    UIView *view = [UIView new];
//    view.backgroundColor = MColorDidSelectCell;
//    self.selectedBackgroundView = view;
}

- (void)mh_collectionViewCellWithModel:(MHHomeArticle*)model {
    [self.mh_subject setText:model.subject];
    [self.mh_timeLabel setText:model.post_time];
    [self.mh_imageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]
                         placeholderImage:[UIImage imageNamed:@"homeCommunityPlaceholder"]];
}

@end
