//
//  XXTabBarControllerManager.m
//  BaseFramework
//
//  Created by Mantis-man on 16/1/16.
//  Copyright © 2016年 Mantis-man. All rights reserved.
//

#import "MHTabBarControllerManager.h"
#import "MHNavigationControllerManager.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "NSObject+isNull.h"

#import "MHHomeController.h"
#import "MHVolunteerController.h"
#import "MHStoreController.h"
#import "MHMineController.h"

#import "MHUserInfoManager.h"
#import "MHAreaManager.h"


#import "UIViewController+PresentLoginController.h"
#import "UIImage+Color.h"
#import "NSObject+CurrentController.h"
#import "UIViewController+MHRootNavigation.h"
#import "MHTabBarControllerManager+StoreSwitch.h"

@interface MHTabBarControllerManager()



@end


@implementation MHTabBarControllerManager

#pragma mark - Life Cycle

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (instancetype)init{
    if (self = [super init]) {

        [self setViewControllers:self.mutabControllers animated:NO];
        
        //setup delegate
        self.delegate = self;
        
        //setup config
        [self setupConfig];
        
        //obser
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginControllerAction) name:kLoginAgainNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceControllerViews) name:kReplaceViewControllerNotification object:nil];
        
        //判断是否登录且是否是简约版  未登录显示首页控制器
        if ([MHUserInfoManager sharedManager].isLogin && [[MHUserInfoManager sharedManager].is_volunteer isEqualToNumber:@1] && [MHAreaManager sharedManager].isSimplyFlag) {
            NSString *key = [NSString stringWithFormat:@"simplyFlag--%@", [MHUserInfoManager sharedManager].user_id];
            BOOL simplyFlag = [[NSUserDefaults standardUserDefaults] boolForKey:key];
            if (simplyFlag) {
                [self setSelectedIndex:1];
            } else {
                //判断是弹过窗
                NSString *key = [NSString stringWithFormat:@"showed--%@", [MHUserInfoManager sharedManager].user_id];
                BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:key];
                if (isShowed) {
                    [self setSelectedIndex:0];
                } else {
                    [self setSelectedIndex:1];
                }
            }
            [MHAreaManager sharedManager].isSimplyFlag = NO ;
            
        }else{
            [self setSelectedIndex:0];
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 配置
 */
- (void)setupConfig {
    //设置未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MColorTitle, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //设置选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MColorRed, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //    self.tabBar.clipsToBounds = YES;
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, MScreenW, 0.5)];
    [self.tabBar addSubview:line];
    line.backgroundColor = MRGBColor(211,220,230);
}
/**
 * 初始化子控制器
 */
- (MHNavigationControllerManager *)setupChildVc:(UIViewController *)curreVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIViewController *vc = (UIViewController *)curreVC;
    
    // 设置文字和图片
    vc.title = title;
    [vc.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    MHNavigationControllerManager *nav = [[MHNavigationControllerManager alloc] initWithRootViewController:vc];
    
    return nav ;
}


#pragma mark - TabBarController Delegate
/**
 禁止双击防止出现不良反应
 */
- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc {
    UIViewController *tbSelectedController = tbc.selectedViewController;
    if ([tbSelectedController isEqual:vc]) {
        return NO;
    }
    return YES;
}

/** 选择子控制器item */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    MHNavigationControllerManager *didSelectNave = (MHNavigationControllerManager*)viewController ;
    UIViewController *didSelectVC = [didSelectNave.viewControllers firstObject];
    //没有登录 且 志愿者模块 弹出登录界面
    BOOL isLogin = [MHUserInfoManager sharedManager].isLogin;
    if (!isLogin && ([didSelectVC isKindOfClass:[MHMineController class]] || [didSelectVC isKindOfClass:[MHStoreController class]])) {
        [self presentLoginController];
    }else if ([MHAreaManager sharedManager].status != 0) { // 推送是否需要 刷新tabbar
        [self mh_reloadChildControllers];
    }
}

#pragma mark - Notification imp
/**  返回登录界面，并清理缓存*/
- (void)presentLoginControllerAction {
    [[MHUserInfoManager sharedManager] removeUserInfoData];
    [[MHAreaManager sharedManager] removeAreaData];
    [self presentLoginController];
}

/** 切换控制器，把“志愿者”模块切换回初始界面 */
- (void)replaceControllerViews {
    MHVolunteerController *v = [[MHVolunteerController alloc]init];
    MHNavigationControllerManager *vNav = [self setupChildVc:v title:@"志愿者" image:@"tab_volunteer_noselect" selectedImage:@"tab_volunteer_select"] ;
    [self.viewControllers objectAtIndex:1];
    NSMutableArray *m = self.viewControllers.mutableCopy;
    [m replaceObjectAtIndex:1 withObject:vNav];
    self.viewControllers = m;
}


#pragma mark - Getter
- (MHNavigationControllerManager *)home {
    if (!_home) {
        MHHomeController *h = [[MHHomeController alloc]init];
        _home = [self setupChildVc:h title:@"首页" image:@"tab_home_noselect" selectedImage:@"tab_home_select"];
    }return _home ;
    
}

- (MHNavigationControllerManager *)volunteer {
    if (!_volunteer) {
        MHVolunteerController *v = [[MHVolunteerController alloc]init];
        _volunteer = [self setupChildVc:v title:@"志愿者" image:@"tab_volunteer_noselect" selectedImage:@"tab_volunteer_select"];
    }return _volunteer ;
    
}

- (MHNavigationControllerManager *)store {
    if (!_store) {
        MHStoreController *s = [[MHStoreController alloc]init];
        _store =  [self setupChildVc:s title:@"商城" image:@"tab_store_noselect" selectedImage:@"tab_store_select"];
    }return _store ;
}

- (MHNavigationControllerManager *)mine {
    if (!_mine) {
        MHMineController *m = [[MHMineController alloc]init];
        _mine =[self setupChildVc:m title:@"我的" image:@"tab_mine_noselect" selectedImage:@"tab_mine_select"];
    }return _mine ;
}

#pragma mark - Getter
- (NSMutableArray *)mutabControllers {
    if (!_mutabControllers) {
        if ([[MHAreaManager sharedManager] is_enable_mall_merchant]){ // 控制商城权限入口
            _mutabControllers = [NSMutableArray arrayWithObjects:self.home,self.volunteer,self.store,self.mine, nil];
        }else {
            _mutabControllers = [NSMutableArray arrayWithObjects:self.home,self.volunteer,self.mine, nil];
        }
    }
    return _mutabControllers ;
}



+ (MHTabBarControllerManager *)getMHTabbar {
        return  (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
