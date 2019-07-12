//
//  UITableView+MHAutoHeaderAndFooterView.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UITableView+MHAutoHeaderAndFooterView.h"
#import <objc/runtime.h>

@implementation UITableView (MHAutoHeaderAndFooterView)

#pragma mark - header
static const char MHTableHeaderKey;
- (void)setMh_tableHeader:(MHTableHeaderFooterHander *)mh_tableHeader
{
    if (self.mh_tableHeader != mh_tableHeader) {
        if(mh_tableHeader){
            [mh_tableHeader mh_initHeaderOrFooterViewWithTableView:self];
        }
        objc_setAssociatedObject(self, &MHTableHeaderKey,mh_tableHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MHTableHeaderFooterHander *)mh_tableHeader
{
    return objc_getAssociatedObject(self, &MHTableHeaderKey);
}

#pragma mark - footer
static const char MHTableFooterKey;
- (void)setMh_tableFooter:(MHTableHeaderFooterHander *)mh_tableFooter
{
    if (self.mh_tableFooter != mh_tableFooter) {
        if(mh_tableFooter){
            [mh_tableFooter mh_initHeaderOrFooterViewWithTableView:self];
        }
        objc_setAssociatedObject(self, &MHTableFooterKey,mh_tableFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MHTableHeaderFooterHander *)mh_tableFooter
{
    return objc_getAssociatedObject(self, &MHTableFooterKey);
}

@end
