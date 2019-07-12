//
//  MHCollectionReusableView.m
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCollectionReusableView.h"
#import "MHMacros.h"

@interface MHCollectionReusableView ()

@end

@implementation MHCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = arrayOfViews[0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //MColorYellow
    self.dateLabel.textColor = MColorToRGB(0X324057);
}

@end
