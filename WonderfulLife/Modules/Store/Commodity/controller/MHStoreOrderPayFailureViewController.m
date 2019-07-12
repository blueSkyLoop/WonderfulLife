//
//  MHStoreOrderPayFailureViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrderPayFailureViewController.h"
#import "UINavigationController+MHDirectPop.h"

#import "LIntegralsPayFailureView.h"

@interface MHStoreOrderPayFailureViewController ()

@property (nonatomic,strong)LIntegralsPayFailureView *payFailureView;

@end

@implementation MHStoreOrderPayFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
}

- (void)mh_setUpUI{
    [self.view addSubview:self.payFailureView];
    [_payFailureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)mh_bindViewModel{
    
    @weakify(self);
    [self.payFailureView.failureSubject subscribeNext:^(NSNumber  *typeNum) {
        @strongify(self);
        [self.payFailureView removeFromSuperview];
        self.payFailureView = nil;
        if(typeNum.integerValue == 1){//继续支付
            if(self.payFailureBlock){
                self.payFailureBlock([typeNum integerValue]);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{//完成，回到调起界面
            UIViewController *controller = [self.navigationController frontControllerWithControllerName:@"MHQRCodeController"];
            if(controller){
                [self.navigationController popToViewController:controller animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        
        
    }];
    
}

#pragma mark - lazyload
- (LIntegralsPayFailureView *)payFailureView{
    if(!_payFailureView){
        _payFailureView = [LIntegralsPayFailureView loadViewFromXib];
    }
    return _payFailureView;
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
