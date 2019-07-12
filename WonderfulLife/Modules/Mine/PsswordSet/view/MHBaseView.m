//
//  MHBaseView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"

@implementation MHBaseView

+ (id)loadViewFromXib{
    UIView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    return aview;
}

@end
