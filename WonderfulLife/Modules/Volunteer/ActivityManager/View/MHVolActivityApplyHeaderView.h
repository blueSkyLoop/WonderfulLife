//
//  MHVolActivityApplyHeaderView.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVolActivityApplyListModel.h"

@interface MHVolActivityApplyHeaderView : UIView


@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *alreadyApplyCountLB;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLB;


+ (MHVolActivityApplyHeaderView *)volActivityApplyHeaderViewWithModel:(MHVolActivityApplyListModel *)model ;

@end
