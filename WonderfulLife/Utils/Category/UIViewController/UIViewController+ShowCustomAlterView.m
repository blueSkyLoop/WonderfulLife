//
//  UIViewController+ShowCustomAlterView.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+ShowCustomAlterView.h"

#import "HLWebViewController.h"
#import "MHVoDataFillController.h"

#import "MHMacros.h"
#import "MHUserInfoManager.h"
#import "MHWeakStrongDefine.h"
#import "MHConstSDKConfig.h"

#import "MHMineMerTipView.h"
#import "MHMineMerRegisterAlterView.h"
#import "MHAlertView.h"

@implementation UIViewController (ShowCustomAlterView)


- (void)mh_showRegisteredVolunteerView {
    [self showTipViewWithContent:@"您还不是志愿者，不可消费积分 请先注册成为志愿者" Attribut:nil doneBtnTitle:@"立即注册" TipType:MerTipViewType_RegVolunteers];
}

- (void)mh_showRegisteredMerView {
//                [self showTipViewWithContent:@"你未注册称为周边商家，请阅读《周边商家规则》或者联系客服。如已注册，请使用注册手机登录。" Attribut:@"《周边商家规则》" doneBtnTitle:@"联系客服" TipType:MerTipViewType_MerRules];
    
    
[self showRegisAlterViewWithContent:@"你未注册成为周边商家，请阅读《周边商家规则》或者联系客服。如已注册，请使用注册手机登录。" Attribut:@"《周边商家规则》" doneBtnTitle:@"知道了" TipType:MerTipViewType_MerRules];
}


- (void)showTipViewWithContent:(NSString *)content  Attribut:(NSString *)att doneBtnTitle:(NSString *)doneStr TipType:(MHMineMerTipViewType)type {
    MHWeakify(self)
    MHMineMerTipView * tip = [MHMineMerTipView mineMerTipViewWithFrame:WINDOW.bounds Content:content Attribut:att TipType:type DostBtnTitle:doneStr TipViewDoSomeThing:^(MHMineMerTipView *tipView) {
        MHStrongify(self)
        if (type == MerTipViewType_MerRules) { // 联系客服
            NSString *telStr = [MHUserInfoManager sharedManager].customer_contact_tel ;
            [[MHAlertView sharedInstance]
             showTitleActionSheetTitle:@"拨打客服电话" sureHandler:^{
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telStr]]];
             }
             cancelHandler:nil
             sureButtonColor:MColorBlue
             sureButtonTitle:telStr];
            
        }else if (type == MerTipViewType_RegVolunteers) { //  注册志愿者
            
            MHVoDataFillController *vc = [[MHVoDataFillController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } AttributedBlock:^(MHMineMerTipView *tipView) { // 富文本跳转
        if (type == MerTipViewType_MerRules) { // 跳转到周边买家规则 H5
            HLWebViewController *vc = [[HLWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@h5/merchant-rule",baseUrl] webType:HLWebViewTypeNormal];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [WINDOW addSubview:tip];
}


- (void)showRegisAlterViewWithContent:(NSString *)content  Attribut:(NSString *)att doneBtnTitle:(NSString *)doneStr TipType:(MHMineMerTipViewType)type {
    MHWeakify(self)
    
    MHMineMerRegisterAlterView * view  = [MHMineMerRegisterAlterView mineMerRegisterAlterViewWithFrame:WINDOW.bounds Content:content Attribut:att TipType:MerRegisterAlterViewType_MerRules AttributedBlock:^(MHMineMerRegisterAlterView *tipView) {
        MHStrongify(self)
        // 富文本跳转
        if (type == MerTipViewType_MerRules) { // 跳转到周边买家规则 H5
            HLWebViewController *vc = [[HLWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@h5/merchant-rule",baseUrl] webType:HLWebViewTypeNormal];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [WINDOW addSubview:view];
}

@end
