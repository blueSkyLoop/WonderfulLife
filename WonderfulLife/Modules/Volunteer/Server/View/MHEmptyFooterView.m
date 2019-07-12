//
//  MHEmptyFooterView.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHEmptyFooterView.h"
#import "UIView+EmptyView.h"

#import "MHMacros.h"

@implementation MHEmptyFooterView

+ (instancetype)voSerEmptyViewImageName:(NSString *)imageName title:(NSString *)title{
//    F9FAFC
//    MHEmptyFooterView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
//    MHEmptyFooterView *view = [[MHEmptyFooterView alloc] initWithFrame:CGRectMake(24, 0, MScreenW - 48, 264)];
//    view.backgroundColor = MColorToRGB(0xF9FAFC);
//    [view mh_addEmptyViewImageName:imageName title:title];
    
    
    
    MHEmptyFooterView *footerView = [[MHEmptyFooterView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 268)];
    footerView.backgroundColor = MColorToRGB(0xF9FAFC);
    [footerView mh_addEmptyViewImageName:imageName title:title];
    
    return footerView;
}

@end
