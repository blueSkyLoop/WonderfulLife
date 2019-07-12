//
//  MHStoreOrderPaySuccessViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrderPaySuccessViewController.h"

#import "MHStoreGoodsPaySuccessView.h"

#import "MHVoSerIntegralDetailsController.h"

@interface MHStoreOrderPaySuccessViewController ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)MHStoreGoodsPaySuccessView *successView;

@end

@implementation MHStoreOrderPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分支付";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
    
    [self configUI];
    
}

- (void)configUI{
    self.successView.scoreLabel.text = [NSString stringWithFormat:@"%@%@",self.payInfor[@"totalScore"],@"积分"];
    self.successView.merchantLabel.text = self.payInfor[@"merchant_name"];
}

- (void)mh_setUpUI{
    
    [self.scrollView addSubview:self.successView];
    [self.view addSubview:self.scrollView];
    
    [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollView);
        make.bottom.lessThanOrEqualTo(self.scrollView.mas_bottom);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)mh_bindViewModel{
    @weakify(self);
    [[[self.successView.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        //跳转到积分明细
        MHVoSerIntegralDetailsController *integralDetailVC = [MHVoSerIntegralDetailsController new];
        integralDetailVC.fromIndex = 1;
        [self.navigationController pushViewController:integralDetailVC animated:YES];
    }];
}
#pragma mark - lazyload
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
- (MHStoreGoodsPaySuccessView *)successView{
    if(!_successView){
        _successView = [MHStoreGoodsPaySuccessView loadViewFromXib];
        
    }
    return _successView;
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
