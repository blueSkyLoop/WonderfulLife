//
//  MHHomePaySectionHeaderView.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePaySectionHeaderView.h"

@interface MHHomePaySectionHeaderView ()


@end

@implementation MHHomePaySectionHeaderView

/**
 加载物业缴费tableView每组头部视图
 */
+ (instancetype)loadPaySectionHeaderView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
