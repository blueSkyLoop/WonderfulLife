//
//  MHCalendarCell.m
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarCell.h"
#import "MHMacros.h"

@implementation MHCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.titileLabel];
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    CAShapeLayer *shapeLayer;
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:_titileLabel.layer];
    self.shapeLayer = shapeLayer;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);

    _shapeLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                   (self.bounds.size.height - diameter)/2,
                                   diameter,
                                   diameter);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5].CGPath;
    if (!CGPathEqualToPath(_shapeLayer.path,path)) {
        _shapeLayer.path = path;
    }
}

#pragma mark - Public Method

- (void)prepareForReuse {
    [super prepareForReuse];
    if (self.window) {
        [CATransaction setDisableActions:YES];
    }
    self.shapeLayer.opacity = 0;
    [self.contentView.layer removeAnimationForKey:@"opacity"];
}

- (void)performSelecting {
    _shapeLayer.opacity = 1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = 0.15/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = 0.15/4*3;
    zoomIn.duration = 0.15/4;
    group.duration = 0.15;
    group.animations = @[zoomOut, zoomIn];
    [_shapeLayer addAnimation:group forKey:@"bounce"];
    [self configureAppearance];
}

- (void)configureAppearance {

    _shapeLayer.opacity = 1;

    CGColorRef cellFillColor = MColorToRGB(0X20A0FF).CGColor;
    if (!CGColorEqualToColor(_shapeLayer.fillColor, cellFillColor)) {
        _shapeLayer.fillColor = cellFillColor;
    }
    
    if (!CGColorEqualToColor(_shapeLayer.strokeColor, cellFillColor)) {
        _shapeLayer.strokeColor = cellFillColor;
    }
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5].CGPath;
    if (!CGPathEqualToPath(_shapeLayer.path, path)) {
        _shapeLayer.path = path;
    }

}



#pragma mark - Getter


- (UILabel *)titileLabel {
    if (_titileLabel == nil) {
        _titileLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titileLabel.textAlignment = NSTextAlignmentCenter;
        _titileLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
        _titileLabel.backgroundColor = [UIColor clearColor];
    }
    return _titileLabel;
}

@end
