//
//  UIView+EmptyView.m
//  JFCommunityCenter
//
//  Created by liyanzhao on 17/3/2.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "UIView+EmptyView.h"
#import <objc/runtime.h>
#import "UIView+MHFrame.h"
#import "MHMacros.h"

@implementation UIView (EmptyView)

- (void)setEmptyView:(UIView *)emptyView {
    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)emptyView {
    return objc_getAssociatedObject(self, @selector(emptyView));
}

- (void )mh_addEmptyViewImageName:(NSString *)imageName {
    [self mh_addEmptyViewImageName:imageName title:nil];
}

- (void )mh_addEmptyViewTitle:(NSString *)title {
    [self mh_addEmptyViewImageName:nil title:title];
}

- (void )mh_addEmptyViewImageName:(NSString *)imageName title:(NSString *)title {
    UIImage *image = [UIImage imageNamed:imageName];
    [self.emptyView removeFromSuperview];
    if (!self.emptyView) {
        self.emptyView = [UIView new];
    }
  
    CGRect f = CGRectZero;
    f.size = CGSizeMake(self.frame.size.width, image.size.height + 36);
    f.origin = CGPointMake(self.mh_centerX - f.size.width/2.0, self.mh_centerY - f.size.height/2.0);
    self.emptyView.frame =f;
    [self addSubview:self.emptyView];
    
    if (imageName) {
        UIImageView *imv = [UIImageView new];
        imv.image = [UIImage imageNamed:imageName];
        CGRect f = CGRectZero;
        f.size = CGSizeMake(imv.image.size.width, imv.image.size.height);
        imv.frame =f;
        imv.mh_centerX = self.emptyView.mh_centerX;
        [self.emptyView addSubview:imv];
        
        if (title) {
            UILabel *lab = [UILabel new];
            lab.text = title;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor colorWithRed:153/255.0 green:169/255.0 blue:191/255.0 alpha:1];
            lab.frame = CGRectMake(0, CGRectGetMaxY(imv.frame) + 15, self.frame.size.width, 42);
            lab.numberOfLines = 0;
            [self.emptyView addSubview:lab];
        }
    } else {
        if (title) {
            UILabel *lab = [UILabel new];
            lab.text = title;
             lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor colorWithRed:153/255.0 green:169/255.0 blue:191/255.0 alpha:1];
            lab.frame = CGRectMake(0, self.center.y - 21/2.0, self.frame.size.width, 42);
            lab.numberOfLines = 0;
            [self.emptyView addSubview:lab];
        }
    }
}

- (void)mh_setEmptyCenterYOffset:(CGFloat)offset {
    self.emptyView.mh_centerY += (offset * (MScreenH / 667));
}

- (void)mh_removeEmptyView {
    [self.emptyView removeFromSuperview];
}


@end
