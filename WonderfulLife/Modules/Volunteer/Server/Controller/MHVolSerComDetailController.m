//
//  MHVolSerComDetailController.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerComDetailController.h"

#import "MHVolSerComDetailModel.h"
#import "MHVoServerRequestDataHandler.h"
#import "UIViewController+HLNavigation.h"
#import "MHHUDManager.h"

#import "MHVolSerComDetailCell.h"

#import "UILabel+isNull.h"

@interface MHVolSerComDetailController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) MHVolSerComDetailModel  *model;
@end

@implementation MHVolSerComDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = self.headerView ;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;//很重要保障滑动流畅性
    
    [self request];
}


#pragma mark -  Request
- (void)request {
    NSDictionary *dic ;
    NSString *url ;
    if (self.type == MHVolSerComDetailTypeScoreRecord) {
        dic = @{@"score_id":self.detail_Id};
        url = @"volunteerScoreRecord/detail";
    }else{
        dic = @{@"attendance_detail_id":self.detail_Id};
        url = @"volunteerAttendanceDetail/detail";
    }
    [MHHUDManager show];
    [MHVoServerRequestDataHandler getVolunteerScoreRecordAndAttendanceDetailWithDic:dic url:url Success:^(MHVolSerComDetailModel *model, BOOL isSuccess) {
        self.model = model;
        [self.tableView reloadData];
        [MHHUDManager dismiss];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showText:errmsg];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.is_redeem && self.type == MHVolSerComDetailTypeScoreRecord) {  // 是积分兑换类
        return 3;
    }else {
        return 5;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVolSerComDetailCell *cell = [MHVolSerComDetailCell cellWithTableView:tableView];
    
     cell.rightLB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18.0];
    
    
    if (indexPath.row == 0) {
        cell.leftLB.text = @"爱心积分";
        [cell.rightLB mh_isNullWithDataSourceText:self.model.score allText:self.model.score isNullReplaceString:@"\t"];
        cell.rightLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    }
    
    if (self.model.is_redeem && self.type == MHVolSerComDetailTypeScoreRecord) {
        if (indexPath.row == 1) {
            cell.leftLB.text = @"积分说明";
            [cell.rightLB mh_isNullWithDataSourceText:self.model.score_intro allText:self.model.score_intro isNullReplaceString:@"\t"];
            [cell layoutIfNeeded];
        }else if (indexPath.row == 2) {
            cell.leftLB.text = @"兑换时间";
            [cell.rightLB mh_isNullWithDataSourceText:self.model.release_time allText:self.model.release_time isNullReplaceString:@"\t"];
        }
    }else {
        
        if (indexPath.row == 1) {
            cell.leftLB.text = @"服务时长";
            [cell.rightLB mh_isNullWithDataSourceText:self.model.duration allText:self.model.duration isNullReplaceString:@"\t"];
            cell.rightLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
        }
        else if (indexPath.row == 2) {
            cell.leftLB.text = @"积分说明";
            [cell.rightLB mh_isNullWithDataSourceText:self.model.score_intro allText:self.model.score_intro isNullReplaceString:@"\t"];
            [cell layoutIfNeeded];
        }
        else if (indexPath.row == 3) {
            cell.leftLB.text = @"服务队";
            [cell.rightLB mh_isNullWithDataSourceText:self.model.team_name allText:self.model.team_name isNullReplaceString:@"\t"];
        }
        else if (indexPath.row == 4) {
            cell.leftLB.text = @"发放时间";
            [cell.rightLB mh_isNullWithDataSourceText:self.model.release_time allText:self.model.release_time isNullReplaceString:@"\t"];
        }
        
        
    }
    return cell;
}


@end
