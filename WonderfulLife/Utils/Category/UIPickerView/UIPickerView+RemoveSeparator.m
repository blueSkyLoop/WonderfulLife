//
//  UIPickerView+RemoveSeparator.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIPickerView+RemoveSeparator.h"

@implementation UIPickerView (RemoveSeparator)

- (void)mh_clearSpearatorLine{
    for (UIView *subView1 in self.subviews)
    {
        if (subView1.frame.size.height < 1)//取出分割线view
        {
            [subView1 setHidden:YES];
        }
    }
}

@end
