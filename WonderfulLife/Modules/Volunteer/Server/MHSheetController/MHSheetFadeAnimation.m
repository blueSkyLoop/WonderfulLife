//
//  MHSheetFadeAnimation.m
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import "MHSheetFadeAnimation.h"
#import "MHSheetController.h"

@implementation MHSheetFadeAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        return 0.45;
    }
    return 0.25;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    MHSheetController *alertController = (MHSheetController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    alertController.backgroundView.alpha = 0.0;
    
    alertController.sheetView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(alertController.sheetView.frame));

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alertController.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        alertController.backgroundView.alpha = 1.0;
        alertController.sheetView.transform = CGAffineTransformMakeTranslation(0, -10.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            alertController.sheetView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
    
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    MHSheetController *alertController = (MHSheetController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.25 animations:^{
        alertController.backgroundView.alpha = 0.0;
        alertController.sheetView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(alertController.sheetView.frame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
