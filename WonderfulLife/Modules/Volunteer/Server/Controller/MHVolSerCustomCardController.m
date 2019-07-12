//
//  MHVolSerCustomCardController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerCustomCardController.h"

#import <UIViewController+HLNavigation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MHWeakStrongDefine.h"
#import "MHMacros.h"
#import "MHHUDManager.h"
#import "MHAlertView.h"
#import "MHVolSerRefuseAlertView.h"


#import "MHVolSerTeamRequest.h"
#import "MHVolSerVolInfo.h"
#import "MHConst.h"
@interface MHVolSerCustomCardController ()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *buttonLineView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scContentViewConstraintHeight;


@property (strong,nonatomic) MHVolSerVolInfo *info;
@end

@implementation MHVolSerCustomCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    self.lineView.layer.cornerRadius = 6;
    self.lineView.layer.borderWidth = 1;
    self.lineView.layer.borderColor = MColorSeparator.CGColor;
    self.buttonLineView.layer.cornerRadius = 6;
    self.buttonLineView.layer.borderWidth = 1;
    self.buttonLineView.layer.borderColor = MColorSeparator.CGColor;
    self.headImageView.layer.cornerRadius = CGRectGetWidth(self.headImageView.frame)/2;
    self.headImageView.layer.masksToBounds = YES;
    self.callButton.hidden = YES;
    self.deleteButton.hidden = YES;
    
    
    CGRect  teamLabelFrame = self.teamLabel.frame ;
    self.teamLabel.layer.cornerRadius = teamLabelFrame.size.width*0.1  ;
    self.teamLabel.layer.masksToBounds = YES;
    
    [MHHUDManager show];
    MHWeakify(self)
//    [MHVolSerTeamRequest loadCustomCardWithVolunteer_id:self.volunteerId user_id:self.userId activtyId:self.activtyId team_id:self.teamId callBack:^(BOOL success, id info) {
//        [MHHUDManager dismiss];
//        MHStrongify(self)
//        if (success) {
//            self.info = info;
//            [self reloadData];
//        } else {
//            [MHHUDManager showErrorText:info];
//        }
//    }];
}

- (void)reloadData {
    [self.headImageView sd_setImageWithURL:self.info.icon placeholderImage:MAvatar];
    if (self.info.sex == 1) {//男
        [self.sexImageView setImage:[UIImage imageNamed:@"MHVolSerCardManIcon"]];
    } else if (self.info.sex == 2) {// 女
        [self.sexImageView setImage:[UIImage imageNamed:@"MHVolSerCardWomanIcon"]];
    } else {
        
    }
    self.namelabel.text = self.info.real_name;
    self.positionLabel.text = self.info.role_name;
    self.teamLabel.text = self.info.team_name;
    self.heartCountLabel.text = self.info.all_integral;
    self.serviceCountLabel.text = self.info.service_time;
    self.joinLabel.text = [NSString stringWithFormat:@"%@加入",self.info.join_date];
    self.callButton.hidden = !self.info.is_approve_call;
    self.deleteButton.hidden = !self.info.is_approve_delete;
    self.buttonLineView.hidden = !self.info.is_approve_call || !self.info.is_approve_delete;
}

- (IBAction)callAction:(id)sender {
    if (self.info.is_approve_call&&self.info.phone) {
        MHWeakify(self)
        NSString *roleName ;
        if (self.role == 0) {
            roleName = @"队员";
        }else if (self.role == 1){
            roleName = @"队长";
        }else if (self.role == 9){
            roleName = @"总队长";
        }
        [[MHAlertView sharedInstance]
         showTitleActionSheetTitle:[NSString stringWithFormat:@"拨打%@电话",roleName] sureHandler:^{
         UIWebView *callWeb = [[UIWebView alloc]init];
         [weak_self.view addSubview:callWeb];
         NSString *phoneStr = [[NSMutableString alloc] initWithFormat:@"tel://%@",weak_self.info.phone];
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]];
         [callWeb loadRequest:request];
        }
         cancelHandler:nil
         sureButtonColor:MColorBlue
         sureButtonTitle:self.info.phone];
    } else {
        
    }
}
- (IBAction)deleteAction:(id)sender {
    if (self.info.is_approve_delete) {
        [MHVolSerRefuseAlertView volSerRefuseAlertViewWithTitle:@"删除原因" tipStr:@"填写删除原因150字以内" clickSureButtonBlock:^(NSString *reason){
            [[MHAlertView sharedInstance]
             showNormalAlertViewTitle:@"确认将该成员从队伍中移除？"
             message:@"队员被移除后将不再是服务队队员，无法进行登记考勤等操作"
             leftHandler:nil
             rightHandler:^{
                 [MHVolSerTeamRequest deleteMemberWithVolunteer_id:self.volunteerId teamId:self.info.team_id delReason:reason callBack:^(BOOL success, id info) {
                     if (success) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVoSerTeamNotification object:nil];
                         [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVoSerDetailNotification object:nil];
                         [self.navigationController popViewControllerAnimated:YES];
                     } else {
                         [MHHUDManager showErrorText:info];
                     }
                 }];
             } rightButtonColor:nil];
            
        }];
    } else {
        
    }
}


- (void)updateViewConstraints{
    [super updateViewConstraints];
//    CGFloat scMax_H = CGRectGetMaxY(self.buttonLineView.frame);
    [self.scContentViewConstraintHeight setConstant:600] ;
    
}
@end
