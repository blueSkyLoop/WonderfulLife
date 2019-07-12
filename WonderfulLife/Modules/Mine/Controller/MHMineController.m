//
//  WHMineController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineController.h"

#import "UIViewController+ShowCustomAlterView.h"

#import "MHMineInfoController.h"
#import "MHVoSerIntegralDetailsController.h"
#import "MHVoDataFillController.h"
#import "MHLoSetPlotController.h"
#import "MHPersonSettingController.h"
#import "MHMineMerchantController.h"
#import "MHMerchantOrderController.h"
#import "MHMineIntQrCodeController.h"
#import "HLWebViewController.h"
#import "MHHomePayMyRoomController.h"


#import "MHWeakStrongDefine.h"
#import "MHMineCell.h"
#import "MHMineMerTipView.h"
#import "PYPhotoBrowser.h"
#import "MHAlertView.h"
#import "MHIntegralsPayAlertView.h"

#import <UIImageView+WebCache.h>
#import "UIImage+Color.h"
#import "UIViewController+HLStoryBoard.h"
#import "UIViewController+MHTelephone.h"
#import "Masonry.h"

#import "MHUserInfoManager.h"
#import "MHAreaManager.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHHUDManager.h"
#import "MHConst.h"
#import "MHMineRequestHandler.h"
#import "MHConstSDKConfig.h"
#import "MHMineFuncModel.h"

extern NSNumber *homeCommunity_id;

@interface MHMineController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UIButton *coverButton;
@property (nonatomic, copy)   NSArray * sources;
@end

@implementation MHMineController{
    CGFloat scale;
    CGFloat headerH;
    NSNumber *lastHomeCommunity_id;
}

static NSString *MHMineCellID = @"MHMineCellID";
#pragma mark - Getter
- (NSArray *)sources {
    _sources = [MHMineFuncModel mineFuncs];
    return _sources ;
}



#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backImage = [UIImage mh_imageGradientSetMineColorWithBounds:self.view.bounds] ;
    UIColor *backColor = [UIColor colorWithPatternImage:backImage];
    self.view.backgroundColor = backColor;
    
    scale = MScreenW/375;
    [self setupTableView];
    [self setupHeaderView];
    lastHomeCommunity_id = homeCommunity_id;
    MHWeakify(self);
    [self setRefreshVoStateBlock:^{
        MHUserInfoManager *user = [MHUserInfoManager sharedManager];
        user.is_volunteer = @1;
        [user saveUserInfoData];
        [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self setRefreshCetifiStateBlock:^(NSInteger certificationType){
        MHUserInfoManager *user = [MHUserInfoManager sharedManager];
        user.validate_status = @(certificationType);
        [user saveUserInfoData];
        [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVolunteerState:) name:kTenementValidateResultNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if([MHUserInfoManager sharedManager].login){
        [self updateUserInfo];
    }
    if (lastHomeCommunity_id != homeCommunity_id) {
        [self sources];
        [self.tableView reloadData];
        lastHomeCommunity_id = homeCommunity_id;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark - notification
- (void)refreshVolunteerState:(NSNotification *)noti{
    [self updateUserInfo];
}


#pragma mark - Request
- (void)updateUserInfo {
    [MHHUDManager show];
    [MHMineRequestHandler uptateProfileCallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            [self.tableView reloadData];
            [self setupHeaderView]; // 重新渲染headerView 数据
        }else{
            [MHHUDManager showText:errmsg];
        }
        
    }];
}

#pragma mark - private
- (void)setupTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MTopStatus_Height, MScreenW, MScreenH - (MToolBarHeight + MTopStatus_Height))];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 80*scale;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[MHMineCell class] forCellReuseIdentifier:MHMineCellID];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

- (void)setupHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.nim_width, 202*scale)];
    headerH = headerView.nim_height;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coverButton.frame = headerView.bounds;
    [coverButton setBackgroundImage:[UIImage mh_imageGradientSetMineColorWithBounds:headerView.bounds] forState:UIControlStateNormal];
    coverButton.adjustsImageWhenHighlighted = NO;
    [headerView addSubview:coverButton];
    [coverButton addTarget:self action:@selector(mineInfo) forControlEvents:UIControlEventTouchUpInside];
    self.coverButton = coverButton;
    
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    NSMutableArray *thumbnailImageUrls = [NSMutableArray array];
    NSMutableArray *originalImageUrls = [NSMutableArray array];
    if (user.user_s_img.length) {
        [thumbnailImageUrls addObject:user.user_s_img];
        [originalImageUrls addObject:user.user_s_img];
    }
    PYPhotosView *photosView = [PYPhotosView photosViewWithThumbnailUrls:thumbnailImageUrls originalUrls:originalImageUrls];
    photosView.frame = CGRectMake(24*scale, 0, 80*scale, 80*scale);
    photosView.nim_centerY = headerView.nim_height/2;
    photosView.layer.cornerRadius = photosView.nim_width/2;
    photosView.layer.masksToBounds = YES;
    [headerView addSubview:photosView];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mi_whiteArrow"]];
    [arrowView sizeToFit];
    arrowView.nim_right = headerView.nim_width - 24*scale;
    arrowView.nim_centerY = headerView.nim_height/2;
    [headerView addSubview:arrowView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(photosView.nim_right+20*scale, 76*scale, 0, 0)];
    nameLabel.nim_size = CGSizeMake(200*scale, 28*scale);
    nameLabel.font = MFont(20*scale);
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:nameLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.nim_left, nameLabel.nim_bottom+8*scale, 200*scale, 0)];
    addressLabel.nim_height = headerView.nim_height - addressLabel.nim_top;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = MFont(14*scale);
    addressLabel.numberOfLines = 0;
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.text = user.user_home;
    [addressLabel sizeToFit];
    [headerView addSubview:addressLabel];
    
    MHWeakify(self);
    [self setRefreshBlock:^{
        MHUserInfoManager *user = [MHUserInfoManager sharedManager];
        NSMutableArray *thumbnailImageUrls = [NSMutableArray array];
        NSMutableArray *originalImageUrls = [NSMutableArray array];
        if (user.user_s_img.length) {
            [thumbnailImageUrls addObject:user.user_s_img];
            [originalImageUrls addObject:user.user_s_img];
        }
        photosView.originalUrls = originalImageUrls;
        photosView.thumbnailUrls = thumbnailImageUrls;
        //第三方的bug
        photosView.frame = CGRectMake(24*scale, 0, 80*scale, 80*scale);
        photosView.nim_centerY = headerView.nim_height/2;
        
        nameLabel.text = user.user_name;
        if (user.user_type == 0) {
            addressLabel.text = user.community_name;
        }else{
            addressLabel.text = user.user_home;
        }
        addressLabel.nim_width = 200*scale;
        [addressLabel sizeToFit];
        [weak_self.tableView reloadData];
    }];
    
    nameLabel.text = user.user_name;
    if (user.user_type == 0) {
        addressLabel.text = user.community_name;
    }else{
        addressLabel.text = user.user_home;
    }
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMineCell *cell = [tableView dequeueReusableCellWithIdentifier:MHMineCellID];
    
    MHMineFuncModel *source = self.sources[indexPath.row];
    
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];

    NSString *detailText = @"";
    if (source.type == MHMineFuncModelType_LovePoints) {
        if (user.is_volunteer.integerValue) {
            cell.detailLabel.textColor = MRGBColor(132, 146, 166);
            detailText = [NSString stringWithFormat:@"%.2lf",user.all_integral.floatValue];
            
        }else{
            cell.detailLabel.textColor = MRGBColor(255, 73, 73);
            detailText = @"申请志愿者";
        }
        
    }else if (source.type == MHMineFuncModelType_Community){
        if (user.validate_status.integerValue == 0) {
            cell.detailLabel.textColor = MRGBColor(255, 73, 73);
            detailText = @"申请住户认证";
        }else if (user.validate_status.integerValue == 1){
            cell.detailLabel.textColor = MRGBColor(132, 146, 166);
            detailText = @"认证审核中";
        }else{
            cell.detailLabel.textColor = MRGBColor(132, 146, 166);
            detailText = @"已认证住户身份";
        }
        
    }
    
    cell.titleLabel.text = source.title;
    cell.detailLabel.text = detailText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    
    MHMineFuncModel *source = self.sources[indexPath.row];
    
    if (source.type == MHMineFuncModelType_LovePoints) {
        
        if (user.is_volunteer.integerValue) {
            MHVoSerIntegralDetailsController *vc = [[MHVoSerIntegralDetailsController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MHVoDataFillController *vc = [[MHVoDataFillController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (source.type == MHMineFuncModelType_Community){
        
        if (user.validate_status.integerValue == 0) {
            MHLoSetPlotController *vc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:NSStringFromClass([MHLoSetPlotController class])];
            vc.setType = MHLoSetPlotTypeCertifi;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MHHomePayMyRoomController *vc = [MHHomePayMyRoomController new];
            vc.type = MHHomePayMyRoomControllerTypeMine;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (source.type == MHMineFuncModelType_Order){ // 周边商家订单
        MHMerchantOrderController *controller = [[MHMerchantOrderController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (source.type == MHMineFuncModelType_Merchant){  // 我是商家  user.is_merchant
        if ([user.is_merchant integerValue] == 1) {
            MHMineMerchantController * vc = [MHMineMerchantController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self mh_showRegisteredMerView];
        }
        
    }else if (source.type == MHMineFuncModelType_IntQrCode){  // 积分二维码
        if ([user.is_volunteer integerValue] == 1) { //  是志愿者
            MHMineIntQrCodeController *vc = [[MHMineIntQrCodeController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            [self mh_showRegisteredVolunteerView];
        }
        
    }else if (source.type == MHMineFuncModelType_Setting){
        MHPersonSettingController *vc = [MHPersonSettingController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)showTipViewWithContent:(NSString *)content  Attribut:(NSString *)att doneBtnTitle:(NSString *)doneStr TipType:(MHMineMerTipViewType)type {
    MHWeakify(self)
    MHMineMerTipView * tip = [MHMineMerTipView mineMerTipViewWithFrame:self.view.bounds Content:content Attribut:att TipType:type DostBtnTitle:doneStr TipViewDoSomeThing:^(MHMineMerTipView *tipView) {
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



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.coverButton.nim_top = offsetY;
    self.coverButton.nim_height = headerH - offsetY;
}

- (void)mineInfo{
    MHMineInfoController *vc = [MHMineInfoController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end





