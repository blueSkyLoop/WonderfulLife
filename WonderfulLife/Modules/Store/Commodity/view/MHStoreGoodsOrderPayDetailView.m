//
//  MHStoreGoodsOrderPayDetailView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsOrderPayDetailView.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@implementation MHStoreGoodsOrderPayDetailView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
    
    self.scoreBgView.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
    self.scoreBgView.layer.borderWidth = 1;
    
    self.scoreBgView.layer.cornerRadius = 3;
    self.scoreBgView.layer.masksToBounds = YES;
    
    
}

@end
