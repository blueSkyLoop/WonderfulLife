//
//  MHReportRepairPageViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairPageViewController.h"


@interface MHReportRepairPageViewController ()


@property (nonatomic,assign)BOOL isSlipEnable;

@end

@implementation MHReportRepairPageViewController

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options{
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if(self){
        
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    if(index >= self.pageControllers.count || index < 0) return;
    MHReportRepairListViewController *controller = [self.viewControllers firstObject];
    if(!controller) return;
    NSInteger currentIndex = [self.pageControllers indexOfObject:controller];
    if(currentIndex == index) return;
    UIPageViewControllerNavigationDirection direct;
    if(index > currentIndex){
        direct = UIPageViewControllerNavigationDirectionForward;
    }else{
        direct = UIPageViewControllerNavigationDirectionReverse;
    }
    
    [self setViewControllers:[self.pageControllers subarrayWithRange:NSMakeRange(index, 1)] direction:direct animated:animated completion:nil];
}

#pragma mark - 代理协议
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    int index = (int)[self.pageControllers indexOfObject:(MHReportRepairListViewController *)viewController];
    if (index <= 0) {
        return nil;
    }else{
        
        return self.pageControllers[index - 1];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = (int)[self.pageControllers indexOfObject:(MHReportRepairListViewController *)viewController];
    
    if (index >= self.pageControllers.count - 1) {
        return nil;
    }
    
    return self.pageControllers[index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(finished && self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollCompleWithIndex:currentController:)]){
        UIViewController *controller = [pageViewController.viewControllers firstObject];
        NSInteger index = [self.pageControllers indexOfObject:(MHReportRepairListViewController *)controller];
        [self.scrollDelegate scrollCompleWithIndex:index currentController:controller];
    }
}

#pragma  mark - 懒加载
- (NSMutableArray *)pageControllers{
    if(!_pageControllers){
        _pageControllers = [NSMutableArray array];
    }
    return _pageControllers;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
