//
//  UIView+chain.h
//  testdemo
//
//  Created by hanl on 2016/12/14.
//  Copyright © 2016年 hanl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  UIView *(^HLFramePropertyBlock)(CGFloat);
typedef  UIView *(^HLFramePointBlock)(CGFloat,CGFloat);
typedef  UIView *(^HLFrameBlock)(CGFloat,CGFloat,CGFloat,CGFloat);
typedef  void (^HLViewStyleBlock)(UIView *subView);


@interface UIView (HLChainStyle)

#pragma mark  -
@property(copy,nonatomic,readonly)HLFramePropertyBlock hl_width;
@property(copy,nonatomic,readonly)HLFramePropertyBlock hl_height;
@property(copy,nonatomic,readonly)HLFramePropertyBlock hl_x;
@property(copy,nonatomic,readonly)HLFramePropertyBlock hl_y;
@property(copy,nonatomic,readonly)HLFramePropertyBlock hl_centerX;
@property(copy,nonatomic,readonly)HLFramePropertyBlock hl_centerY;
@property (copy,nonatomic,readonly)HLFramePointBlock hl_center;
@property (copy,nonatomic,readonly)HLFramePointBlock hl_origin;
@property (copy,nonatomic,readonly)HLFramePointBlock hl_size;
@property (copy,nonatomic,readonly)HLFrameBlock hl_frame;

#pragma mark  -
- (void)hl_addSubview:(UIView *)view
                style:(HLViewStyleBlock)block;

@end
