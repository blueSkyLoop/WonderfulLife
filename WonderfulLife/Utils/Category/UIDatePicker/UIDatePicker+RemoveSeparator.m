//
//  UIDatePicker+RemoveSeparator.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIDatePicker+RemoveSeparator.h"

@implementation UIDatePicker (RemoveSeparator)
- (void)mh_clearSpearatorLine{
    for (UIView *subView1 in self.subviews)
    {
        if ([subView1 isKindOfClass:[UIPickerView class]])//取出UIPickerView
        {
            for(UIView *subView2 in subView1.subviews)
            {
                if (subView2.frame.size.height < 1)//取出分割线view
                {
                    subView2.hidden = YES;//隐藏分割线
                }
            }
        }
    }
}
@end
