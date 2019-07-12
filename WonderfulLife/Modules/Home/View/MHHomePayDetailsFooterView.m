//
//  MHHomePayDetailsFooterView.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayDetailsFooterView.h"

@interface MHHomePayDetailsFooterView ()


@end

@implementation MHHomePayDetailsFooterView
/**
 加载物业缴费底部视图
 */
+ (instancetype)loadPayDetailsFooterView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
