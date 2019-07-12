//
//  MHVolActivityApplyListSectionView.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVolActivityApplyListModel.h"
@interface MHVolActivityApplyListSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *countLB;

+ (MHVolActivityApplyListSectionView *)volActivityApplySectionView;
@end
