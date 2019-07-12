//
//  MHReportRepairMainViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairMainViewController.h"
#import "MHReportRepairTypeViewController.h"

#import "MHMacros.h"
#import "Masonry.h"
#import "MHConst.h"

#import "MHReportRepairHeadView.h"
#import "MHReportRepairListFooterView.h"

#import "MHReportRepairPageViewController.h"
#import "LPasswordSetViewController.h"
#import "MHNavigationControllerManager.h"

@interface MHReportRepairMainViewController ()<ReportRepairMainPageDelegate>

@property (nonatomic,strong)MHReportRepairPageViewController *pageViewController;

@property (nonatomic,strong)MHReportRepairHeadView *headView;
@property (nonatomic,strong)MHReportRepairListFooterView *addReportRepairView;

@end

@implementation MHReportRepairMainViewController
- (void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setUpPageViewController];
    
    [self notificationHandler];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

//通知处理
- (void)notificationHandler{
    //发布成功
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReportRepairPublishSuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.headView makeSelectIndex:0];
            //刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
                
           
        });
        
    }];
}
- (void)setUpPageViewController{
    //0进行中，1已结束，2待评价
    NSArray *typeArr = @[@(ReportRepair_progress),@(ReportRepair_completed),@(ReportRepair_evaluate)];
    for(int i=0;i<typeArr.count;i++){
        MHReportRepairListViewController *vc = [[MHReportRepairListViewController alloc] init];
        vc.type = [typeArr[i] integerValue];
        [self.pageViewController.pageControllers addObject:vc];
    }
    
    [self.view addSubview:self.headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [_pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    //设置自己的代理为自己
    self.pageViewController.dataSource = self.pageViewController;
    self.pageViewController.delegate = self.pageViewController;
    
    [_pageViewController setViewControllers:[self.pageViewController.pageControllers subarrayWithRange:NSMakeRange(0, 1)] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
    
    [self.view addSubview:self.addReportRepairView];
    [_addReportRepairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pageViewController.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@60);
    }];
    
}

#pragma mark - ReportRepairMainPageDelegate
- (void)scrollCompleWithIndex:(NSInteger)index currentController:(UIViewController *)controller{
    [self.headView makeSelectIndex:index];
}


#pragma  mark - 懒加载
- (MHReportRepairPageViewController *)pageViewController{
    if(!_pageViewController){
        _pageViewController = [[MHReportRepairPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.scrollDelegate = self;

    }
    return _pageViewController;
}

- (MHReportRepairHeadView *)headView{
    if(!_headView){
        @weakify(self);
        _headView = [MHReportRepairHeadView loadViewFromXib];
        _headView.headItemClikBlock = ^(NSInteger index){
            @strongify(self);
            [self.pageViewController scrollToIndex:index animated:YES];
        };
    }
    return _headView;
}

- (MHReportRepairListFooterView *)addReportRepairView{
    if(!_addReportRepairView){
        _addReportRepairView = [[MHReportRepairListFooterView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 60)];
        @weakify(self);
        [[[_addReportRepairView.button rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            MHReportRepairTypeViewController *controller = [MHReportRepairTypeViewController new];
            controller.listEnter = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }
    return _addReportRepairView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
