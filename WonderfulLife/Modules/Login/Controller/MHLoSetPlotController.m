//
//  MHLoSetPlotController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHLoSetPlotController.h"
#import "MHLoPlotSltController.h"
#import "MHCeSelRoomController.h"
#import "MHCertificationTypeController.h"
#import "MHDataPerfectController.h"
#import "MHNavigationControllerManager.h"
#import "MHVoDataFillController.h"
#import "MHHomePayNoteController.h"
#import "MHHomeRoomModel.h"
#import "MHHomePayMyRoomController.h"

#import "UIViewController+HLNavigation.h"
#import "UIView+GradientColor.h"
#import "NSString+HLJudge.h"

#import "MHCityModel.h"
#import "MHUserInfoManager.h"
#import "MHCommunityModel.h"

#import "MHWeakStrongDefine.h"
#import "MHLoginRequestHandler.h"
#import "MHMacros.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "MHHUDManager.h"
#import "MHHomeRequest.h"
#import "MHVolCreateModel.h"

@interface MHLoSetPlotController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plotLabelBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roomLabelBottom;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UIView *roomLine;
@property (weak, nonatomic) IBOutlet UIButton *roomButton;
@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (nonatomic,strong) MHCityModel *city;
@property (nonatomic,strong) MHCommunityModel *community;
@property (strong,nonatomic) MHStructRoomModel *room;
@property (copy,nonatomic) NSString *plotDescripe;
@property (copy,nonatomic) NSString *dongdanfan;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UIButton *communityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *communityImageView;

@end

@implementation MHLoSetPlotController

// 梁斌文
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarTranslucent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];

    if (self.setType == MHLoSetPlotTypeLogin) {
        self.roomLabel.hidden = YES;
        self.roomButton.hidden = YES;
        self.roomImageView.hidden = YES;
        self.roomLine.hidden = YES;
        NSArray *signalArray = @[RACObserve(self.cityLabel, text),RACObserve(self.plotLabel, text)];
        RAC(self.nextButton,enabled) = [RACSignal combineLatest:signalArray
                    reduce:^(NSString *city,NSString *plot){
                        return @(![city isEqualToString:@"所在城市"] && ![plot isEqualToString:@"所在小区"]);
                    }];
        [self.titleLabel setText:@"设置小区"];
    } else if (self.setType == MHLoSetPlotTypeCertifi) {
        // //住户认证：前端要限制不能切换城市、不能切换小区，并且去掉右箭头，只能认证当前所在小区的房间号。避免用户在A小区时，切换认证小区，重复认证B小区的房间号
        self.roomLabel.hidden = NO;
        self.roomButton.hidden = NO;
        self.roomImageView.hidden = NO;
        self.roomLine.hidden = NO;
        [self.cityBtn setEnabled:NO];
        [self.communityBtn setEnabled:NO];
        [self.cityImageView setHidden:YES];
        [self.communityImageView setHidden:YES];
        
        NSArray *signalArray = @[RACObserve(self.cityLabel, text),RACObserve(self.plotLabel, text),RACObserve(self.roomLabel, text)];
        RAC(self.nextButton,enabled) = [RACSignal combineLatest:signalArray
                    reduce:^(NSString *city,NSString *plot,NSString *room){
                        return @(![city isEqualToString:@"所在城市"] && ![plot isEqualToString:@"所在小区"] && ![room isEqualToString:@"房间号"]);
                    }];
        [self.titleLabel setText:@"住户认证"];
        if (![[MHUserInfoManager sharedManager].city.city_name hl_isEmpty]) {
            self.city = [MHCityModel cityModelFromUserInfo];
            [self.cityLabel setText:self.city.city_name];
            [self.cityLabel setTextColor:MColorTitle];
        }
        if (![[MHUserInfoManager sharedManager].community_name hl_isEmpty]) {
            self.community = [MHCommunityModel communityFromUserInfo];
            [self.plotLabel setText:self.community.community_name];
            [self.plotLabel setTextColor:MColorTitle];
        }
    } else if (self.setType == MHLoSetPlotTypePay) {
        self.roomLabel.hidden = NO;
        self.roomLabel.numberOfLines = 0;
        self.roomButton.hidden = NO;
        self.roomImageView.hidden = NO;
        self.roomLine.hidden = NO;
        NSArray *signalArray = @[RACObserve(self.cityLabel, text),RACObserve(self.plotLabel, text),RACObserve(self.roomLabel, text)];
        RAC(self.nextButton,enabled) = [RACSignal combineLatest:signalArray
                                                         reduce:^(NSString *city,NSString *plot,NSString *room){
                                                             return @(![city isEqualToString:@"所在城市"] && ![plot isEqualToString:@"所在小区"] && ![room isEqualToString:@"房间号"]);
                                                         }];
        [self.titleLabel setText:@"添加房间"];
        [self.nextButton setTitle:@"添加" forState:UIControlStateNormal];
        
        if (![[MHUserInfoManager sharedManager].city.city_name hl_isEmpty]) {
            self.city = [MHCityModel cityModelFromUserInfo];
            [self.cityLabel setText:self.city.city_name];
            [self.cityLabel setTextColor:MColorTitle];
        }
        if (![[MHUserInfoManager sharedManager].community_name hl_isEmpty]) {
            self.community = [MHCommunityModel communityFromUserInfo];
            [self.plotLabel setText:self.community.community_name];
            [self.plotLabel setTextColor:MColorTitle];
        }
        
    }else if (self.setType == MHLoSetPlotTypeReportRepairNew){ //投诉报修-选择房间
        self.roomLabel.hidden = NO;
        self.roomLabel.numberOfLines = 0;
        self.roomButton.hidden = NO;
        self.roomImageView.hidden = NO;
        self.roomLine.hidden = NO;
        NSArray *signalArray = @[RACObserve(self.cityLabel, text),RACObserve(self.plotLabel, text),RACObserve(self.roomLabel, text)];
        RAC(self.nextButton,enabled) = [RACSignal combineLatest:signalArray
                                                         reduce:^(NSString *city,NSString *plot,NSString *room){
                                                             return @(![city isEqualToString:@"所在城市"] && ![plot isEqualToString:@"所在小区"] && ![room isEqualToString:@"房间号"]);
                                                         }];
        [self.titleLabel setText:@"添加房间"];
        [self.nextButton setTitle:@"添加" forState:UIControlStateNormal];
     
        if (![[MHUserInfoManager sharedManager].city.city_name hl_isEmpty]) {
            self.city = [MHCityModel cityModelFromUserInfo];
            [self.cityLabel setText:self.city.city_name];
            [self.cityLabel setTextColor:MColorTitle];
        }
        if (![[MHUserInfoManager sharedManager].community_name hl_isEmpty]) {
            self.community = [MHCommunityModel communityFromUserInfo];
            [self.plotLabel setText:self.community.community_name];
            [self.plotLabel setTextColor:MColorTitle];
        }
        
        if (self.repair_room_json.length > 5) {
            
            NSData *jsonData = [self.repair_room_json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSString *city = dic[@"city"];
            NSString *community = dic[@"community"];
            NSString *room = dic[@"room"];
            
            self.city.city_name = city;
            self.community.community_id = self.repair_community_id;
            self.community.community_name = community;
            self.room = [[MHStructRoomModel alloc]init];
            self.room.room_no =  dic[@"room_no"];
            self.room.struct_id =  dic[@"struct_id"];
            self.room.room_info = room;
            
            [self.cityLabel setText:city];
            [self.cityLabel setTextColor:MColorTitle];
            [self.plotLabel setText:community];
            [self.plotLabel setTextColor:MColorTitle];
            [self.roomLabel setText:room];
            [self.roomLabel setTextColor:MColorTitle];
        }
        
    }else if (self.setType == MHLoSetPlotTypeAddress) {
        self.roomLabel.hidden = NO;
        self.roomButton.hidden = NO;
        self.roomImageView.hidden = NO;
        self.roomLine.hidden = NO;
        NSArray *signalArray = @[RACObserve(self.cityLabel, text),RACObserve(self.plotLabel, text)];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
        [confirm setTitle:@"确认" forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:17];
        [confirm sizeToFit];
        [confirm setTitleColor:MColorConfirmBtn forState:UIControlStateNormal];
        [confirm setTitleColor:MRGBColor(192, 204, 218) forState:UIControlStateDisabled];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
        [confirm addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        RAC(confirm,enabled) = [RACSignal combineLatest:signalArray
                                                         reduce:^(NSString *city,NSString *plot){
                                                             return @(![city isEqualToString:@"所在城市"] && ![plot isEqualToString:@"所在小区"]);
                                                         }];
        [self.titleLabel setText:@"选择住址"];
        [self.nextButton removeFromSuperview];
        
        if (![[MHUserInfoManager sharedManager].city.city_name hl_isEmpty]) {
            self.city = [MHCityModel cityModelFromUserInfo];
            [self.cityLabel setText:self.city.city_name];
            [self.cityLabel setTextColor:MColorTitle];
        }
        if (![[MHUserInfoManager sharedManager].community_name hl_isEmpty]) {
            self.community = [MHCommunityModel communityFromUserInfo];
            [self.plotLabel setText:self.community.community_name];
            [self.plotLabel setTextColor:MColorTitle];
        }
        
        if ([MHVolCreateModel sharedInstance].address.city) {
            [self.cityLabel setText:[MHVolCreateModel sharedInstance].address.city];
            [self.cityLabel setTextColor:MColorTitle];
        }
        
        if ([MHVolCreateModel sharedInstance].address.community) {
            [self.plotLabel setText:[MHVolCreateModel sharedInstance].address.community];
            [self.plotLabel setTextColor:MColorTitle];
        }
        
        if ([MHVolCreateModel sharedInstance].address.room.length > 1) {
            [self.roomLabel setText:[MHVolCreateModel sharedInstance].address.room];
            [self.roomLabel setTextColor:MColorTitle];
        }
    }
    
    [self.lineView.layer setBorderWidth:1];
    [self.lineView.layer setBorderColor:MColorSeparator.CGColor];
    [self.lineView.layer setCornerRadius:5];
    [self.nextButton.layer setCornerRadius:5];
    
    self.lineView.layer.shadowOffset = CGSizeMake(0, 2);
    self.lineView.layer.shadowRadius = 5;
    self.lineView.layer.shadowColor = MColorShadow.CGColor;
    self.lineView.layer.shadowOpacity = 1;
    self.lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    if (self.setType == MHLoSetPlotTypeLogin) {
        self.plotLabelBottom.priority = UILayoutPriorityDefaultHigh;
        self.roomLabelBottom.priority = UILayoutPriorityDefaultLow;
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MHLoSelectedCitySegueId"]) {
        ((MHLoPlotSltController *)segue.destinationViewController).sltType = MHLoPlotSltTypeCertifi;
        MHWeakify(self)
        ((MHLoPlotSltController *)segue.destinationViewController).callBack = ^(MHCityModel *city, MHCommunityModel *community) {
            MHStrongify(self)
            if (![self.city.city_name isEqualToString:city.city_name]) {
                self.city = city;
                [self.cityLabel setText:city.city_name];
                [self.cityLabel setTextColor:MColorTitle];
                self.community = nil;
                [self.plotLabel setText:@"所在小区"];
                [self.plotLabel setTextColor:MColorContent];
                self.room = nil;
                [self.roomLabel setText:@"房间号"];
                [self.roomLabel setTextColor:MColorContent];
            }
            [self.navigationController popToViewController:self animated:YES];
        };
    } else if ([segue.identifier isEqualToString:@"MHLoSelectedPlotSegueId"]) {
        if (self.setType == MHLoSetPlotTypeLogin) {
            ((MHLoPlotSltController *)segue.destinationViewController).sltType = MHLoPlotSltTypeWithCommunity;
        }else if (self.setType == MHLoSetPlotTypeAddress) {
            ((MHLoPlotSltController *)segue.destinationViewController).sltType = MHLoPlotSltTypeVol;
        }
        else {
            ((MHLoPlotSltController *)segue.destinationViewController).sltType = MHLoPlotSltTypePlot;
        }
        
        if (self.setType == MHLoSetPlotTypeAddress||self.setType == MHLoSetPlotTypeReportRepairNew) { // 志愿者申请 && 投诉报修
            ((MHLoPlotSltController *)segue.destinationViewController).ctrType = MHLoPlotCtrTypeSome;
        }
        ((MHLoPlotSltController *)segue.destinationViewController).currentCity = self.city;
        MHWeakify(self)
        ((MHLoPlotSltController *)segue.destinationViewController).callBack = ^(MHCityModel *city, MHCommunityModel *community) {
            MHStrongify(self)
            if (![self.community.community_name isEqualToString:community.community_name]) {
                self.city = city;
                [self.cityLabel setText:city.city_name];
                [self.cityLabel setTextColor:MColorTitle];
                self.community = community;
                [self.plotLabel setText:community.community_name];
                [self.plotLabel setTextColor:MColorTitle];
                self.room = nil;
                [self.roomLabel setText:@"房间号"];
                [self.roomLabel setTextColor:MColorContent];
            }
        };
    } else if ([segue.identifier isEqualToString:@"MHLoSelectedRoomtSegueId"]) {
        //       if (self.community == nil) return ;
        ((MHCeSelRoomController *)segue.destinationViewController).currentCommunity = self.community;
                MHWeakify(self)
                ((MHCeSelRoomController *)segue.destinationViewController).callBack = ^(MHStructAreaModel *area, MHStructBuildingModel *bulid, MHStructUnitModel *unit, MHStructRoomModel *room) {
                    MHStrongify(self)
                    self.plotDescripe = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",self.community.community_name,area.area,bulid.building_no,unit.unit_no,room.room_no];
                    
                    NSString *areaStr = area.area;
                    if ([areaStr isEqualToString:@"无区域"] | [areaStr isEqualToString:@"无管理区"]) {
                        areaStr = @"";
                    }
                    
                    if ([unit.unit_no isEqualToString:@"无单元"]) {
                         self.dongdanfan = [NSString stringWithFormat:@"%@/%@",bulid.building_no,room.room_no];
                    } else {
                        self.dongdanfan = [NSString stringWithFormat:@"%@/%@/%@",bulid.building_no,unit.unit_no,room.room_no];
                    }
                    self.room = room;
                    if (areaStr.length) {
                        [self.roomLabel setText:[NSString stringWithFormat:@"%@/%@",areaStr,self.dongdanfan]];
                    }else{
                        [self.roomLabel setText:self.dongdanfan];
                    }
                    [self.roomLabel setTextColor:MColorTitle];
                };
    } else {}
}

- (IBAction)next {
    if (self.setType == MHLoSetPlotTypeLogin) {
        if (self.city == nil) return ;
        if (self.community == nil) return ;
        [MHHUDManager show];
        [MHLoginRequestHandler postRegisterPhone:self.phone code:self.code CommunityID:self.community.community_id success:^{
            [MHHUDManager dismiss];
            if (self.joinVolunteerFlag) {
                //过滤完善资料两个界面
                MHVoDataFillController *vc = [[MHVoDataFillController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self.navigationController pushViewController:[MHDataPerfectController new] animated:YES];
            }
            ///MARK - push to MHDataPerfectController
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    } else if (self.setType == MHLoSetPlotTypeCertifi) {
        if (self.city == nil) return ;
        if (self.community == nil) return ;
        if (self.room == nil) return ;
        
        [MHHUDManager show];
        [MHLoginRequestHandler checkTheRoomIsExistWithRoomID:self.room.struct_id success:^{
            [MHHUDManager dismiss];
            MHCertificationTypeController *vc = [[MHCertificationTypeController alloc] init];
            vc.plotDescripe = self.plotDescripe;
            vc.room = self.room;
            vc.dongdanfan = self.dongdanfan;
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSString *errmsg) {}];
        
    } else if (self.setType == MHLoSetPlotTypePay) {
        
        if (self.city == nil) return ;
        if (self.community == nil) return ;
        if (self.room == nil) return ;
        if (self.room.property_id == nil) return;
        
        [MHHUDManager show];
        [MHHomeRequest postPropertyfeeCreateWithPropertyID:self.room.property_id.stringValue Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                BOOL b = data[@"result"];
                if (b) {
                    if (self.fromHome == YES) {
                        MHHomePayNoteController *vc =[MHHomePayNoteController new];
                        MHHomeRoomModel *room = [MHHomeRoomModel new];
                        room.property_name = self.room.room_info;
                        room.owner_name = self.room.owner_name;
                        room.property_id = self.room.property_id.stringValue;
                        vc.room = room;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        NSInteger index = self.navigationController.viewControllers.count-2;
                        MHHomePayMyRoomController *roomListVC = (MHHomePayMyRoomController *)self.navigationController.viewControllers[index];
                        !roomListVC.refreshDataList ? : roomListVC.refreshDataList();
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    [MHHUDManager showErrorText:@"添加失败"];
                }
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
        }];
        
    } else if (self.setType == MHLoSetPlotTypeAddress){
        
        if (self.city == nil) return ;
        if (self.community == nil) return ;
        
        NSInteger index = self.navigationController.viewControllers.count-2;
        MHVoDataFillController *vc = self.navigationController.viewControllers[index];
        MHVolCreateModel *model = [MHVolCreateModel sharedInstance];
        model.address.city = self.cityLabel.text;
        model.address.community = self.plotLabel.text;
        NSString *room = self.roomLabel.text;
        if ([self.roomLabel.text isEqualToString:@"房间号"]) {
            room = @" ";
        }
        model.address.room = room;

        vc.room_info = [NSString stringWithFormat:@"%@%@%@",self.city.city_name,self.plotLabel.text,room];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.setType == MHLoSetPlotTypeReportRepairNew) {
        if (self.city == nil) return ;
        if (self.community == nil) return ;
        NSString *room = self.roomLabel.text;
        if ([self.roomLabel.text isEqualToString:@"房间号"]) {
            room = @" ";
        }
        NSDictionary *json = @{@"city":self.cityLabel.text,
                               @"community":self.plotLabel.text,
                               @"room":room,
                               @"room_no":self.room.room_no,
                               @"struct_id":self.room.struct_id,
                               @"community_id":self.community.community_id};

        [[NSNotificationCenter defaultCenter]postNotificationName:@"kReloadVolSerMyCardControllerAddressNotification" object:json];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

@end
