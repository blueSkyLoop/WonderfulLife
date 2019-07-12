//
//  MHYMCalendarCell.m
//  WonderfulLife
//
//  Created by zz on 12/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHYMCalendarCell.h"
#import "MHMacros.h"

@implementation MHYMCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.titileLabel];
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public Method

- (void)setIsCurrentDate:(BOOL)isCurrentDate {
    _isCurrentDate = isCurrentDate;
    _titileLabel.textColor = MColorToRGB(0X324057);
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    if (isCurrentDate) {
        
        CGFloat shapeW = MScreenW/7.f - 8;
        CGPoint lableC = self.titileLabel.center;
        CGRect rect = CGRectMake(lableC.x - shapeW/2.f, lableC.y - shapeW/2.f, shapeW,shapeW);
        UIRectCorner rectCorner = UIRectCornerAllCorners;
        CGSize cornerRadii = CGSizeMake(CGRectGetWidth(rect)/2, CGRectGetWidth(rect)/2);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:cornerRadii];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = MColorToRGB(0X20A0FF).CGColor;
        [self.contentView.layer insertSublayer:shapeLayer below:self.titileLabel.layer];
        
        _titileLabel.textColor = [UIColor whiteColor];
        
        self.shapeLayer = shapeLayer;
    }
}



#pragma mark - Getter


- (UILabel *)titileLabel {
    if (!_titileLabel) {
        _titileLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titileLabel.textAlignment = NSTextAlignmentCenter;
        _titileLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        _titileLabel.backgroundColor = [UIColor clearColor];
        _titileLabel.textColor = MColorToRGB(0X324057);
    }
    return _titileLabel;
}

@end
