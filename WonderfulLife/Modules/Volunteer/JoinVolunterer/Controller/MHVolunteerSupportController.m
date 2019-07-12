//
//  MHVolunteerSupportController.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerSupportController.h"
#import "MHVolJoinSerController.h"

#import "UIViewController+MHAddRightBarButtonItem.h"
#import "UIViewController+NaviBigTitle.h"
#import "UIImage+Color.h"
#import "UIView+GradientColor.h"
#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
#import <Masonry.h>
#import <YYModel.h>

#import "MHVolunteerSupportDataSource.h"
#import "MHVolunteerSupportModel.h"
#import "MHVolunteerSupportRequestHandler.h"
#import "MHVolCreateModel.h"
#import "MHVolCreateRequest.h"
#import "MHHUDManager.h"
#import "MHUserInfoManager.h"

#import "MHVoNaviBigTitleHeaderView.h"
#import "MHThemeButton.h"

@interface MHVolunteerSupportController ()

/**
 *  数据源
 */
@property (strong,nonatomic) MHVolunteerSupportDataSource *source;


@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) MHVoNaviBigTitleHeaderView  *headerView;

/**
 *  可多选，已选 0 个  副标题
 */
@property (strong,nonatomic) UILabel *countLB;


@property (nonatomic, strong) MHThemeButton * nextBtn ;

@property (nonatomic, strong) MHVolCreateModel *create ;

@property (nonatomic, strong) MASConstraint    *bottomConstraint ;

@end

@implementation MHVolunteerSupportController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source = [MHVolunteerSupportDataSource new];    
    self.create = [MHVolCreateModel sharedInstance];

    
    [self request];

    [self setUI];
}

#pragma mark - Event

- (void)nextAction {
    MHVolJoinSerController * vc = [[MHVolJoinSerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)skipAction{
    if (self.type == MHVolunteerSupportTypeNormal) {
        self.create.support_list = nil;
        MHVolJoinSerController * vc = [[MHVolJoinSerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.type == MHVolunteerSupportTypeVolCard){
        NSAssert(self.create.support_list != nil, @"修改需要帮助 support_list 不能为空");
        [MHHUDManager show];
        [MHVolunteerSupportRequestHandler postVolSupportListRepair:self.create.support_list success:^(NSDictionary *data) {
            [MHHUDManager dismiss];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kReloadVolSerMyCardControllerDataNotification" object:nil];http://172.16.1.9/zentaopms/www/data/upload/1/201709/1318004204263oi5.png
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    }
}


#pragma mark -  Request
- (void)request{
    
    BOOL isNormalOrVolCardApi = self.type == MHVolunteerSupportTypeNormal;
    NSString *url             = isNormalOrVolCardApi?@"volunteer/support/list":@"volunteerInfo/support/list";
    NSDictionary *params      = isNormalOrVolCardApi?@{}:@{@"volunteer_id":[MHUserInfoManager sharedManager].volunteer_id};
    
    MHWeakify(self)
    [MHHUDManager show];
    /** 网络请求数据 */
    [MHVolunteerSupportRequestHandler postVolunteerSupportListWithUrl:url params:params request:^(NSArray<MHVolunteerSupportModel *> *supports) {
        MHStrongify(self)
        [self.source  volunteerSupportDataSourcWithDatas:supports  volunteerSupportBlock:^(NSMutableArray *results) {
            self.headerView.countLB.text = [NSString stringWithFormat:@"可多选，已选 %ld 个",results.count];
            self.nextBtn.enabled = results.count;
            
            NSMutableArray *newResults = [NSMutableArray array];
            for (MHVolunteerSupportModel *model in results) {
                [newResults addObject:model.support_id];
            }
            self.create.support_list = [newResults yy_modelToJSONString];
        }];
        [self.tableView reloadData];
        [MHHUDManager dismiss];
        
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}
#pragma mark - SetUI

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = self.type == MHVolunteerSupportTypeNormal ? @"跳过":@"确定";
    UIButton *jumpBtn = [self mh_addRightBarButtonItemWithTitle:title];
    [jumpBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.equalTo(self.view).offset(0);
        _bottomConstraint = make.bottom.mas_equalTo(-120);
    }];
    
    self.type == MHVolunteerSupportTypeVolCard?:[self.view addSubview:self.nextBtn];
    _bottomConstraint.offset= self.type == MHVolunteerSupportTypeVolCard?0:-120;
    [self.view layoutIfNeeded];
}


#pragma mark - Setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
        _tableView.separatorColor = MRGBColor(210, 220, 230);
        _tableView.dataSource = _source;
        _tableView.delegate = _source;
        _tableView.estimatedRowHeight = 60;//很重要保障滑动流畅性
        _tableView.rowHeight = UITableViewAutomaticDimension;
    
        _headerView = [MHVoNaviBigTitleHeaderView voNaviBigTitleHeaderView];
        _tableView.tableHeaderView = _headerView ;
        _headerView.titleLB.text = @"我需要什么";
       UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footerView ;
        
      
    }return _tableView;
}


- (MHThemeButton *)nextBtn{
    if (_nextBtn==nil) {
        /** 分割线 */
        /**
        UIView *line = [UIView new];
        line.backgroundColor = MColorSeparator ;
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).offset(0);
            make.left.right.equalTo(self.view).offset(0);
            make.height.equalTo(@0.5);
        }];
        */
        
        CGFloat btn_x = 16 ;
        CGFloat btn_h = 56 ;
        
        _nextBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(btn_x,MScreenH - btn_h - 32 + 0.5, MScreenW - btn_x*2, btn_h - 0.5)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setNeedsDisplay];
        _nextBtn.enabled = NO;
    }return _nextBtn;
}

@end
