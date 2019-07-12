//
//  MHStoreFeedbackViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreFeedbackViewController.h"
#import "MHPlaceholderTextView.h"
#import "MHThemeButton.h"

#import "MHStoreFeedbackViewModel.h"

#import "UIViewController+PresentLoginController.h"

@interface MHStoreFeedbackViewController ()
@property (weak, nonatomic) IBOutlet MHPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet MHThemeButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLayoutHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,assign)NSInteger limitNum;

@property (nonatomic,strong)MHStoreFeedbackViewModel *viewModel;

@end

@implementation MHStoreFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"拒绝退款";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor blackColor]}];
    //默认
    self.limitNum = 150;
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.textView.text.length,self.limitNum];
    self.bgLayoutHeight.constant = MScreenH - MTopHight;

}

- (void)setType:(NSInteger)type{
    if(_type != type){
        _type = type;
        
        [self configUI];
        
    }
}

- (void)setMerchant_id:(NSInteger)merchant_id{
    if(_merchant_id != merchant_id){
        _merchant_id = merchant_id;
        self.viewModel.merchant_id = _merchant_id;
    }
}
- (void)setRefund_id:(NSInteger)refund_id{
    if(_refund_id != refund_id){
        _refund_id = refund_id;
        self.viewModel.refund_id = _refund_id;
    }
}

- (void)configUI{
    if(_type == 0){
        self.title = @"拒绝退款";
        self.textView.placeholder = @"请输入拒绝理由（必填）";
        self.lineView.hidden = NO;
    }else if(_type == 1){
        self.title = @"反馈意见";
        self.textView.placeholder = @"请输入您的意见";
        self.lineView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNaviBottomLineDefaultColor];
    
    [self configUI];
}


- (void)mh_setUpUI{
    self.textView.font = [UIFont systemFontOfSize:MScale * 17];
    
}


- (void)mh_bindViewModel{
    @weakify(self);
    [[self.textView rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        UITextRange *markedRange = [self.textView markedTextRange];
        if(markedRange) return ;
        NSString *atext = text;
        if(atext.length <= self.limitNum){
//            self.textView.text = atext;
        }else{
           atext = [atext substringWithRange:NSMakeRange(0, self.limitNum)];
            self.textView.text = atext;
        }
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld",atext.length,self.limitNum];

    }];
    
    RAC(self.submitBtn,enabled) = [[RACObserve(self.textView, text)  merge:self.textView.rac_textSignal ] map:^id(NSString *value) {
        @strongify(self);
        return @(value && value.length && value.length <= self.limitNum);
    }];
    
   
    
    RAC(self.viewModel,reason) = self.textView.rac_textSignal;
    
    //拒绝退款
    [self.viewModel.refundCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kStoreRefundSuccessNotification" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"com.MH.kMerchantRefundSuccessNotification" object:nil];

    }];
    [[self.viewModel.refundCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
    //反馈
    [self.viewModel.feedbackCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[self.viewModel.feedbackCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
    
    
}
- (IBAction)submitAction:(MHThemeButton *)sender {
    
    [self.view endEditing:YES];
    
    if(self.viewModel.reason && self.viewModel.reason.length){
        NSString *atext = [self.viewModel.reason stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(atext.length == 0){
            [MHHUDManager showErrorText:@"请输入意见内容"];
            return;
        }
    }

    if(self.type == 0){//拒绝退款
        
        [self.viewModel.refundCommand execute:nil];
        
    }else if(self.type == 1){//反馈
        
        [self.viewModel.feedbackCommand execute:nil];
    }
    
}

#pragma mark - lazyload
- (MHStoreFeedbackViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreFeedbackViewModel new];
    }
    return _viewModel;
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
