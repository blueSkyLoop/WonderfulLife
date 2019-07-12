//
//  MHVolActivityDetailsHeaderView.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MHVolActivityDetailsModel;
@interface MHVolActivityDetailsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamNameLB;

+ (instancetype)activityDetailsHeaderView:(MHVolActivityDetailsModel *)model;
@end
