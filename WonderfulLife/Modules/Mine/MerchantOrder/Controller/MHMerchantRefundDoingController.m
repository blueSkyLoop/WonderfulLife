//
//  MHMerchantRefundDoingController.m
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantRefundDoingController.h"
#import "MHMerchantOrderListController.h"
#import "UIViewController+HLNavigation.h"

#import "Masonry.h"
#import "MHMacros.h"

#import "UIView+NIM.h"

typedef NS_ENUM(NSUInteger, ViewMoveDirection) {
    kViewMoveDirectionNone,
    kViewMoveDirectionRight,
    kViewMoveDirectionLeft,
};

static CGFloat const gestureMinimumTranslation = 20.0;

@interface MHMerchantRefundDoingController ()<MHMerchantOrderListProtocal>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *menuButtons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IndexCenterX;

@property (weak, nonatomic) IBOutlet UIView *indexLine;
@property (weak, nonatomic) IBOutlet UIView *segmentLine;

@property (nonatomic,assign) ViewMoveDirection direction;
@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic,strong) UIViewController *currentController;

@property (nonatomic,strong) NSMutableArray<MHMerchantOrderListController *> *viewControllerArray;
@end

@implementation MHMerchantRefundDoingController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadListViews];
//    [self selectedMenuSomeItem:self.menuButtons[0]];

//    UIPanGestureRecognizer *edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pageLayoutSwitch:)];
//    [self.scrollView addGestureRecognizer:edgePanGesture];
    
    
    RACSignal *notification = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"com.MH.kMerchantRefundSuccessNotification" object:nil] takeUntil:self.rac_willDeallocSignal];
    @weakify(self)
    [[notification deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self selectedMenuSomeItem:self.menuButtons[1]];
        });
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self hl_setNavigationItemLineColor:[UIColor whiteColor]];
    
}

#pragma mark - Gesture Method
- (void)MHMerchantOrderListPanGestureEvent:(UIPanGestureRecognizer*)gesture {
    
    CGPoint translation = [gesture translationInView:self.view];
    if (gesture.state ==UIGestureRecognizerStateBegan){
        _direction = kViewMoveDirectionNone;
    }else if (gesture.state == UIGestureRecognizerStateChanged && _direction == kViewMoveDirectionNone){
        _direction = [self determineCameraDirectionIfNeeded:translation];
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSUInteger index = [self.menuButtons indexOfObject:self.selectedButton];
        if (_direction == kViewMoveDirectionLeft) {
            if (index != self.menuButtons.count - 1) {
                [self selectedMenuSomeItem:self.menuButtons[index + 1]];
            }
        }else if(_direction == kViewMoveDirectionRight){
            if (index != 0) {
                [self selectedMenuSomeItem:self.menuButtons[index - 1]];
            }
        }
    }
}

- (ViewMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation{
    
    if (_direction != kViewMoveDirectionNone)
        return _direction;
    
    if (fabs(translation.x) > gestureMinimumTranslation){
        BOOL gestureHorizontal = NO;
        if (translation.y ==0.0)
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
        if (gestureHorizontal){
            if (translation.x >0.0)
                return kViewMoveDirectionRight;
            else
                return kViewMoveDirectionLeft;
        }
    }
    return _direction;
}

//加载订单列表
- (void)loadListViews{
    
    CGFloat liney = self.segmentLine.frame.origin.y + 1;
    if(liney < 122){
        liney = 122;
    }
    self.viewControllerArray = @[].mutableCopy;
    for (NSInteger i = 0; i < self.menuButtons.count; i ++) {
        MHMerchantOrderListController *vc = [MHMerchantOrderListController new];
        vc.viewControllerId = i + 1;
        vc.panDelegate = self;
        vc.type = MHMerchantOrderTypeRefundDoing;
        vc.merchant_id = self.merchant_id;
        vc.view.frame = CGRectMake(0, liney, MScreenW, MScreenH - liney - MTopHight);
        [self addChildViewController:vc];
        [self.viewControllerArray addObject:vc];
    }
    MHMerchantOrderListController *vc = [self.viewControllerArray firstObject];
    [self.view addSubview:vc.view];
    
    self.currentController = vc;
    [self.currentController didMoveToParentViewController:self];
    
    self.selectedButton = [self.menuButtons firstObject];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        vc.view.frame = CGRectMake(0, liney, MScreenW, MScreenH - liney - MTopHight);
    });
}

- (IBAction)selectedMenuSomeItem:(UIButton *)sender {
    
    UIViewController *vc = [self.viewControllerArray objectAtIndex:sender.tag - 1020];
    if(vc == self.currentController) return;
    [self transitionFromViewController:self.currentController toViewController:vc duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentController = vc;
        [self scrollToNextPageSender:sender animated:NO];
    }];

}

- (void)scrollToNextPageSender:(UIButton*)sender animated:(BOOL)animated {
    if (sender != _selectedButton){
        _selectedButton.enabled = YES;
        _selectedButton = sender;
    }
    _selectedButton.enabled = NO;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.IndexCenterX.constant = sender.tag == 1020?-74.f:74.f;
        [self.view layoutIfNeeded];
    }];
    
//    [self.scrollView setContentOffset:CGPointMake(MScreenW *(sender.tag - 1020), 0) animated:animated];
//    [self.viewControllerArray[(sender.tag - 1020)] refreshWithTag:sender.tag];
}


@end