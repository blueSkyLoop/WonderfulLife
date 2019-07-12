//
//  MHVolActivityInfoCardController.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityInfoCardController.h"
#import <UIViewController+HLNavigation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MHWeakStrongDefine.h"
#import "MHMacros.h"
#import "MHHUDManager.h"
#import "MHAlertView.h"

#import "MHVolunteerUserInfo.h"
#import "MHVolSerTeamRequest.h"
#import "MHVolSerVolInfo.h"
#import "MHConst.h"
#import "MHAlertView.h"
#import "MHVolSerRefuseAlertView.h"

#import "UILabel+isNull.h"
#import "UIView+Shadow.h"

@interface MHVolActivityInfoCardController ()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *buttonLineView;
@property (weak, nonatomic) IBOutlet UIView *callDeleteView;



@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton1;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;


@property (weak, nonatomic) IBOutlet UILabel *heartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartTitle;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitle;

// 中间的 “服务时长”
@property (weak, nonatomic) IBOutlet UILabel *cenServiceTitle;
@property (weak, nonatomic) IBOutlet UILabel *cenServiceContLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scContentViewConstraintHeight;


@property (strong,nonatomic) MHVolSerVolInfo *info;
@end

@implementation MHVolActivityInfoCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    self.lineView.layer.cornerRadius = 6;
    self.lineView.layer.borderWidth = 1;
    self.lineView.layer.borderColor = MColorSeparator.CGColor;
    [self.lineView mh_setupContainerLayerWithContainerView];
    
    self.buttonLineView.layer.cornerRadius = 6;
    self.buttonLineView.layer.borderWidth = 1;
    self.buttonLineView.layer.borderColor = MColorSeparator.CGColor;
    self.buttonLineView.hidden = YES;
    
    self.callDeleteView.layer.cornerRadius = 6;
    self.callDeleteView.layer.borderWidth = 1;
    self.callDeleteView.layer.borderColor = MColorSeparator.CGColor;
    self.callDeleteView.hidden = YES;
    
    self.headImageView.layer.cornerRadius = CGRectGetWidth(self.headImageView.frame)/2;
    self.headImageView.layer.masksToBounds = YES;
    
    
    
    CGRect  teamLabelFrame = self.teamLabel.frame ;
    self.teamLabel.layer.cornerRadius = teamLabelFrame.size.width*0.1  ;
    self.teamLabel.layer.masksToBounds = YES;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.volunteerId forKey:@"volunteer_id"];
    [dic setValue:self.activtyId forKey:@"activity_id"];
    [dic setValue:self.userId forKey:@"user_id"];
    self.teamId == nil ? : [dic setValue:self.teamId forKey:@"team_id"];
    
    [MHHUDManager show];
    MHWeakify(self)
    [MHVolSerTeamRequest loadCustomCardWithDic:dic callBack:^(BOOL success, id info) {
        [MHHUDManager dismiss];
        MHStrongify(self)
        if (success) {
            self.info = info;
            [self reloadData];
        } else {
            [MHHUDManager showErrorText:info];
        }
    }];
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
    self.cenServiceContLabel.text = self.info.service_time;
    
    [self.joinLabel mh_isNullWithDataSourceText:self.info.join_date allText:[NSString stringWithFormat:@"%@加入",self.info.join_date] isNullReplaceString:@""];

    [self resetStatus:self.info.is_approve_call isCanCheck:self.info.is_approve_view_score isDelete:self.info.is_approve_delete];
}


- (void)resetStatus:(BOOL)isCall isCanCheck:(BOOL)isCanCheck isDelete:(BOOL)isDelete{
    
    self.heartTitle.hidden = !isCanCheck ;
    self.heartCountLabel.hidden = !isCanCheck ;
    self.serviceTitle.hidden = !isCanCheck ;
    self.serviceCountLabel.hidden = !isCanCheck ;
    
    self.cenServiceTitle.hidden = isCanCheck ;
    self.cenServiceContLabel.hidden = isCanCheck ;

    if (self.type == MHVolActivityInfoCardTypeSer) {
        if (isCall && isDelete){  // 可删除&打电话
            self.callDeleteView.hidden = NO;
            self.buttonLineView.hidden = YES;
        }else if (isCall && !isDelete){ // 只可打电话
            self.callDeleteView.hidden = YES;
            self.buttonLineView.hidden = NO;
        }else{
            self.callDeleteView.hidden = YES;
            self.buttonLineView.hidden = YES;
        }
    }else{
        self.buttonLineView.hidden = !isCall;
    }
    
    
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
        [MHHUDManager showText:@"抱歉，该用户没有登记电话号码信息"];
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
