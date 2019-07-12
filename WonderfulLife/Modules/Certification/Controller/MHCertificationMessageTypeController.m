//
//  MHCertificationMessageTypeController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCertificationMessageTypeController.h"
#import "MHCertificationSuccessController.h"
#import "MHMineController.h"

#import "UIView+GradientColor.h"
#import "NSString+ValidatePhoneNumber.h"
#import "UIImage+Color.h"

#import "MHUserInfoManager.h"
#import "MHValidateCodeButton.h"
#import "MHThemeButton.h"
#import "MHHUDManager.h"
#import "MHMacros.h"

#import "MHStructRoomModel.h"

#import "MHCertificationRequestHandler.h"

@interface MHCertificationMessageTypeController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLab;
@property (weak, nonatomic) IBOutlet MHThemeButton *commitBtn;
@property (weak, nonatomic) IBOutlet MHValidateCodeButton *validateBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@end

@implementation MHCertificationMessageTypeController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupControls];
 
}


- (void)setupControls {
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = 6;
    self.boxView.layer.borderColor = MColorSeparator.CGColor;
    self.boxView.layer.borderWidth = 1;
    
    self.roomNameLab.text = self.room.room_info;
    
    if (self.room.phone_number) {
        self.validateBtn.enabled = YES;
        self.phoneTf.text = self.room.phone_number;
        self.phoneTf.text = [self.phoneTf.text stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    self.commitBtn.enabled = NO;
    
    [self.phoneTf setValue:MColorFootnote forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTf setValue:MColorFootnote forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.validateBtn setClickBlock:^BOOL{
        if (![NSString mh_validatePhoneNumber:self.room.phone_number]) {
            [MHHUDManager showText:@"手机号码格式有误"];
            return NO;
        }
        //request
        [self requestGetVaildateCode];
        return YES;
    }];
    
}

#pragma mark - Request
/**
 获取验证码
 */
- (void)requestGetVaildateCode {
   [MHCertificationRequestHandler getVaildateCodeWithPhone:self.room.phone_number success:^{
      [MHHUDManager showText:@"验证码已发送到您的手机"];
   } failure:^(NSString *errmsg) {
       [MHHUDManager showErrorText:errmsg];
   }];
}

/** 
 验证
 */
- (void)requestCheck {
    [MHHUDManager show];
    [MHCertificationRequestHandler postCheckVaildateCodeWithPhone:self.room.phone_number structId:self.room.struct_id code:self.codeTf.text success:^(long is_success) {
        [MHHUDManager dismiss];
        if (is_success == 0) {
            [MHHUDManager showErrorText:@"验证失败"];
            return;
        }
        
        
        UIViewController *mineVC = self.navigationController.childViewControllers[0];
        if ([mineVC isKindOfClass:[MHMineController class]]) {
            MHMineController * mine = (MHMineController *)mineVC;
            !mine.refreshCetifiStateBlock ? : mine.refreshCetifiStateBlock(2);
        }
        
        MHCertificationSuccessController *vc = [[MHCertificationSuccessController alloc] initWithType:MHCertificationSuccessTypeNone];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}
#pragma mark - UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTf) {
        if (textField.text.length - range.length + string.length == 11) {
            if (self.codeTf.text.length == 4) {
                self.commitBtn.enabled = YES;
            }
            self.validateBtn.enabled = YES;
            return YES;
        } else if (textField.text.length - range.length + string.length > 11) {
            self.validateBtn.enabled = YES;
            return NO;
        } else {
            self.commitBtn.enabled = NO;
            self.validateBtn.enabled = NO;
            return YES;
        }
    } else {
        if (textField.text.length - range.length + string.length == 4) {
            if (self.phoneTf.text.length == 11) {
                self.commitBtn.enabled = YES;
            }
            return YES;
        }else if (textField.text.length - range.length + string.length > 4) {
            return NO;
        } else {
            self.commitBtn.enabled = NO;
            return YES;
        }
    }
    
   
}

#pragma mark - Event
- (IBAction)commitAction:(UIButton *)sender {
    //request
    [self requestCheck];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
