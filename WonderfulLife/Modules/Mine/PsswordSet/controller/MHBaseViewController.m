//
//  MHBaseViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"
#import "UIImage+HLColor.h"
#import "MHNavigationControllerManager.h"
#import "UIViewController+HLNavigation.h"

@interface MHBaseViewController ()

@property (nonatomic,strong)UIImageView *mh_nav_bottomView;

@end

@implementation MHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self mh_setUpUI];
    
    [self mh_bindViewModel];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self mh_resetNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setNaviBottomLineColor:[UIColor clearColor]];
    /*
    if(!_mh_nav_bottomView){
        UIImageView *nav_lineView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        if(nav_lineView){
             _mh_nav_bottomView = [nav_lineView viewWithTag:999999];
        }
    }
    if(_mh_nav_bottomView){
        _mh_nav_bottomView.hidden = YES;
    }
    
    UIImageView *imageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    if(imageView){
        imageView.hidden = YES;
    }
     */
}

- (void)mh_resetNavigationBar{
    /*
    if(self.navigationController){
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self setNaviBottomLineColor:[UIColor whiteColor]];
    }
     */
    
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self setNaviBottomLineColor:[UIColor whiteColor]];
}
/*
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        
        return (UIImageView *)view;
        
    }
    
    for (UIView *subview in view.subviews) {
        
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        
        if (imageView) {
            
            return imageView;
            
        }
        
    }
    
    return nil;
    
}
 */

//子类重写
- (void)mh_setUpUI{
    
}
//子类重写
- (void)mh_bindViewModel{
    
}

- (void)resetBackNaviItem{
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(nav_back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
//子类重写此方法
- (void)nav_back{
    
}
//设置导航底部的线条颜色
- (void)setNaviBottomLineColor:(UIColor *)color{
    
    [self hl_setNavigationItemLineColor:color];
    
    /*
    if(!self.navigationController.navigationBar) return;
    
    if(!_mh_nav_bottomView){
        
        UIImageView *nav_lineView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        if(nav_lineView){
            nav_lineView.hidden = NO;
            _mh_nav_bottomView = [nav_lineView viewWithTag:999999];
            if(!_mh_nav_bottomView){
                _mh_nav_bottomView = [[UIImageView alloc] init];
                _mh_nav_bottomView.tag = 999999;
                [nav_lineView addSubview:_mh_nav_bottomView];
                nav_lineView.clipsToBounds = NO;
                
                [_mh_nav_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.right.top.equalTo(nav_lineView);
                    make.height.equalTo(@1);
                    
                }];
            }
            
        }
    }
    UIImageView *imageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    if(imageView){
        imageView.hidden = NO;
    }
    _mh_nav_bottomView.hidden = NO;
    _mh_nav_bottomView.backgroundColor = color;
     */
    
}

//设置导航底部的线条颜色,颜色为分割线颜色
- (void)setNaviBottomLineDefaultColor{
    
    [self setNaviBottomLineColor:MColorSeparator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
