//
//  MHVolServiceTimeHeaderView.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVolCheckTimeEnum.h"

@interface MHVolCheckTimeHeaderView : UIView

+ (MHVolCheckTimeHeaderView *)volCheckTimeHeaderViewWithType:(MHVolCheckTimeType)type hours:(CGFloat)hours;

@end
