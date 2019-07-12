//
//  UIView+chain.m
//  testdemo
//
//  Created by hanl on 2016/12/14.
//  Copyright © 2016年 hanl. All rights reserved.
//

#import "UIView+HLChainStyle.h"

@implementation UIView (HLChainStyle)

- (HLFramePropertyBlock)hl_width {
    return ^(CGFloat width) {
        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
        return self;
    };
}
- (HLFramePropertyBlock)hl_height {
    return ^(CGFloat height) {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        return self;
    };
}

- (HLFramePropertyBlock)hl_x {
    return ^(CGFloat x) {
        CGRect frame = self.frame;
        frame.origin.x = x;
        self.frame = frame;
        return self;
    };
}

- (HLFramePropertyBlock)hl_y {
    return ^(CGFloat y) {
        CGRect frame = self.frame;
        frame.origin.y = y;
        self.frame = frame;
        return self;
    };
}

- (HLFramePropertyBlock)hl_centerX {
    return ^(CGFloat centerX) {
        CGRect frame = self.frame;
        frame.origin.x = centerX-CGRectGetWidth(frame);
        self.frame = frame;
        return self;
    };
}

- (HLFramePropertyBlock)hl_centerY {
    return ^(CGFloat centerY) {
        CGRect frame = self.frame;
        frame.origin.y = centerY-CGRectGetHeight(frame);
        self.frame = frame;
        return self;
    };
}

- (HLFramePointBlock)hl_center {
    return ^(CGFloat centerX,CGFloat centerY) {
        CGRect frame = self.frame;
        frame.origin.x = centerX-CGRectGetWidth(frame);
        frame.origin.y = centerY-CGRectGetHeight(frame);
        self.frame = frame;
        return self;
    };
}

- (HLFramePointBlock)hl_origin {
    return ^(CGFloat x,CGFloat y) {
        CGRect frame = self.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        self.frame = frame;
        return self;
    };
}

- (HLFramePointBlock)hl_size {
    return ^(CGFloat width,CGFloat height) {
        CGRect frame = self.frame;
        frame.size.width = width;
        frame.size.height = height;
        self.frame = frame;
        return self;
    };
}

- (HLFrameBlock)hl_frame {
    return ^(CGFloat x,CGFloat y,CGFloat width,CGFloat height) {
        CGRect frame = self.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        frame.size.width = width;
        frame.size.height = height;
        self.frame = frame;
        return self;
    };
}


- (void)hl_addSubview:(UIView *)view
                style:(HLViewStyleBlock)block {
    block(view);
    [self addSubview:view];
}

@end
