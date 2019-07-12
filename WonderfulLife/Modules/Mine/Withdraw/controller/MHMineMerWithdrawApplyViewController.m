//
//  MHMineMerWithdrawApplyViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawApplyViewController.h"
#import "MHMineMerWithdrawApplyWithdrawView.h"

#import "MHMineMerWithdrawRecordViewController.h"
#import "MHMineMerWithdrawDetailViewController.h"
#import "UINavigationController+MHDirectPop.h"

@interface MHMineMerWithdrawApplyViewController ()

@property (nonatomic,strong)MHMineMerWithdrawApplyWithdrawView *withdrawApplyView;
@property (nonatomic,strong)UIScrollView *ascrollView;

@property (nonatomic,strong)MHMineMerWithDrawViewModel *viewModel;

@end

@implementation MHMineMerWithdrawApplyViewController

- (id)initWithWithdrawModel:(MHMinMerWithdrawMainModel *)model{
    self = [super init];
    if(self){
        self.viewModel.withDrawModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现申请详情";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
}

- (void)mh_setUpUI{
    
    [self.ascrollView addSubview:self.withdrawApplyView];
    [self.view addSubview:self.ascrollView];
    [_withdrawApplyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.ascrollView);
        make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight));
    }];
    [_ascrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.withdrawApplyView);
    }];
    
}
- (void)mh_bindViewModel{
    @weakify(self);
    [self.viewModel.widthDrawMainCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.withdrawApplyView configDataWithModel:self.viewModel.withDrawModel];
    }];
    [[self.viewModel.widthDrawMainCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        if(self.viewModel.withDrawModel){
            [self.withdrawApplyView configDataWithModel:self.viewModel.withDrawModel];
        }
        [MHHUDManager showWithError:x withView:self.view];
    }];
    
    [self.viewModel.applyWidthDraCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(self.applySuccessSubject){
            [self.applySuccessSubject sendNext:self.viewModel.withdraw_no];
        }
        if(!self.viewModel.withdraw_no) return ;
        [MHHUDManager showText:@"申请提交成功，留意银行转账信息"];
        [self.navigationController saveDirectViewControllerName:@"MHMineMerWithdrawViewController"];
        MHMineMerWithdrawDetailViewController *detailVC = [[MHMineMerWithdrawDetailViewController alloc] initWithWithdraw_no:self.viewModel.withdraw_no];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }];
    [[self.viewModel.applyWidthDraCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [MHHUDManager showWithError:x withView:self.view];
    }];
    //进来再查询一次
    [self.viewModel.widthDrawMainCommand execute:nil];
}
#pragma mark - lazy load
-  (UIScrollView *)ascrollView{
    if(!_ascrollView){
        _ascrollView = [UIScrollView new];
    }
    return _ascrollView;
}
- (MHMineMerWithdrawApplyWithdrawView *)withdrawApplyView{
    if(!_withdrawApplyView){
        _withdrawApplyView = [MHMineMerWithdrawApplyWithdrawView loadViewFromXib];
        //申请提现
        @weakify(self);
        [[[_withdrawApplyView.applyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.viewModel.withDrawModel){
                [self.viewModel.applyWidthDraCommand execute:nil];
            }
        }];
        
    }
    return _withdrawApplyView;
}

- (MHMineMerWithDrawViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHMineMerWithDrawViewModel new];
    }
    return _viewModel;
}
- (RACSubject *)applySuccessSubject{
    if(!_applySuccessSubject){
        _applySuccessSubject = [RACSubject subject];
    }
    return _applySuccessSubject;
}

@end
