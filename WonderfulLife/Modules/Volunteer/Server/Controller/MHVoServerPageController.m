//
//  MHVoServerPageController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoServerPageController.h"
#import "UIViewController+HLNavigation.h"
#import "AppDelegate.h"
#import "MHUserInfoManager.h"
#import "MHNavigationControllerManager.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "MHWeakStrongDefine.h"
#import "MHConstSDKConfig.h"
#import <Masonry.h>
#import "UIImage+Color.h"
#import "UIImage+HLColor.h"
#import "UIButton+MHImageUpTitleDown.h"

#import "MHVolGifAlertView.h"
#import "MHVolExchangeAlertView.h"
#import "MHHUDManager.h"
#import "MHBuildingView.h"

#import "MHVoServerPageDelegateModel.h"
#import "MHVolSeverPageViewModel.h"
#import "MHActivityStatusView.h"
#import "MHAlertSheetView.h"
#import "MHVoSeverPageCell.h"
#import "MHVolunteerUserInfo.h"


#import "MHVolActivityListController.h"
#import "HLWebViewController.h"
#import "MHVoSerTeamController.h"
#import "MHVolSerItemController.h"
#import "MHVoSerCheckTimeController.h"
#import "MHVoSerIntegralDetailsController.h"
#import "MHVoSeReviewController.h"
#import "MHVolSerMyCardController.h"
#import "MHGcTableController.h"
#import "MHVoAttendanceRecordsController.h"

#import "MHVoSheetView.h"
#import "MHSheetController.h"

@interface MHVoServerPageController () <MHNavigationControllerManagerProtocol>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)MHVoServerPageDelegateModel *delegateModel;
@property (nonatomic,strong)MHVolSeverPageViewModel *viewModel;

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) MHActivityStatusView *bottomButton;

@property (nonatomic, strong) UIImage *barImage;
@property (nonatomic, strong) UIImage *barClearImage;

@end

@implementation MHVoServerPageController

- (void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MColorBackgroud;
    
    [self setUpUI];
    
    [self bindViewModel];
    
    [self headViewBlockHander];
    
    /// 新增功能：添加新的志愿者用户信息类，以用于以后的虚拟志愿者信息，目前代码设计暂时每次进来用原来的userinfo赋值ID
    [MHVolunteerUserInfo sharedInstance].volunteer_id = [MHUserInfoManager sharedManager].volunteer_id;
}
- (BOOL)bb_ShouldBack {
    /*判断是否弹窗提醒 简约
     需求说明：用户成为志愿者回到此控制器，返回无需弹窗；
     成为志愿者的下一次开启app来此控制器，返回需弹窗；
     总的来说弹窗只弹一次。
     条件：成为志愿者将会更改全局标识符  isShow
     本地缓存是否弹窗过 key:isShowexchangeAlert
     */
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *key = [NSString stringWithFormat:@"showed--%@", [MHUserInfoManager sharedManager].user_id];
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    if (!appDelegate.isIgnore && !isShowed) {
        MHVolExchangeAlertView *alert = [MHVolExchangeAlertView volExchangeAlertView];
        alert.frame = WINDOW.bounds;
        [WINDOW addSubview:alert];
        
        MHWeakify(self)
        MHWeakify(alert)
        [alert setShootBlock:^(BOOL isSimply){
            MHStrongify(self)
            MHStrongify(alert)
            NSString *simplyFlagKey = [NSString stringWithFormat:@"simplyFlag--%@", [MHUserInfoManager sharedManager].user_id];
            [[NSUserDefaults standardUserDefaults] setBool:isSimply forKey:simplyFlagKey];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
            
            [alert removeFromSuperview];
            
            MHVolGifAlertView *gif = [MHVolGifAlertView volGifAlertView];
            gif.simplyFlag = isSimply;
            [WINDOW addSubview:gif];
            MHWeakify(gif)
            [gif setShootBlock:^{
                //cache
                MHStrongify(gif)
                [gif removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        return NO;
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    
    //每次进来都刷新一次，因为积分有可能变化了
     [self.viewModel.serverCommand execute:@(NO)];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)helpAction{
    [self.navigationController pushViewController:[[HLWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@h5/salary",baseUrl]] animated:YES];
}

- (void)setUpUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = MColorBackgroud;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"vo_se_shapecopy"] style:UIBarButtonItemStylePlain target:self action:@selector(helpAction)];
    self.navigationItem.titleView = self.titleButton;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomButton];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(MScreenH - 96));
    }];
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@96);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.refreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
        
    }];
    
    [self.viewModel.serverCommand.executionSignals.switchToLatest subscribeNext:^(MHVolunteerServiceMainModel *model) {
        @strongify(self);
        [self handleAlertWithModel:model];
    }];
    [self.viewModel.serverCommand.errors subscribeNext:^(NSError *error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
        @strongify(self);
        [self.bottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }];
    [self.viewModel.virtualAccountCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.delegateModel.isCacelNotice = NO;
        [self.viewModel.serverCommand execute:@(YES)];
    }];
    [self.viewModel.virtualAccountCommand.errors subscribeNext:^(NSError *error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    [self.viewModel.attendanceRecordCommand.executionSignals.switchToLatest subscribeNext:^(id  data) {
        @strongify(self);
        [self handleattendanceRecordData:data];
    }];
    [self.viewModel.attendanceRecordCommand.errors subscribeNext:^(NSError *error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    
    //代理
    self.delegateModel = [[MHVoServerPageDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure collectionView:self.collectionView cellClassNames:@[NSStringFromClass(MHVoSeverPageCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, MHVoServerFunctiomModel *cellModel) {
        @strongify(self);
        [self jumpPageWithModel:cellModel];
    }];
    
    self.delegateModel.scorllLimitHeightBlock = ^(BOOL isLimit){
        @strongify(self);
        if(isLimit){
            [self.navigationController.navigationBar setBackgroundImage:self.barImage
                                                          forBarMetrics:UIBarMetricsDefault];
        }else{
            [self.navigationController.navigationBar setBackgroundImage:self.barClearImage
                                                          forBarMetrics:UIBarMetricsDefault];
        }
    };
    
    
}

- (void)headViewBlockHander{
    @weakify(self);
    self.delegateModel.headView.comeinMyScoreBlock = ^(){
        @strongify(self);
        [self.navigationController pushViewController:[MHVoSerIntegralDetailsController new] animated:YES];
    };
}

//考勤记录数据处理
- (void)handleattendanceRecordData:(id)data{
    NSArray *arrayModel = [NSArray yy_modelArrayWithClass:[MHGcTableModel class] json:data];
    if (arrayModel.count == 0) {
        return ;
    }
    if (arrayModel.count == 1) {
        MHVoAttendanceRecordsController *vc = [MHVoAttendanceRecordsController new];
        vc.attendance_id = [arrayModel.firstObject team_id];
        vc.role_in_team = [arrayModel.firstObject role_in_team];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MHGcTableController *vc = [[MHGcTableController alloc] init];
        vc.titleStr = @"选择服务队";
        vc.dataSource = arrayModel;
        @weakify(self);
        vc.didSelectBlock = ^(MHGcTableModel *model){
            @strongify(self);
            MHVoAttendanceRecordsController *vc = [[MHVoAttendanceRecordsController alloc] init];
            vc.attendance_id = model.team_id;
            vc.role_in_team = model.role_in_team;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)handleAlertWithModel:(MHVolunteerServiceMainModel *)model{
    [self.delegateModel.headView loadScroeInforWithModel:model];
    self.delegateModel.approving_projects = model.approving_projects;
    if(self.viewModel.volunteer_role == volunteerRoleTypeVirtualAccount){
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [_bottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }else{
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@(MScreenH - 96));
        }];
        [_bottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@96);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
    }
    
    
    if (model.volunteer_list.count > 1) {
        
        @weakify(self);
        [model.volunteer_list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"is_current"] integerValue] == 1) {
                @strongify(self);
                self.titleButton.enabled = YES;
                [MHVolunteerUserInfo sharedInstance].volunteer_id = obj[@"volunteer_id"];
                [self.titleButton mh_setLeftTitle: obj[@"real_name"] rightImage:[UIImage imageNamed:@"vo_home_down_arrow"]];
            }
        }];
    }
    
    //弹窗
    if ([model.is_lt_3h isEqualToNumber:@1]) {
        //判断是否当月已弹过
        NSDate *date = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitMonth;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        NSInteger month =  [dateComponent month];
        
        //get cache month
        NSString *key = [NSString stringWithFormat:@"month--%@",[MHUserInfoManager sharedManager].user_id];
        NSInteger monthCache = [[NSUserDefaults standardUserDefaults] integerForKey:key];
        if (month != monthCache) {
            NSString *content = @"尊敬的志愿者，您上个月的总服务时长少于3小时，请您积极参加各类志愿者服务活动，如每年服务时长少于36小时，将会被取消志愿者资格。";
            MHBuildingView *buildingView = [MHBuildingView buildingViewWithIcon:@"vo_serverTime_alert" title:nil content:content];
            buildingView.frame = WINDOW.bounds;
            [WINDOW addSubview:buildingView];
            
            [[NSUserDefaults standardUserDefaults] setInteger:month forKey:key];
        }
    }
}
//根据枚举跳转界面,无需关心在视图中的下标，只需要关心数据源数组的顺序
- (void)jumpPageWithModel:(MHVoServerFunctiomModel *)model{
    switch (model.type) {
        case SeverPage_team://服务队
        {
            [self.navigationController pushViewController:[MHVoSerTeamController new] animated:YES];
        }
            break;
        case SeverPage_project://服务项目
        {
            [self.navigationController pushViewController:[MHVolSerItemController new] animated:YES];
        }
            break;
        case SeverPage_integralDetail://积分明细
        {
            [self.navigationController pushViewController:[MHVoSerIntegralDetailsController new] animated:YES];
        }
            break;
        case SeverPage_time://服务时长
        {
            MHVoSerCheckTimeController * vc  = [[MHVoSerCheckTimeController alloc] initWithType:MHVolCheckTimeNormal];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SeverPage_attendanceRecord://考勤记录
        {
            [self.viewModel.attendanceRecordCommand execute:nil];
        }
            break;
        case SeverPage_verification://人员审核
        {
            [self.navigationController pushViewController:[MHVoSeReviewController new] animated:YES];
        }
            break;
        case SeverPage_informationCard://资料卡
        {
            [self.navigationController pushViewController:[MHVolSerMyCardController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark lazyload
- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize =CGSizeMake(width / 3, width / 3);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [MHVoServerPageDelegateModel createCollectionViewWithLayout:layout rigistNibCellNames:@[NSStringFromClass(MHVoSeverPageCell.class)] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (MHVolSeverPageViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHVolSeverPageViewModel new];
    }
    return _viewModel;
}
- (UIButton *)titleButton{
    if(!_titleButton){
        _titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame=CGRectMake(20, 20, 150, 40);
        [_titleButton setTitle:@"志愿者服务" forState:UIControlStateNormal];
        @weakify(self);
        [[[_titleButton rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.3] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.viewModel.model.volunteer_list.count < 2) {
                return;
            }
            MHVoSheetView *alertView = [MHVoSheetView alertViewWithTitle:nil message:@"选择要切换的志愿者"];
            [self.viewModel.model.volunteer_list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MHAlertActionStyle style = MHAlertActionStyleDefault;
                if ([obj[@"is_current"] integerValue] == 1) {
                    style = MHAlertActionStyleSelected;
                }
                [alertView addAction:[MHVoAlertAction actionWithTitle:obj[@"real_name"] style:style handler:^(NSInteger index) {
                    NSDictionary *dic = self.viewModel.model.volunteer_list[index];
                    [self.viewModel.virtualAccountCommand execute:dic[@"volunteer_id"]];
                }]];
            }];
            MHSheetController *alertController = [MHSheetController alertControllerWithSheetView:alertView];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    return _titleButton;
}
- (MHActivityStatusView *)bottomButton{
    if(!_bottomButton){
        @weakify(self);
        _bottomButton = [MHActivityStatusView activityViewWithStatus:MHActivityStatusViewTypeManagement actionBlock:^{
            @strongify(self);
            MHVolActivityListController *controller = [MHVolActivityListController new];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        _bottomButton.clipsToBounds = YES;
    }
    return _bottomButton;
}

- (UIImage *)barImage{
    if(!_barImage){
        _barImage = [UIImage mh_gradientImageWithBounds:CGRectMake(0, 0, MScreenW, 64) direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
    }
    return _barImage;
}
- (UIImage *)barClearImage{
    if(!_barClearImage){
        _barClearImage = [UIImage hl_imageWithUIColor:[UIColor clearColor]];
    }
    return _barClearImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



