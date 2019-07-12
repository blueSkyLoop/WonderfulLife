//
//  MHLoSelectCityCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHLoSelectCityCell.h"

#import "MHMacros.h"

@implementation MHLoSelectCityCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = MColorSeparator.CGColor;
    self.contentView.layer.cornerRadius = 4;
}

@end
