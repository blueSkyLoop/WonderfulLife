//
//  UIPickerView+MHPicker.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "UIPickerView+MHPicker.h"

@implementation UIPickerView (MHPicker)
- (void)clearSpearatorLine{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1){
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}

@end
