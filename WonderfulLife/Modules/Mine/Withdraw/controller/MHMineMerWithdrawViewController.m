//
//  MHMineMerWithdrawViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawViewController.h"
#import "MHConstSDKConfig.h"

#import "MHMineMerWithDrawView.h"

#import "MHMineMerWithDrawViewModel.h"

#import "MHMineMerWithdrawRecordViewController.h"
#import "HLWebViewController.h"
#import "MHMineMerWithdrawApplyViewController.h"

@interface MHMineMerWithdrawViewController ()

@property (nonatomic,strong)MHMineMerWithDrawView *withDrawView;
@property (nonatomic,strong)UIScrollView *ascrollView;

@property (nonatomic,strong)MHMineMerWithDrawViewModel *viewModel;

@end

@implementation MHMineMerWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.title = @"提现";
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
    if(self.viewModel.refreshFlag){
        [self.viewModel.widthDrawMainCommand execute:nil];
    }
}

- (void)mh_setUpUI{
    
    [self.ascrollView addSubview:self.withDrawView];
    [self.view addSubview:self.ascrollView];
    [_withDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.ascrollView);
        make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight));
    }];
    [_ascrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.withDrawView);
    }];
    
    UIButton *withDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [withDrawBtn setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
    [withDrawBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [withDrawBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:withDrawBtn];
    @weakify(self);
    [[withDrawBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        MHMineMerWithdrawRecordViewController *withdrawRecordVC = [MHMineMerWithdrawRecordViewController new];
        [self.navigationController pushViewController:withdrawRecordVC animated:YES];
    }];
    
    
}
- (void)mh_bindViewModel{
    @weakify(self);
    [self.viewModel.widthDrawMainCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.withDrawView configDataWithModel:self.viewModel.withDrawModel];
    }];
    [[self.viewModel.widthDrawMainCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [MHHUDManager showWithError:x withView:self.view];
    }];
    
    [self.viewModel.widthDrawMainCommand execute:nil];
}
#pragma mark - lazy load
-  (UIScrollView *)ascrollView{
    if(!_ascrollView){
        _ascrollView = [UIScrollView new];
    }
    return _ascrollView;
}
- (MHMineMerWithDrawView *)withDrawView{
    if(!_withDrawView){
        _withDrawView = [MHMineMerWithDrawView loadViewFromXib];
        @weakify(self);
        //提现规则
        [[[_withDrawView.ruleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            HLWebViewController *vc = [[HLWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,@"h5/withdraw-rule"]];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        //提示语句，不能提现
        [[[_withDrawView.withDrawBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSString *alert_msg = self.viewModel.withDrawModel.alert_msg;
            if(alert_msg && ![alert_msg isEqual:[NSNull null]] && alert_msg.length){
                [MHHUDManager showErrorText:alert_msg];
            }
        }];
        //申请提现
        [[[_withDrawView.applyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.viewModel.withDrawModel){
                NSString *alert_msg = self.viewModel.withDrawModel.alert_msg;
                if(alert_msg && ![alert_msg isEqual:[NSNull null]] && alert_msg.length){
                    [MHHUDManager showErrorText:alert_msg];
                    return ;
                }
                MHMineMerWithdrawApplyViewController *applyVC = [[MHMineMerWithdrawApplyViewController alloc] initWithWithdrawModel:self.viewModel.withDrawModel];
                [applyVC.applySuccessSubject subscribeNext:^(id  _Nullable x) {
                    self.viewModel.refreshFlag = YES;
                }];
                [self.navigationController pushViewController:applyVC animated:YES];
            }
        }];
        
    }
    return _withDrawView;
}

- (MHMineMerWithDrawViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHMineMerWithDrawViewModel new];
    }
    return _viewModel;
}

@end
