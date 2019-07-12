//
//  MHRefreshGifHeader.m
//  WonderfulLife
//
//  Created by zz on 21/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHRefreshGifHeader.h"

@implementation MHRefreshGifHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=29; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mh_dropdown_anim__%zd", i]];
        [idleImages addObject:image];
    }
    [idleImages insertObject:[UIImage imageNamed:@"mh_dropdown_loading_9"] atIndex:0];
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mh_dropdown_loading_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

}

@end
