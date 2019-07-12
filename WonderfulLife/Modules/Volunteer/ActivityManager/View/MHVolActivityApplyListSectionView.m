//
//  MHVolActivityApplyListSectionView.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityApplyListSectionView.h"

@implementation MHVolActivityApplyListSectionView


+ (MHVolActivityApplyListSectionView *)volActivityApplySectionView {
    
    MHVolActivityApplyListSectionView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MHVolActivityApplyListSectionView class]) owner:nil options:nil].lastObject ;
    return view ;
    
}

@end
