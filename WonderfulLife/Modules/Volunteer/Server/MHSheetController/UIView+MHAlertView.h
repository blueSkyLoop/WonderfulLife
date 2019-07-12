//
//  UIView+MHAlertView.h
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSheetController.h"

@interface UIView (MHAlertView)
+ (instancetype)createViewFromNib;

+ (instancetype)createViewFromNibName:(NSString *)nibName;

- (UIViewController*)viewController;

#pragma mark - show in controller



#pragma mark - hide

// this will judge and call right method
- (void)hideView;

- (void)hideInController;

@end
