//
//  MHMineInfoController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineInfoController.h"
#import "MHLoPlotSltController.h"
#import "MHVoDataAddressController.h"
#import "MHMineController.h"
#import "MHVoDataPhoneController.h"
#import "TZImagePickerController.h"

#import "MHMineCell.h"
#import "MHUserInfoManager.h"
#import "UIViewController+CameraSheet.h"
#import "MHMineRequestHandler.h"
#import "MHMineProvince.h"
#import "MHProvinceCityPickerView.h"

#import "MHVoBirthdayPickerView.h"
#import "MHNavigationControllerManager.h"

#import <UIImageView+WebCache.h>
#import "JFAuthorizationStatusManager.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHHUDManager.h"
#import <YYModel.h>
#import "UIImage+Color.h"
#import "UIViewController+CameraSheet.h"
#import "UIViewController+HLStoryBoard.h"
#import "MHTabBarControllerManager+StoreSwitch.h"

#import <AVFoundation/AVFoundation.h>

#import "MHLoginRequestHandler.h"

#import "MHAliyunManager.h"
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import "MHCommunityModel.h"
#import "MHAreaManager.h"
#import "MHMineNative.h"

#import "MHWeakStrongDefine.h"
#import "MHConst.h"
@interface MHMineInfoController ()<UITableViewDelegate,UITableViewDataSource,MHNavigationControllerManagerProtocol,TZImagePickerControllerDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,strong) MHProvinceCityPickerView *provinceCityPicker;
@property (nonatomic,strong) NSArray *provinceCities;
@property (nonatomic,assign) BOOL change;// 头像是否有修改
@property (nonatomic, assign) BOOL isChooseCity; // 城市是否有修改
@property (nonatomic,weak) MHVoBirthdayPickerView *birthdayPickerView;

@end

@implementation MHMineInfoController{
    CGFloat scale;
}

static NSString *MHMineCellID = @"MHMineCellID";

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = MRGBColor(249, 250, 252);
    if (iOS8) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:MColorTitle}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:17],NSForegroundColorAttributeName:MColorTitle}];
    }
    scale = MScreenW/375;
    self.title = @"个人信息";
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
    nav.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    nav.navigationBar.shadowImage = [UIImage mh_imageWithColor:[UIColor clearColor]];
    [nav navigationBarTranslucent];
}

- (BOOL)bb_ShouldBack{
    [self.birthdayPickerView removeFromSuperview];
    if (_provinceCityPicker) {
        [_provinceCityPicker removeFromSuperview];
        _provinceCityPicker = nil;
    }
    
    if (_isChooseCity) {
        MHTabBarControllerManager * tab = [MHTabBarControllerManager getMHTabbar] ;
        [tab mh_reloadChildControllers];
        
        return YES ;
    }
    if (self.change) {
        MHMineController *vc = self.navigationController.childViewControllers[0];
        !vc.refreshBlock ? : vc.refreshBlock();
        self.change = NO;
    }
    
    return YES;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - private
- (void)setupTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, self.view.nim_height-64)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[MHMineCell class] forCellReuseIdentifier:MHMineCellID];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

#pragma mark - 相机代理
- (void)dosomethingWithImage:(UIImage *)image{
    [MHHUDManager show];
    [[MHAliyunManager sharedManager] uploadImageToAliyunWithImage:image success:^(MHOOSImageModel *imageModel) {
        
        [MHMineRequestHandler postReviseIcon:imageModel Success:^(NSDictionary *data) {
            [MHHUDManager dismiss];
            MHUserInfoManager *user = [MHUserInfoManager sharedManager];
            user.user_s_img = (NSString *)data;
            [user saveUserInfoData];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.user_s_img]];
            self.change = YES;
        } Failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
        
    } failed:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMineCell *cell = [tableView dequeueReusableCellWithIdentifier:MHMineCellID];
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"头像";
        [cell setIconWithUrl:user.user_s_img];
        self.iconView = cell.iconView;
        cell.detailLabel.numberOfLines = 1;
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"昵称";
        cell.detailLabel.text = user.user_name;
        cell.detailLabel.numberOfLines = 1;
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"性别";
        cell.detailLabel.text = user.sex;
        cell.detailLabel.numberOfLines = 1;
    }else if (indexPath.row == 3){
        cell.titleLabel.text = @"小区";
        cell.detailLabel.text = user.community_name;
        cell.detailLabel.numberOfLines = 1;
    }else if (indexPath.row == 4){
        cell.titleLabel.text = @"家乡";
        cell.detailLabel.text = user.nativecity.native_city_name ? user.nativecity.native_city_name : user.nativeprovince.native_province_name;
        cell.detailLabel.numberOfLines = 1;
    }else if (indexPath.row == 5){
        cell.titleLabel.text = @"生日";
        cell.detailLabel.text = user.birthday;
        cell.detailLabel.numberOfLines = 1;
    }else if (indexPath.row == 6){
        cell.titleLabel.text = @"公司";
        cell.detailLabel.numberOfLines = 2;
        cell.detailLabel.text = user.company;
    }else if (indexPath.row == 7){
        cell.titleLabel.text = @"自我介绍";
        cell.detailLabel.numberOfLines = 2;
        cell.detailLabel.text = user.my_introduce;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if (indexPath.row == 0) {//头像
        
        [self choosePhoto];
        
    }else if (indexPath.row == 1){//昵称
        MHVoDataPhoneController *vc =  [[MHVoDataPhoneController alloc] init];
        vc.string = user.user_name;
        vc.type = MHVoDataPhoneControllerTypeName;
        [vc setConfirmBlock:^(NSString *name){
            
            [MHHUDManager show];
            [MHMineRequestHandler postReviseNickName:name Success:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                user.user_name = name;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [user saveUserInfoData];
                self.change = YES;
                
            } Failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){//性别
        [self sexChooseWithIndexPath:indexPath];
        
    }else if (indexPath.row == 3){//小区
        
        MHLoPlotSltController *vc = [MHLoPlotSltController hl_controllerWithIdentifier:@"MHLoPlotSltController" storyBoardName:@"MHLoSetPlotController"];
        vc.sltType = MHLoPlotSltTypeCity;
        MHWeakify(self)
        vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
            MHStrongify(self)
            [MHHUDManager show];
            [MHLoginRequestHandler communitySwitchWithCommunity:community success:^(BOOL success) {
                [MHUserInfoManager sharedManager].community_name = community.community_name ;
                [MHUserInfoManager sharedManager].community_id = community.community_id ;
                [[MHUserInfoManager sharedManager] saveUserInfoData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeControllerDataNotification object:nil];
                
                [self.tableView reloadData];
                _isChooseCity = YES;
                [MHHUDManager dismiss];
            } failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 4){//家乡
        if (self.provinceCityPicker.provinceCities == nil) {
            [MHHUDManager show];
            [MHMineRequestHandler postProvinceCitiesSuccess:^(NSDictionary *data) {
                [self.navigationController.view addSubview:self.provinceCityPicker];
                
                [self.provinceCityPicker show];
                self.provinceCityPicker.provinceCities = [NSArray yy_modelArrayWithClass:[MHMineProvince class] json:data];
                [MHHUDManager dismiss];
            } Failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
        }else{
            [self.navigationController.view addSubview:self.provinceCityPicker];
            [self.provinceCityPicker show];
        }
        
        [self.provinceCityPicker setConfirmBlock:^(MHMineNative *native){
            
            [MHHUDManager show];
            
            [MHMineRequestHandler postReviseNativeNativeProvinceID:native.native_province_id NativeCityID:native.native_city_id Success:^(NSDictionary *data) {
                
                [MHHUDManager dismiss];
                
                user.nativeprovince = [MHNativeprovince new];
                user.nativecity = [MHNativecity new];
                user.nativeprovince.native_province_id = native.native_province_id;
                user.nativeprovince.native_province_name = native.native_province_name;
                user.nativecity.native_city_id = native.native_city_id;
                user.nativecity.native_city_name = native.native_city_name;
                [user saveUserInfoData];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            } Failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
        }];
        
    }else if (indexPath.row == 5){//生日
        MHVoBirthdayPickerView *_birthdayPicker = [[MHVoBirthdayPickerView alloc] init];
        _birthdayPicker.type = MHVoBirthdayPickerViewTypeSetting;
        if (user.birthday.length) {
            _birthdayPicker.birthdayStr = [user.birthday substringToIndex:10];
        }
        _birthdayPicker.frame = self.view.bounds;
        [self.navigationController.view addSubview:_birthdayPicker];
        self.birthdayPickerView = _birthdayPicker;
        [_birthdayPicker show];
        [_birthdayPicker setConfirmBlock:^(NSString *birthday){
            [MHHUDManager show];
            [MHMineRequestHandler postReviseBirthday:birthday Success:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                
                user.birthday = (NSString *)data;
                [user saveUserInfoData];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } Failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
        }];
        
    }else if (indexPath.row == 6){//公司
        MHVoDataPhoneController *vc =  [[MHVoDataPhoneController alloc] init];
        vc.type = MHVoDataPhoneControllerTypeCompany;
        vc.string = user.company;
        [vc setConfirmBlock:^(NSString *company){
            [MHHUDManager show];
            [MHMineRequestHandler postReviseCompany:company Success:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                user.company = company;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [user saveUserInfoData];
            } Failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 7){//自我介绍
        MHVoDataAddressController *vc = [[MHVoDataAddressController alloc] init];
        vc.topTitle = @"自我介绍";
        vc.type = MHVoAddressTextViewTypeIntroduce;
        vc.address = user.my_introduce;
        [vc setConfirmBlock:^(NSString *address){
            [MHHUDManager show];
            [MHMineRequestHandler postReviseIntroduce:address Success:^(NSDictionary *data) {
                [MHHUDManager dismiss];
                user.my_introduce = address;
                [user saveUserInfoData];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } Failure:^(NSString *errmsg) {
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }];
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 128*scale;
    }else if (indexPath.row == 6){
        return 117*scale;
    }else{
        return 80*scale;
    }
}

#pragma mark - private

- (IBAction)choosePhoto{
    [self.view endEditing:YES];
    [self mh_showCameraSheet];
}

- (void)sexChooseWithIndexPath:(NSIndexPath *)indexPath {
    
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [MHHUDManager show];
        [MHMineRequestHandler postReviseSex:@1 Success:^(NSDictionary *data) {
            [MHHUDManager dismiss];
            user.sex = @"男";
            [user saveUserInfoData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } Failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
        }];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MHHUDManager show];
        [MHMineRequestHandler postReviseSex:@2 Success:^(NSDictionary *data) {
            [MHHUDManager dismiss];
            user.sex = @"女";
            [user saveUserInfoData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } Failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
        }];
    }];
    [alert addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action3];
    
    if (iOS8_2_OR_LATER) {
        [action1 setValue:MColorTitle forKey:@"titleTextColor"];
        [action2 setValue:MColorTitle forKey:@"titleTextColor"];
        [action3 setValue:MColorContent forKey:@"titleTextColor"];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - lazy

- (MHProvinceCityPickerView *)provinceCityPicker{
    if (_provinceCityPicker == nil) {
        _provinceCityPicker = [[MHProvinceCityPickerView alloc] initWithFrame:self.view.bounds];
        
    }
    return _provinceCityPicker;
}

@end





