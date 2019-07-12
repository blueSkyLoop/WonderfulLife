//
//  MHHomeCommunityCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeCommunityCell.h"
#import "MHMacros.h"

@implementation MHHomeCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mh_subject setTextAlignment:NSTextAlignmentLeft];
    self.mh_imageView.layer.cornerRadius = 3;
    self.mh_imageView.layer.masksToBounds = YES;
    UIView *view = [UIView new];
    view.backgroundColor = MColorDidSelectCell;
    self.selectedBackgroundView = view;
}

@end
