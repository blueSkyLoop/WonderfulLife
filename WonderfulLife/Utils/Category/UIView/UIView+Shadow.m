//
//  UIView+Shadow.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIView+Shadow.h"
#import "MHMacros.h"
@implementation UIView (Shadow)

- (void)mh_setupContainerLayerWithContainerView{
    
    self.layer.cornerRadius = 6;
    self.layer.borderColor = MColorSeparator.CGColor;
    self.layer.borderWidth = 0.5;
    
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 5;
    self.layer.shadowColor = MColorShadow.CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
}


@end
