//
//  MHVolSerItemController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerItemController.h"
#import "MHCeSlectedCityController.h"
#import "MHVolSerDetailController.h"

#import "MHVolJoinSerLocationCell.h"
#import "MHVolSerItemCell.h"
#import "MHEmptyFooterView.h"

#import <UIViewController+HLNavigation.h>
#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"
#import "UIView+EmptyView.h"

#import "MHMacros.h"
#import "MHVolCreateRequest.h"
#import "MHVolActiveModel.h"
#import "MHCommunityModel.h"
#import "MHUserInfoManager.h"
#import "MHCityModel.h"
#import "MHVolSerItemManager.h"

@interface MHVolSerItemController ()<MHVolJoinChangeButtonProtocol,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) MHCommunityModel *currentCommunity;
@property (nonatomic, strong) MHCityModel  *city;

@property (strong,nonatomic) MHVolSerItemManager *manager;
@end

@implementation MHVolSerItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolJoinSerLocationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolJoinSerLocationCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolSerItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolSerItemCell class])];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self loadTableView];
}

- (void)loadTableView {
    MHWeakify(self)
    [MHHUDManager show];
    [MHVolCreateRequest sendCommunityId:self.currentCommunity.community_id callBack:^(MHVolSerItemManager *manager, NSString *errmsg) {
        self.manager = manager ;
        if (errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        } else {
            if (manager.activity_list.count) {
                [weak_self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                weak_self.tableView.tableFooterView = [UIView new];
            } else {
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH-240)];
                [footerView setBackgroundColor:[UIColor clearColor]];
                [footerView mh_addEmptyViewImageName:@"MHVolWithServerItemIcon" title:@"该小区暂无服务项目，\n请选择其他小区"];
                weak_self.tableView.tableFooterView = footerView;
            }
            [self.tableView reloadData];
            [MHHUDManager dismiss];
        }
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        // Lo 2017.08.24  产品说不能切换城市（别删代码，此处有坑）
        // Lo 2017.10.30  产品又说可以切换城市了（果然，😁😁😁）
        if(self.manager.isSelectCity)[self didTouchUpInsideChangeButton];
        
    }else{
        MHVolActiveModel * model = self.manager.activity_list[indexPath.row-1] ;
        MHVolSerDetailController *vc = [[MHVolSerDetailController alloc]init];
        vc.type = MHVolSerDetailTypeItem;
        vc.detailId = model.activity_id;
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
        return 130;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MHVolJoinSerLocationCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolJoinSerLocationCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.mh_titleLabel setText:[NSString stringWithFormat:@"%@%@",self.city.city_name,self.currentCommunity.community_name]];
        cell.mh_button.hidden = ! self.manager.isSelectCity;
        cell.delegate = self;
        return cell;
    } else {
        MHVolSerItemCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolSerItemCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MHVolActiveModel * model = self.manager.activity_list[indexPath.row-1];
        [cell.mh_titleLabel setText:model.activity_name];
        [cell.mh_subTitleLabel setText:model.activity_summary];
        return cell;
    }
}




#pragma mark - MHVolJoinChangeButtonProtocol

- (void)didTouchUpInsideChangeButton {
    MHWeakify(self)
    MHCeSlectedCityController *vc = [[MHCeSlectedCityController alloc]initWithType:MHCeSlectedCityType_Vol];
    vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
        MHStrongify(self)
        self.currentCommunity = community;
        self.city = city ;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self  loadTableView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - get

- (MHCommunityModel *)currentCommunity {
    if (_currentCommunity == nil) {
        _currentCommunity = [[MHCommunityModel alloc]init];
        _currentCommunity.community_id = [MHUserInfoManager sharedManager].serve_community_id;
        _currentCommunity.community_name = [MHUserInfoManager sharedManager].serve_community_name;
    } return _currentCommunity;
}

- (MHCityModel *)city{
    if (_city == nil) {
        _city = [[MHCityModel alloc] init];
        _city.city_name = [MHUserInfoManager sharedManager].city.city_name;
    }return _city ;
}
@end
