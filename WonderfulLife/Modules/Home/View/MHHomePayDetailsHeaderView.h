//
//  MHHomePayDetailsHeaderView.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHHomePayDetailsHeaderView : UIView
/**
 标题Label
 */
@property (weak, nonatomic) UILabel *titleLabel;
/**
 底部分割线
 */
@property (weak, nonatomic) UIView *bottomLine;

/**
 加载物业缴费头部视图
 */
+ (instancetype)loadHomePayDetailsHeaderView;

@end
