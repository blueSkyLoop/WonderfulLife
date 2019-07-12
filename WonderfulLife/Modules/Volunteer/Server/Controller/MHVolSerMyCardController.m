//
//  MHVoMyCardViewController.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/8/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerMyCardController.h"
#import "MHVoHobbyController.h"
#import "MHVolunteerSupportController.h"
#import "MHVoAddressAddController.h"
#import "MHLoSetPlotController.h"
#import "MHNavigationControllerManager.h"
#import "MHVoBirthdayPickerView.h"
#import "MHVoDataPhoneController.h"
#import "MHVolSerMyCardCell.h"
#import "MHVolSerMyCardDutyCell.h"

#import "MHAliyunManager.h"
#import "MHVolCreateModel.h"
#import "MHCommunityModel.h"
#import "MHCityModel.h"

#import "MHMacros.h"
#import "MHHUDManager.h"
#import "MHWeakStrongDefine.h"
#import "MHVolSerMyCardModel.h"
#import "MHUserInfoManager.h"
#import "MHVolunteerDataHandler.h"
#import "JFAuthorizationStatusManager.h"

#import "UIViewController+HLStoryBoard.h"
#import "UIViewController+MHConfigControls.h"
#import "UIView+MHFrame.h"
#import "UIImage+Color.h"
#import "UIView+NIM.h"

#import <YYModel.h>
#import "ReactiveObjC.h"
#import "MHConst.h"

@interface MHVolSerMyCardController ()<UITableViewDelegate,UITableViewDataSource,MHNavigationControllerManagerProtocol>
@property (nonatomic, strong) MHVolSerMyCardViewModel *viewModel;
@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, assign) CGFloat   dutyRowHeight;
@end

@implementation MHVolSerMyCardController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mh_createTitleLabelWithTitle:@"我的资料卡"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self bindViewModel];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Private method

- (void)bindViewModel {
    
    self.viewModel = [[MHVolSerMyCardViewModel alloc]init];
    [MHHUDManager show];
    @weakify(self);
    [self.viewModel.userInfoCommand execute:nil];
    //refresh tableview data source
    [RACObserve(self.viewModel, isFreshed) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.tableView reloadData];
        }
    }];
    
    //------------------------- 通 知 -----------------------------/
    //修改需要帮助
    RACSignal *supportSignal = [[[NSNotificationCenter defaultCenter]
    rac_addObserverForName:kReloadVolSerMyCardControllerDataNotification object:nil]takeUntil:self.rac_willDeallocSignal];
    //修改住址
    RACSignal *addressSignal = [[[NSNotificationCenter defaultCenter]
    rac_addObserverForName:kReloadVolSerMyCardControllerAddressNotification object:nil]takeUntil:self.rac_willDeallocSignal];
    
    [supportSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MHHUDManager show];
        [self.viewModel.userInfoCommand execute:nil];
    }];
    
    [addressSignal subscribeNext:^(NSNotification *x) {
        @strongify(self);
        NSDictionary *dic = x.object;
        [self.viewModel.modifyAddressCommand execute:dic];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        MHVolSerMyCardDutyCell *cell = [MHVolSerMyCardDutyCell cellWithTableView:tableView];
        self.dutyRowHeight = [cell tagsArray:[MHUserInfoManager sharedManager].volUserInfo.volunteer_duty_list];
        return cell;
    }
    MHVolSerMyCardCell *cell = [MHVolSerMyCardCell cellWithTableView:tableView];
    MHVolSerMyCardModel *model = self.viewModel.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .8f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, MScreenW, .8f)];
    line.backgroundColor = MColorSeparator;
    return line;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 128.f;
    }else if (indexPath.row == 9) {
        return self.dutyRowHeight;
    }
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self chooseCamera];
    }else if(indexPath.row == 2){
        MHVolSerMyCardModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
        if (model.content.length <5) {
            [self chooseIdCard];
        }
    }else if (indexPath.row == 3){
        [self chooseSex];
    }else if(indexPath.row == 4) {
        MHVolSerMyCardModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
        [self chooseBirthday:model.content];
    }else if (indexPath.row == 5) {
        MHVolSerMyCardModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
        [self choosePhone:model.content];
    }else if (indexPath.row == 6) {
        [self chooseAddress];
    }else if (indexPath.row == 7){
        MHVoHobbyController *controller = [[MHVoHobbyController alloc] init];
        controller.type = MHVoHobbyControllerTypeModify;
        [controller setRefreshBlock:^{
            [self.viewModel.userInfoCommand execute:nil];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 8){
        MHVolunteerSupportController *controller = [[MHVolunteerSupportController alloc] init];
        controller.type = MHVolunteerSupportTypeVolCard;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - Action

- (void)chooseCamera {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction *shootAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_pickerController animated:YES completion:^{
            [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeVideo target:_pickerController];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_pickerController animated:YES completion:^{
            [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:_pickerController];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    if (iOS8_2_OR_LATER) {
        [shootAction setValue:MColorTitle forKey:@"titleTextColor"];
        [albumAction setValue:MColorTitle forKey:@"titleTextColor"];
        [cancelAction setValue:MColorContent forKey:@"titleTextColor"];
    }
    
    [alert addAction:shootAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    
    self.pickerController.navigationBar.tintColor = MRGBColor(50, 64, 81);
    self.pickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:MRGBColor(50, 64, 81), NSFontAttributeName: [UIFont systemFontOfSize:17]};
    [self.pickerController.navigationBar setBackgroundImage:[UIImage mh_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *yellowLabel = [[UILabel alloc] init];
    yellowLabel.font = [UIFont systemFontOfSize:17*MScreenW/375];
    yellowLabel.textColor = MRGBColor(255, 216, 0);
    yellowLabel.text = @"非本人照片或卡通头像将无法通过申请";
    [yellowLabel sizeToFit];
    yellowLabel.nim_height = 24*MScreenW/375;
    yellowLabel.nim_bottom = -24*MScreenW/375;
    yellowLabel.nim_centerX = alert.view.nim_width/2 - 10*MScreenW/375;
    [alert.view addSubview:yellowLabel];
    
    UILabel *middleLabel = [[UILabel alloc] init];
    middleLabel.font = MFont(22*MScreenW/375);
    middleLabel.textColor = [UIColor whiteColor];
    middleLabel.text = @"请提供您本人的免冠正面照片";
    [middleLabel sizeToFit];
    middleLabel.nim_height = 40*MScreenW/375;
    middleLabel.nim_centerX = alert.view.nim_width/2 - 10*MScreenW/375;
    middleLabel.nim_bottom = yellowLabel.nim_top;
    [alert.view addSubview:middleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_photo_tips"]];
    imageView.nim_size = CGSizeMake(100*MScreenW/375, 100*MScreenW/375);
    imageView.nim_centerX = alert.view.nim_width/2 - 10*MScreenW/375;
    imageView.nim_bottom = middleLabel.nim_top - 24*MScreenW/375;
    [alert.view addSubview:imageView];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)chooseSex {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MHHUDManager show];
        [self.viewModel.modifySexCommand execute:@1];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MHHUDManager show];
        [self.viewModel.modifySexCommand execute:@2];
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

- (void)chooseBirthday:(NSString*)birthday {
    MHVoBirthdayPickerView *_birthdayPicker = [[MHVoBirthdayPickerView alloc] init];
    _birthdayPicker.type = MHVoBirthdayPickerViewTypeSetting;
    _birthdayPicker.birthdayStr = birthday;
    
    _birthdayPicker.frame = self.view.bounds;
    [self.navigationController.view addSubview:_birthdayPicker];
    
    [_birthdayPicker show];
    @weakify(self);
    [_birthdayPicker setConfirmBlock:^(NSString *birthday){
        @strongify(self);
        [MHHUDManager show];
        [self.viewModel.modifyBirthdayCommand execute:birthday];
    }];

}

- (void)chooseIdCard {
    MHVoDataPhoneController *vc =  [[MHVoDataPhoneController alloc] init];
    vc.type = MHVoDataPhoneControllerTypeIdentity;
    @weakify(self);
    [vc setConfirmBlock:^(NSString *idcard){
        @strongify(self);
        [MHHUDManager show];
        [self.viewModel.modifyIdentityCardCommand execute:idcard];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)choosePhone:(NSString*)phone {
    MHVoDataPhoneController *vc =  [[MHVoDataPhoneController alloc] init];
    vc.string = phone;
    vc.type = MHVoDataPhoneControllerTypePhone;
    vc.isMaskCode = YES;
    @weakify(self);
    [vc setConfirmBlock:^(NSString *phone){
        @strongify(self);
        [MHHUDManager show];
        [self.viewModel.modifyPhoneCommand execute:phone];

    }];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)chooseAddress {
    
    MHVoAddressAddController *vc = [[MHVoAddressAddController alloc] init];
    vc.type = MHVoAddressAddTypeFillDatas;
    vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
        
        NSDictionary *json = @{@"city":community.city_name,
                               @"community":community.community_name,
                               @"room":community.community_address};
        
        [self.viewModel.modifyAddressCommand execute:json];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [MHHUDManager show];
    self.viewModel.isFreshed = NO;
    
    @weakify(self);
     [[MHAliyunManager sharedManager] uploadImageToAliyunWithImage:image success:^(MHOOSImageModel *imageModel) {
         @strongify(self);
         [MHHUDManager dismiss];
         
         MHVolCreateModel *createModel = [MHVolCreateModel sharedInstance];
         createModel.img_width = @(imageModel.width);
         createModel.img_height = @(imageModel.height);
         createModel.file_id = imageModel.name;
         createModel.file_url = imageModel.url;
         
         NSDictionary *dic = [MHVolCreateModel toDictionary];
         [self.viewModel.modifyHeaderImgCommand execute:dic];
         
         self.viewModel.isFreshed = YES;
     } failed:^(NSString *errmsg) {
         [MHHUDManager dismiss];
         [MHHUDManager showErrorText:errmsg];
     }];
}

- (BOOL)bb_ShouldBack{
      return YES;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.mh_y = 144;
        _tableView.mh_h = MScreenH - 144;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 194 + 11;
        _tableView.backgroundColor = MColorBackgroud;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIImagePickerController *)pickerController{
    if (_pickerController == nil) {
        UIImagePickerController *pc = [[UIImagePickerController alloc] init];
        pc.allowsEditing = YES;
        pc.delegate = self;
        _pickerController = pc;
    }
    return _pickerController;
}

@end
