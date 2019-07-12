//
//  UIView+MHMHAutoCalculaSize.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIView+MHMHAutoCalculaSize.h"

static NSString *const widthLayoutIdentifier = @"layoutWidth";

@implementation UIView (MHMHAutoCalculaSize)
- (CGSize)mh_autoCalculaSize{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return [self mh_autoCalculaSizeWithCalculaWidth:width needRemoveWidthLayout:NO];
}

- (CGSize)mh_autoCalculaSizeWithCalculaWidth:(CGFloat)width{
    return [self mh_autoCalculaSizeWithCalculaWidth:width needRemoveWidthLayout:NO];
}

- (CGSize)mh_autoCalculaSizeWithCalculaWidth:(CGFloat)width needRemoveWidthLayout:(BOOL)needRemoveWidthLayout{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",widthLayoutIdentifier];
    NSArray *arr = [self.constraints filteredArrayUsingPredicate:predicate];
    BOOL isAddWidthLayout = arr.count?YES:NO;
    NSLayoutConstraint *widthLayout;
    if(isAddWidthLayout){
        widthLayout = [arr firstObject];
    }
    if(!isAddWidthLayout){
        widthLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
        widthLayout.identifier = widthLayoutIdentifier;
        [self addConstraint:widthLayout];
    }
    CGSize asize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if(needRemoveWidthLayout && widthLayout){
        [self removeConstraint:widthLayout];
    }
    return asize;
}
@end
