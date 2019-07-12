//
//  MHVolSerMemberItemCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerMemberItemCell.h"

@implementation MHVolSerMemberItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mh_imageView.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
}

@end
