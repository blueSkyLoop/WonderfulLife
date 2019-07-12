//
//  MHVoNaviBigTitleHeaderView.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoNaviBigTitleHeaderView.h"
#import "MHMacros.h"
@implementation MHVoNaviBigTitleHeaderView

+ (instancetype)voNaviBigTitleHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

@end
