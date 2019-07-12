//
//  MHVolSerDetailSectionView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolSerDetailSectionView : UIView
+(instancetype)awakeFromNib;
@property (weak, nonatomic) IBOutlet UILabel *mh_leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_rightLabel;
@end
