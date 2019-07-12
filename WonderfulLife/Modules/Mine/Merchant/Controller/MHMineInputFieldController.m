//
//  MHMineScanCodeColController.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineInputFieldController.h"
#import "MHQRCodeController.h"
#import "MHMineMerColResultController.h"

#import "MHMineMerchantPayModel.h"
#import "MHMineMerchantHandler.h"

#import "MHMacros.h"
#import "MHThemeButton.h"
#import "MHHUDManager.h"
#import "ReactiveObjC.h"
#import "MHWeakStrongDefine.h"
#import "NSObject+isNull.h"
#import "UIViewController+HLNavigation.h"
#import "UIViewController+PresentPayIncomResultController.h"
@interface MHMineInputFieldController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UILabel *rmbLab;

@property (weak, nonatomic) IBOutlet MHThemeButton *doneBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldConst_left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabConst_top;


@end

@implementation MHMineInputFieldController

- (instancetype)initWithInputType:(MHMineInputFieldType)type parma:(NSMutableDictionary *)parma{
    if ([super init]) {
        self.type = type ;
        self.parma = parma ;
    }return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setConfig];
    
    [self setUI];
    
    [self textFidld_Rac];
    
}


- (void)setConfig {
    if (self.type == MHMineInputFieldType_InputQR) {
        self.titleLab.text = @"手动输码";
        [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        self.TF.placeholder = @"请输入付款码(18位)";
        self.TF.keyboardType = UIKeyboardTypeNumberPad ;
        [self.textFieldConst_left setConstant:16.0];
        self.rmbLab.hidden = YES;
        
    }else if (self.type == MHMineInputFieldType_ScanQRCol) {
        self.titleLab.text = @"扫码收款";
        [self.doneBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.TF.placeholder = @"请输入收款金额";
        self.TF.keyboardType = UIKeyboardTypeDecimalPad ;
    }
}


- (void)textFidld_Rac {
    [self.TF.rac_textSignal subscribeNext:^(NSString *x) {
         NSInteger  maxIntegerLength;//最大整数位
        if (self.type == MHMineInputFieldType_ScanQRCol) {
            [self.doneBtn setEnabled:![NSObject isNull:x]];
            maxIntegerLength = 8;//最大整数位
            static NSInteger const maxFloatLength=2;//最大精确到小数位
            
            if (x.length) {
                //第一个字符处理
                //第一个字符为0,且长度>1时
                if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                    if (x.length>1) {
                        if ([[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                            //如果第二个字符还是0,即"00",则无效,改为"0"
                            self.TF.text=@"0";
                        }else if (![[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]){
                            //如果第二个字符不是".",比如"03",清除首位的"0"
                            self.TF.text=[x substringFromIndex:1];
                        }
                    }
                }
                //第一个字符为"."时,改为"0."
                else if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
                    self.TF.text=@"0.";
                }
                
                //2个以上字符的处理
                NSRange pointRange = [x rangeOfString:@"."];
                NSRange pointsRange = [x rangeOfString:@".."];
                if (pointsRange.length>0) {
                    //含有2个小数点
                    self.TF.text=[x substringToIndex:x.length-1];
                }
                else if (pointRange.length>0){
                    //含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
                    if ((pointRange.location!=x.length-1) && ([[x substringFromIndex:x.length-1]isEqualToString:@"."])) {
                        self.TF.text=[x substringToIndex:x.length-1];
                    }
                    if (pointRange.location+maxFloatLength<x.length) {
                        //输入位数超出精确度限制,进行截取
                        self.TF.text=[x substringToIndex:pointRange.location+maxFloatLength+1];
                    }
                }
                else{
                    if (x.length>maxIntegerLength) {
                        self.TF.text=[x substringToIndex:maxIntegerLength];
                    }
                }
                
            }
        }else {  // 手动输码
            
            maxIntegerLength = 18;
            if (x.length>maxIntegerLength) {
                self.TF.text = [x substringToIndex:maxIntegerLength];
            }
            [self.doneBtn setEnabled:self.TF.text.length == 18 ? YES : NO];
        }
    }];
}

#pragma mark - SetUI

- (void)setUI {
    
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = 6;
    self.boxView.layer.borderColor = MColorSeparator.CGColor;
    self.boxView.layer.borderWidth = 1;
    
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 5;
    [self.doneBtn addTarget:self
                     action:@selector(doneAction)
           forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Event

- (void)doneAction {
    if (self.type == MHMineInputFieldType_ScanQRCol) {   // 跳转到 去扫二维码
        if ([self.TF.text floatValue] == 0) {
            [MHHUDManager showText:@"收款金额不能为0"];
            return;
        }else {
            [self.parma setValue:self.TF.text forKey:@"amount"];
            MHQRCodeController *vc =[[MHQRCodeController alloc] initWithParma:self.parma CodeType:MHQRCodeType_Collection];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (self.type == MHMineInputFieldType_InputQR) { // 手动输码---- 直接请求提交数据
        [self.parma setValue:self.TF.text forKey:@"bar_code"];
        [MHHUDManager show];
        [MHMineMerchantHandler mineScanCollectionOfMoneyWithParma:self.parma success:^(MHMineMerchantPayModel *resultModel, BOOL isSuccess) {
            [MHHUDManager dismiss];
            [self mh_pushResultControllerWithModel:resultModel type:MerColResultType_CompIncome];
        } Failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            //[MHHUDManager showErrorText:errmsg];
            [self mh_pushResultControllerWithModel:nil type:MerColResultType_FailureIncome];
        }];
    }
}


@end
