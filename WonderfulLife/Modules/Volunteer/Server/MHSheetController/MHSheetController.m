//
//  MHSheetController.m
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import "MHSheetController.h"
#import "UIView+MHAutoLayout.h"
#import "MHSheetFadeAnimation.h"
#import "MHMacros.h"

@interface MHSheetController ()
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, weak) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) NSLayoutConstraint *alertViewCenterYConstraint;
@property (nonatomic, assign) CGFloat alertViewCenterYOffset;

@property (nonatomic, strong) UIColor *backgroundColor; // set backgroundColor
@property (nonatomic, assign) BOOL backgoundTapDismissEnable;  // default NO
@property (nonatomic, assign) CGFloat actionSheetStyleEdging; // default 0

@end

@implementation MHSheetController

- (instancetype)init{
    if (self = [super init]) {
        [self configureController];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureController];
    }
    return self;
}


- (instancetype)initWithSheetView:(UIView *)sheetView{
    if (self = [self initWithNibName:nil bundle:nil]) {
        _sheetView = sheetView;
    }
    return self;
}

+ (instancetype)alertControllerWithSheetView:(UIView *)sheetView{
    return [[self alloc]initWithSheetView:sheetView];
}

#pragma mark - configure
- (void)configureController{
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    _backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _backgoundTapDismissEnable = NO;
    _actionSheetStyleEdging = 0;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self addBackgroundView];
    [self addSingleTapGesture];
    [self configureSheetView];

    [self.view layoutIfNeeded];

}


- (void)addBackgroundView {
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = _backgroundColor;
        _backgroundView = backgroundView;
    }
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_backgroundView atIndex:0];
    [self.view addConstraintToView:_backgroundView edgeInset:UIEdgeInsetsZero];

}

- (void)setBackgroundView:(UIView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = backgroundView;
    } else if (_backgroundView != backgroundView) {
        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view insertSubview:backgroundView aboveSubview:_backgroundView];
        [self.view addConstraintToView:backgroundView edgeInset:UIEdgeInsetsZero];
        backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = backgroundView;
            [self addSingleTapGesture];
        }];
    }
}

- (void)addSingleTapGesture{
    self.view.userInteractionEnabled = YES;
    _backgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}



- (void)configureSheetView {
    if (_sheetView == nil) {
        NSLog(@"%s: alertView is nil",__func__);
        return;
    }
    _sheetView.userInteractionEnabled = YES;
    [self.view addSubview:_sheetView];
}

#pragma mark 手指点击事件

- (void)singleTap:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)animated{
    [self dismissViewControllerAnimated:YES completion:self.dismissComplete];
}

@end

@implementation MHSheetController (TransitionAnimate)

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [MHSheetFadeAnimation alertAnimationIsPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [MHSheetFadeAnimation alertAnimationIsPresenting:NO];
}

@end

