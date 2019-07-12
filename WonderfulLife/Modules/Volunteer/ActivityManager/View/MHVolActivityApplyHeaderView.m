//
//  MHVolActivityApplyHeaderView.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityApplyHeaderView.h"


@implementation MHVolActivityApplyHeaderView

+ (MHVolActivityApplyHeaderView *)volActivityApplyHeaderViewWithModel:(MHVolActivityApplyListModel *)model{
    
    MHVolActivityApplyHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MHVolActivityApplyHeaderView class]) owner:nil options:nil].lastObject ;
    
    view.alreadyApplyCountLB.text = [NSString stringWithFormat:@"%ld人",[model.yty integerValue]];
    
    
    if ([model.qty integerValue]) {
        view.totalCountLB.text = [NSString stringWithFormat:@"%ld人",[model.qty integerValue]];
    }else{
        view.totalCountLB.text = @"不限";
    }
    

    
    return view ;
    
}

@end
