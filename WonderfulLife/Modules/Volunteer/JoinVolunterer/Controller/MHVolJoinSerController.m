//
//  MHVolJoinSerController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolJoinSerController.h"
#import "MHCeSlectedCityController.h"
#import "MHCertificationSuccessController.h"
#import "MHVolSerDetailController.h"

#import "MHVolJoinSerLocationCell.h"
#import "MHVolJoinSerMsgCell.h"
#import "MHThemeButton.h"
#import "MHHUDManager.h"
#import "MHAlertView.h"
#import "MHVoNaviBigTitleHeaderView.h"

#import "MHVolCreateModel.h"
#import "MHVolActiveModel.h"
#import "MHCityModel.h"
#import "MHVolCreateRequest.h"
#import "MHUserInfoManager.h"
#import "MHCommunityModel.h"
#import "MHMacros.h"
#import "MHVolCreateModel.h"
#import "MHVolSerItemManager.h"

#import "UIView+EmptyView.h"
#import <YYModel.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UILabel+HLLineSpacing.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@interface MHVolJoinSerController ()<UITableViewDelegate,UITableViewDataSource,MHVolJoinChangeButtonProtocol,MHVolJoinSerSelectedProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *selecteds;
@property (strong,nonatomic) MHCommunityModel *currentCommunity;
@property (nonatomic, strong) MHCityModel *city;
@property (strong,nonatomic) MHVolSerItemManager *manager;
@property (strong,nonatomic) MHVolCreateModel *createModel;

@property (nonatomic, strong) MHVoNaviBigTitleHeaderView  *headerView;

@property (nonatomic, weak) IBOutlet MHThemeButton * nextBtn ;

// ScrollView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;
@property (weak, nonatomic) IBOutlet UILabel *scrollTitleLB;
@property (strong, nonatomic) IBOutlet UIView *scrollContentView;

/** 
 *  是否有服务项目
 *  YES:有服务项目   
 *  NO:只有公益服务
 */
@property (nonatomic, assign) BOOL  isHasSer;


@end

@implementation MHVolJoinSerController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUI];
    
    [self checkCity];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - SetUI
- (void)setUI {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolJoinSerMsgCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolJoinSerMsgCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolJoinSerLocationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolJoinSerLocationCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.headerView = [MHVoNaviBigTitleHeaderView voNaviBigTitleHeaderView];
    self.headerView.bottomLine.hidden = YES;
    self.headerView.countLB.text = @"请选择要加入的服务社区和服务项目";
    self.headerView.titleLB.text = @"参与服务项目";
    self.tableView.tableHeaderView =   self.headerView ;
    self.tableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.hidden = YES;
    
    self.nextBtn.hidden = YES;
    
    NSString *tipStr = @"您所在的社区未开通志愿者服务\n请选择其他服务社区参与服务项目";
    self.scrollTitleLB.text = tipStr;
    [self.scrollTitleLB mh_changeLineWithSpace:10.0];
    self.scrollTitleLB.textAlignment = NSTextAlignmentCenter ;
    
    self.chooseCityBtn.layer.borderWidth = 1 ;
    CGRect  chooseFrame = self.chooseCityBtn.frame ;
    self.chooseCityBtn.layer.cornerRadius = chooseFrame.size.width*0.05  ;
    self.chooseCityBtn.layer.masksToBounds = YES ;
    self.chooseCityBtn.layer.borderColor = MColorBlue.CGColor ;
    self.scrollContentView.hidden = YES;
}
#pragma mark - Private

- (void)resetActivity_list { // 遍历 activity_list 参数
    NSMutableArray *results = [NSMutableArray array];
    for (MHVolActiveModel *model in self.selecteds) {
        [results addObject:model.activity_id];
        if ([model.activity_type integerValue] == 1) {
            _isHasSer = YES;
        }
    }
    self.createModel.activity_list = [results yy_modelToJSONString];
}

#pragma mark - Event
- (IBAction)scrollBtnAction:(id)sender {
    [self didTouchUpInsideChangeButton];
}

- (IBAction)nextAction:(id)sender {
    // 弹框确认
    [[MHAlertView sharedInstance] showNormalAlertViewTitle:@"确定要申请成为志愿者？" message:@"成为志愿者后需要积极参加各类服务活动，如每年服务时长少于36小时，将会被取消志愿者资格" leftHandler:nil rightHandler:^{

        [self resetActivity_list];
        ///MARK - request
        [MHHUDManager show];
        [MHVolCreateRequest
         createdVolunterCallBack:^(BOOL success,NSString *errmsg) {
             if (success) {
                 MHCertificationSuccessType type ;
                 type = _isHasSer ? MHCertificationSuccessTypeVolSer : MHCertificationSuccessTypeVolNoSer ;
                 
                [[MHVolCreateModel sharedInstance] remove];
                
                 MHCertificationSuccessController *vc = [[MHCertificationSuccessController alloc] initWithType:type];
                 [self.navigationController pushViewController:vc animated:YES];
             } else {
                 [MHHUDManager showText:errmsg];
             }
             [MHHUDManager dismiss];
         }];
        
    } rightButtonColor:nil];
}

#pragma mark -  Request
- (void)checkCity {
    [MHHUDManager show];
    [MHVolCreateRequest checkHotCityCallBack:^(BOOL success, BOOL is_serve_community, NSString *errmsg) {
        
        if (success && is_serve_community) { // 若是经营小区 ， 直接获取数据
            [self loadTableView];
        }else{
            self.scrollContentView.hidden = NO;
        }
        [MHHUDManager dismiss];
    }];
}

- (void)loadTableView {
    [MHHUDManager show];
    [MHVolCreateRequest sendCommunityId:self.currentCommunity.community_id callBack:^(MHVolSerItemManager *manager, NSString *errmsg) {
        self.manager = manager ;
        if (errmsg) {
            [MHHUDManager showErrorText:errmsg];
        } else {
            if (manager.activity_list.count){
                self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            }else{
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH-240)];
                [footerView setBackgroundColor:[UIColor clearColor]];
                [footerView mh_addEmptyViewImageName:@"MHVolWithServerItemIcon" title:@"该小区暂无服务项目，\n请选择其他小区"];
                self.tableView.tableFooterView = footerView;
            }
            self.tableView.hidden = NO;
            self.nextBtn.hidden = NO;
            self.scrollContentView.hidden = YES;
            [self.tableView reloadData];
        }
        [MHHUDManager dismiss];
    }];
}



#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self didTouchUpInsideChangeButton];
    }else{
        MHVolSerDetailController *vc = [[MHVolSerDetailController alloc]init];
        vc.type = MHVolSerDetailTypeJoinItem;
        vc.detailId = self.manager.activity_list[indexPath.row-1].activity_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.activity_list.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    } else {
        return 129;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MHVolJoinSerLocationCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolJoinSerLocationCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.mh_titleLabel setText:[NSString stringWithFormat:@"%@%@",self.city.city_name,self.currentCommunity.community_name]];
        cell.delegate = self;
        return cell;
    } else {
        MHVolJoinSerMsgCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolJoinSerMsgCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell.mh_titleLabel setText:self.manager.activity_list[indexPath.row-1].activity_name];
        [cell.mh_subTitleLabel setText:self.manager.activity_list[indexPath.row-1].activity_summary];
        NSNumber *currentId = self.manager.activity_list[indexPath.row - 1].activity_id;
        BOOL seleced = NO;
        for (MHVolActiveModel * model in self.selecteds) {
            if ([currentId isEqualToNumber:model.activity_id]) {
               seleced = YES;
            }
        }
        if (seleced) {
            [cell.mh_imageButton setImage:[UIImage imageNamed:@"vo_supportSelect"] forState:UIControlStateNormal];
        } else {
            [cell.mh_imageButton setImage:[UIImage imageNamed:@"vo_supportNoSelect"] forState:UIControlStateNormal];
        }
        return cell;
    }
}


#pragma mark - MHVolJoinChangeButtonProtocol
- (void)didTouchUpInsideChangeButton {
    @weakify(self)
    MHCeSlectedCityController *vc = [[MHCeSlectedCityController alloc]initWithType:MHCeSlectedCityType_Vol];
    vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
        @strongify(self)
        self.city = city ;
        self.currentCommunity = community;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.selecteds removeAllObjects];
        self.nextBtn.enabled = self.selecteds.count;
        [self  loadTableView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MHVolJoinSerSelectedProtocol
- (void)didTouchUpInsideSelectedButtonIndexPath:(NSIndexPath *)indexPath {
    MHVolActiveModel * model = self.manager.activity_list[indexPath.row - 1];
    NSNumber *currentId = model.activity_id ;
    NSInteger index = -1;
    for (MHVolActiveModel *selModel in self.selecteds) {
        if ([currentId isEqualToNumber:selModel.activity_id]) {
            index = [self.selecteds indexOfObject:selModel];
        }
    }
    if (index == -1) {
        if (self.selecteds.count >= 2) {
            [MHHUDManager showText:@"每人最多只能参与2个服务项目"];
        } else {
            [self.selecteds addObject:model];
            [self.tableView reloadData];
        }
    } else {
        [self.selecteds removeObjectAtIndex:index];
        [self.tableView reloadData];
       
    }
    self.nextBtn.enabled = self.selecteds.count;
}

#pragma mark = get

- (MHCommunityModel *)currentCommunity {
    if (_currentCommunity == nil) {
        _currentCommunity = [[MHCommunityModel alloc]init];
        // 因第一次申请志愿者的时候，没有志愿者服务站，所以默认使用用户注册时所在的小区
        _currentCommunity.community_id = [MHUserInfoManager sharedManager].serve_community_id;
        _currentCommunity.community_name = [MHUserInfoManager sharedManager].serve_community_name;
    } return _currentCommunity;
}

- (MHCityModel *)city {
    if (_city == nil) {
        _city = [[MHCityModel alloc] init];
        _city.city_name = [MHUserInfoManager sharedManager].city.city_name;
    }return _city ;
}

- (NSMutableArray *)selecteds {
    if (_selecteds == nil) {
        _selecteds = [NSMutableArray array];
    } return _selecteds;
}

- (MHVolCreateModel *)createModel {
    if (_createModel == nil) {
        _createModel = [MHVolCreateModel sharedInstance];
    } return _createModel;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.constraintHeight.constant = CGRectGetMaxY(self.chooseCityBtn.frame) + 200 ;
}

@end
