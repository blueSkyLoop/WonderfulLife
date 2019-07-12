//
//  UIView+MHMHAutoCalculaSize.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MHMHAutoCalculaSize)

- (CGSize)mh_autoCalculaSize;
- (CGSize)mh_autoCalculaSizeWithCalculaWidth:(CGFloat)width;
- (CGSize)mh_autoCalculaSizeWithCalculaWidth:(CGFloat)width needRemoveWidthLayout:(BOOL)needRemoveWidthLayout;

@end
