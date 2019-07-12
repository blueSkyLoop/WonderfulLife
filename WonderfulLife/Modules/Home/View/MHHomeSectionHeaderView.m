//
//  MHHomeSectionHeaderView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeSectionHeaderView.h"

@implementation MHHomeSectionHeaderView
+ (instancetype)awakeFromXib {
    return [[UINib nibWithNibName:NSStringFromClass([MHHomeSectionHeaderView class]) bundle:[NSBundle mainBundle]]
     instantiateWithOwner:nil options:nil].firstObject;
}
@end
