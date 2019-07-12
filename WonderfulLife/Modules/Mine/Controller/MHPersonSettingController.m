//
//  MHPersonSettingController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHPersonSettingController.h"
#import "LPasswordSetViewController.h"
#import "MHMiShareController.h"
#import "MHMiShowMsgNotiController.h"
#import "MHMiAboutUsController.h"
#import "MHLoginController.h"
#import "MHMineController.h"

#import "MHNavigationControllerManager.h"
#import "MHAreaManager.h"
#import "JFCacheManager.h"
#import "MHMineRequestHandler.h"
#import "MHUserInfoManager.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "UIView+NIM.h"
#import "MHHUDManager.h"
#import "UIImage+Color.h"
#import "MHJPushRequestHandle.h"
#import "NSObject+CurrentController.h"
#import "MHMineCell.h"
#import "MHWeakStrongDefine.h"
@interface MHPersonSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat cache;

@property (nonatomic, assign) NSInteger isVolunteerFlagCount; //志愿者标识计数，是志愿者计数为0，非志愿者计数为-1
@property (nonatomic, strong) UITableViewCell *switchCell;
@end
@implementation MHPersonSettingController{
    CGFloat scale;
    JFCacheManager *cacheManager;
}

static NSString *MHMineCellID = @"MHMineCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (iOS8) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:MColorTitle}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:17],NSForegroundColorAttributeName:MColorTitle}];
    }
    
    scale = MScreenW/375;
    self.title = @"个人设置";
    [self setupTableView];
    [self setupFooterView];
    
    cacheManager = [[JFCacheManager alloc] init];
    [cacheManager showCachesWithComplete:^(BOOL success, CGFloat cache) {
        _cache = cache;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    //计数赋值
    self.isVolunteerFlagCount = ({
        [[MHUserInfoManager sharedManager].is_volunteer isEqualToNumber:@1] ? 0 : -1;
    });

}
#pragma mark - override
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage mh_imageWithColor:[UIColor clearColor]];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - 按钮点击
- (void)clearCache {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"确定要清除缓存？" attributes:@{NSFontAttributeName:MFont(14),NSForegroundColorAttributeName:MRGBColor(153, 169, 191)}];
    [alert setValue:attr forKey:@"attributedMessage"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [cacheManager clearCachesWithComplete:^(BOOL success, CGFloat cache) {
            if (success) {
                [MHHUDManager showText:@"清除缓存成功"];
                _cache = cache;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [MHHUDManager showErrorText:@"操作失败"];
            }
        }];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action2];
    
    if (iOS8_2_OR_LATER) {
        [action1 setValue:MColorTitle forKey:@"titleTextColor"];
        [action2 setValue:MColorTitle forKey:@"titleTextColor"];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logOut{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"是否退出登录" attributes:@{NSFontAttributeName:MFont(14),NSForegroundColorAttributeName:MRGBColor(153, 169, 191)}];
    [alert setValue:attr forKey:@"attributedMessage"];
    MHWeakify(self)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MHHUDManager show];
        [MHMineRequestHandler GetLogOutSuccess:^(NSDictionary *data) {
            MHStrongify(self)
            //发送通知，更新志愿者首页界面
             [[NSNotificationCenter defaultCenter] postNotificationName:kReplaceViewControllerNotification object:nil];
            // 注销jpush 转为游客状态接收jpush推送
            [MHJPushRequestHandle JPushUnReg:nil];
            [MHHUDManager dismiss];
            [[MHUserInfoManager sharedManager] removeUserInfoData];
            [[MHAreaManager sharedManager] removeAreaData];
            
            // Lo  2017.7.30  刷新首页界面数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeControllerDataNotification object:nil];

            //斌斌 刷新商城
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadStoreHomeNotification object:nil];
            
            MHMineController *vc = (MHMineController *)self.navigationController.childViewControllers[0];
            !vc.refreshBlock ? : vc.refreshBlock();
            MHNavigationControllerManager *nav = [[MHNavigationControllerManager alloc] initWithRootViewController:[MHLoginController new]];
            [vc presentViewController:nav animated:YES completion:nil];
            
            UITabBarController *tabbarVC = (UITabBarController *)WINDOW.rootViewController;
            tabbarVC.selectedIndex = 0;
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popToRootViewControllerAnimated:NO];            
            [self dismissViewControllerAnimated:NO completion:^{
                [NSObject mh_enterMainUI];
            }];
            
        } Failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action2];
    
    if (iOS8_2_OR_LATER) {
        [action1 setValue:MColorTitle forKey:@"titleTextColor"];
        [action2 setValue:MColorTitle forKey:@"titleTextColor"];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

//beelin 2017.8.10
- (void)shootAction:(UISwitch *)swi {
    NSString *simplyFlagKey = [NSString stringWithFormat:@"simplyFlag--%@", [MHUserInfoManager sharedManager].user_id];
    [[NSUserDefaults standardUserDefaults] setBool:swi.on forKey:simplyFlagKey];
    
    NSString *showedKey = [NSString stringWithFormat:@"showed--%@", [MHUserInfoManager sharedManager].user_id];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showedKey];

}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return  [[MHUserInfoManager sharedManager].is_volunteer isEqualToNumber:@1] ? 6 : 6-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMineCell *cell = [tableView dequeueReusableCellWithIdentifier:MHMineCellID];
    if (indexPath.row == 0 + self.isVolunteerFlagCount) {
        return self.switchCell;
    } else if (indexPath.row == 1+ self.isVolunteerFlagCount) {
        cell.titleLabel.text = @"消息提醒";
        cell.detailLabel.text = @"";
    }else if (indexPath.row == 2 + self.isVolunteerFlagCount) {
        cell.titleLabel.text = @"清除缓存";
//        cell.detailLabel.text = [NSString stringWithFormat:@"%.2lfM",_cache]; // 缓存多少暂时不显示
         cell.detailLabel.text = @"";
    }else if (indexPath.row == 3 + self.isVolunteerFlagCount) {
        cell.titleLabel.text = @"密码设置";
        cell.detailLabel.text = @"";

    }else if (indexPath.row == 4 + self.isVolunteerFlagCount) {
        cell.titleLabel.text = @"分享给好友";
        cell.detailLabel.text = @"";
    }else if (indexPath.row == 5 + self.isVolunteerFlagCount) {
        cell.titleLabel.text = @"关于我们";
        cell.detailLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1+ self.isVolunteerFlagCount) {
        [self.navigationController pushViewController:[MHMiShowMsgNotiController new] animated:YES];
    }else if (indexPath.row == 2+ self.isVolunteerFlagCount){
        [self clearCache];
    }else if (indexPath.row == 3+ self.isVolunteerFlagCount){
        //密码设置
        //是否设置支付密码，0表示未设置，1表示已设置
        NSInteger is_set_pay_password = [[MHUserInfoManager sharedManager].is_set_pay_password integerValue];
        LPasswordSetViewController *passwordSetVC = [[LPasswordSetViewController alloc] initWithPasswordSetType:is_set_pay_password?PasswordReSet:PasswordSet];
        [self.navigationController pushViewController:passwordSetVC animated:YES];
    }else if (indexPath.row == 4+ self.isVolunteerFlagCount){
        [self.navigationController pushViewController:[MHMiShareController new] animated:YES];
    }else if (indexPath.row == 5 + self.isVolunteerFlagCount) {
        [self.navigationController pushViewController:[MHMiAboutUsController new] animated:YES];
    }
}

#pragma mark - private
- (void)setupTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, self.view.nim_height-64)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = 80*scale;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MHMineCell class] forCellReuseIdentifier:MHMineCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)setupFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.nim_width, 100*scale)];
    UIButton *logOutButton = [[UIButton alloc] init];
    logOutButton.nim_size = CGSizeMake(327*scale, 64*scale);
    logOutButton.nim_bottom = footerView.nim_height;
    logOutButton.nim_centerX = footerView.nim_width/2;
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutButton setTitleColor:MColorTitle forState:UIControlStateNormal];
    logOutButton.titleLabel.font = MFont(19*scale);
    logOutButton.layer.cornerRadius = 6*scale;
    logOutButton.layer.masksToBounds = YES;
    logOutButton.layer.borderColor = MRGBColor(211, 220, 230).CGColor;
    logOutButton.layer.borderWidth = 1;
    [footerView addSubview:logOutButton];
    
    [logOutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = footerView;
}


//beelin  cell行数太少，只有一行，无需复用
- (UITableViewCell *)switchCell {
    if (!_switchCell) {
        _switchCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
       //保持与斌哥的cell同步
        [_switchCell.contentView addSubview:({
            //title
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"志愿者简约版模式";
            titleLabel.font = MFont(17*scale);
            titleLabel.textColor = MColorTitle;
            
            [titleLabel sizeToFit];
            titleLabel.nim_left = 24*scale;
            titleLabel.nim_centerY = 80/2*scale;
            titleLabel;
        })];
        [_switchCell.contentView addSubview:({
            //line
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = MRGBColor(229, 233, 242);
            line.frame = CGRectMake(0, 80*scale-0.5, self.view.nim_width, 0.5);
            line;
        })];
        
        //需求添加开关
        _switchCell.accessoryView = ({
            UISwitch *swi = [UISwitch new];
            NSString *key = [NSString stringWithFormat:@"simplyFlag--%@", [MHUserInfoManager sharedManager].user_id];
            BOOL simplyFlag = [[NSUserDefaults standardUserDefaults] boolForKey:key];
            swi.on = simplyFlag;
            [swi addTarget:self action:@selector(shootAction:) forControlEvents:UIControlEventValueChanged];
            swi;
        });
    }
    return _switchCell;
}

@end





