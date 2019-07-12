//
//  UIView+MHAlertView.m
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import "UIView+MHAlertView.h"
#import "MHSheetController.h"

@implementation UIView (MHAlertView)

+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - show in controller
- (void)hideInController
{
    if ([self isShowInAlertController]) {
        [(MHSheetController *)self.viewController dismissViewControllerAnimated:YES];
    }else {
        NSLog(@"self.viewController is nil, or isn't alertController");
    }
}

#pragma mark - hide

- (BOOL)isShowInAlertController
{
    UIViewController *viewController = self.viewController;
    if (viewController && [viewController isKindOfClass:[MHSheetController class]]) {
        return YES;
    }
    return NO;
    
}

- (void)hideView
{
    if ([self isShowInAlertController]) {
        [self hideInController];
    }else {
        NSLog(@"self.viewController is nil, or isn't alertController,or self.superview is nil, or isn't showAlertView");
    }
}

@end
