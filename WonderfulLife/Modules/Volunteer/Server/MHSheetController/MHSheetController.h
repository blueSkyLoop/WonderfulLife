//
//  MHSheetController.h
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHSheetController : UIViewController
@property (nonatomic, strong, readonly) UIView *sheetView;

// dismiss controller completed block
@property (nonatomic, copy) void (^dismissComplete)(void);
@property (nonatomic, strong) UIView *backgroundView; // you set coustom view to it

+ (instancetype)alertControllerWithSheetView:(UIView *)sheetView;

- (void)dismissViewControllerAnimated: (BOOL)animated;

@end

// Transition Animate
@interface MHSheetController (TransitionAnimate)<UIViewControllerTransitioningDelegate>

@end
