//
//  MHHomePaySectionHeaderView.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHHomePaySectionHeaderView : UIView
/**
 时间Label
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 加载物业缴费tableView每组头部视图
 */
+ (instancetype)loadPaySectionHeaderView;

@end
