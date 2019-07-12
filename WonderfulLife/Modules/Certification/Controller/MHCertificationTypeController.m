//
//  MHCertificationTypeController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCertificationTypeController.h"
#import "MHCertificationMessageTypeController.h"
#import "MHCePaymentBillController.h"
#import "MHOwnerCheckController.h"
#import "MHStructRoomModel.h"

#import "MHAlertView.h"

#import "MHMacros.h"

@interface MHCertificationTypeController ()
@property (weak, nonatomic) IBOutlet UIView *boxView;

@end

@implementation MHCertificationTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupControls];
}

- (void)setupControls {
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = MCornerRadius;
    self.boxView.layer.borderColor = MColorSeparator.CGColor;
    self.boxView.layer.borderWidth = 1;
}

#pragma mark - Event
- (IBAction)certificateTypeAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{
            if(self.room.phone_number.length == 0){
                NSString *str = [NSString stringWithFormat:@"%@,未登记业主手机号，请选择其他认证方式", self.dongdanfan];
               [[MHAlertView sharedInstance] showMessageAlertViewTitle:nil message:str sureHandler:^{
               }];
            } else {
                MHCertificationMessageTypeController *vc = [[MHCertificationMessageTypeController alloc] init];
                vc.room = self.room;
                vc.plotDescripe = self.plotDescripe;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:{
            if (self.room.has_id_card) {
                MHOwnerCheckController *vc = [[MHOwnerCheckController alloc] init];
                vc.room = self.room;
                vc.plotDescripe = self.plotDescripe;
                [self.navigationController pushViewController:vc animated:YES];
            } else{
                NSString *str = [NSString stringWithFormat:@"%@,未登记业主个人信息，请选择其他认证方式", self.dongdanfan];
                [[MHAlertView sharedInstance] showMessageAlertViewTitle:nil message:str sureHandler:^{
                }];
            }
        }
            break;
        case 2:{
            MHCePaymentBillController *vc = [[MHCePaymentBillController alloc] init];
            vc.room = self.room;
            vc.plotDescripe = self.plotDescripe;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

@end
