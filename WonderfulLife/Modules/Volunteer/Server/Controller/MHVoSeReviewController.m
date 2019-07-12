//
//  MHVoSeReviewController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeReviewController.h"
#import "MHVolSerReviewDetailController.h"

#import "MHVoSeReviewCell.h"
#import "MHVoSeReviewButtonView.h"
#import "UIView+EmptyView.h"

#import "MHVoServerRequestDataHandler.h"
#import "MHVolSerReviewModel.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"

#import "UIViewController+MHConfigControls.h"
#import "UIView+MHFrame.h"

#import <MJRefresh.h>

@interface MHVoSeReviewController ()
@property (nonatomic, strong) UITableView *reviewedTableView;
@property (nonatomic, strong) MHVoSeReviewButtonView *buttonView;

@property (nonatomic, strong) NSNumber *reviewPage;
@property (nonatomic, strong) NSNumber *reviewedPage;

@property (nonatomic, strong) NSMutableArray *dataSource_0;
@property (nonatomic, strong) NSMutableArray *dataSource_1;
@end

@implementation MHVoSeReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addControls];
    [self layoutControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadVolunteerReviewPageNotification object:nil];
    //reqeust
    [self reqeustApplyListWithType:0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addControls {
    [self mh_createTitleLabelWithTitle:@"审核人员加入"];
    [self mh_createTalbeView];
    
    [self.view addSubview:({
        MHVoSeReviewButtonView *v = [MHVoSeReviewButtonView voSeReviewButtonView];
        v.frame = CGRectMake(0, 145, MScreenW, 40);
        MHWeakify(self)
        v.clickReviewBlock = ^(){
            MHStrongify(self)
            [self.reviewedTableView removeFromSuperview];
            self.reviewPage = nil;
            [self reqeustApplyListWithType:0];
        };
        v.clickReviewedBlock = ^(){
            MHStrongify(self)
            
            [self.view addSubview:self.reviewedTableView];
            //reqeust
            self.reviewedPage = nil;
            [self reqeustApplyListWithType:1];
           
        };
        self.buttonView = v;
    })];
    
}

- (void)layoutControls {
    self.tableView.mh_y = 185;
    self.tableView.mh_h = MScreenH - 185;
    self.tableView.rowHeight = 247 + 11;
    self.tableView.backgroundColor = MColorBackgroud;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Request
- (void)reqeustApplyListWithType:(NSInteger)type {
    static NSNumber *page = nil;
    if (type == 0) {
        page = self.reviewPage;
    } else {
        page = self.reviewedPage;
    }
    [MHHUDManager show];
    [MHVoServerRequestDataHandler getVolunteerApplyListWithType:type page:page Success:^(NSArray *dataSource, BOOL hasNext, NSNumber *lastId){
        [MHHUDManager dismiss];
        if (type == 0) {
            if (self.reviewPage) {
                [_dataSource_0 addObjectsFromArray:dataSource];
            } else {
                [_dataSource_0 removeAllObjects];
                [_dataSource_0 addObjectsFromArray:dataSource];
            }
            self.reviewPage = lastId;
            [self.tableView reloadData];
            
            [self p_reviewRefreshStateNextPageIsHasData:hasNext];
        } else {
            if (self.reviewedPage) {
                [_dataSource_1 addObjectsFromArray:dataSource];
            } else {
                [_dataSource_1 removeAllObjects];
                [_dataSource_1 addObjectsFromArray:dataSource];
            }
            self.reviewedPage = lastId;
            [self.reviewedTableView reloadData];
            
            [self p_reviewedRefreshStateNextPageIsHasData:hasNext];
        }
       
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      if (self.tableView == tableView) {
          if (self.dataSource_0.count == 0) {
              [self.view mh_addEmptyViewImageName:@"vo_se_empty_review" title:@"暂无人员审核"];
          } else {
              [self.view mh_removeEmptyView];
          }
          return self.dataSource_0.count;
      } else if (self.reviewedTableView == tableView) {
          if (self.dataSource_1.count == 0) {
              [self.view mh_addEmptyViewImageName:@"vo_se_empty_review" title:@"暂无人员审核"];
          } else {
              [self.view mh_removeEmptyView];
          }
         return self.dataSource_1.count;
      }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVoSeReviewCell *cell;
    if (self.tableView == tableView) {
        cell = [MHVoSeReviewCell cellWithTableView:tableView];
        cell.cellType = MHVoSeReviewCellTypeReview;
        cell.model = self.dataSource_0[indexPath.row];
    } else {
        cell = [MHVoSeReviewCell cellWithTableView:tableView];
        cell.cellType = MHVoSeReviewCellTypeReviewed;
        cell.model = self.dataSource_1[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        MHVolSerReviewModel *model = self.dataSource_0[indexPath.row];
        MHVolSerReviewDetailController *vc = [[MHVolSerReviewDetailController alloc] init];
        vc.type = MHVolSerReviewDetailControllerReview;
        vc.applyId = model.apply_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MHVolSerReviewModel *model = self.dataSource_1[indexPath.row];
        MHVolSerReviewDetailController *vc = [[MHVolSerReviewDetailController alloc] init];
        
        
        if ([model.status isEqualToNumber:@1]) {
        vc.type = MHVolSerReviewDetailControllerPass;
        }else if ([model.status isEqualToNumber:@2]){
        vc.type = MHVolSerReviewDetailControllerRefuse;
        }else if ([model.status isEqualToNumber:@3]){
            vc.type = MHVolSerReviewDetailControllerBack;
        }
        vc.applyId = model.apply_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Notification IMP
- (void)reloadData {
    //reqeust
    self.reviewPage = nil;
    self.reviewedPage = nil;
//    [self reqeustApplyListWithType:0];
    
    //设置选择已审核
    [self.buttonView clickReviewedButton];
}

#pragma mark - Private
- (void)p_reviewRefreshStateNextPageIsHasData:(BOOL )has{
    if (has && !self.tableView.mj_footer ) {
        MHWeakify(self);
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            MHStrongify(self);
          [self reqeustApplyListWithType:0];
        }];
    }
    if (!has) {
        self.tableView.mj_footer = nil;
    }
}

- (void)p_reviewedRefreshStateNextPageIsHasData:(BOOL )has{
    if (has && !self.reviewedTableView.mj_footer ) {
        MHWeakify(self);
        self.reviewedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            MHStrongify(self);
            [self reqeustApplyListWithType:1];
        }];
    }
    if (!has) {
        self.reviewedTableView.mj_footer = nil;
    }
}

#pragma mark - Getter
- (UITableView *)reviewedTableView {
    if (!_reviewedTableView) {
        _reviewedTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _reviewedTableView.mh_y = 185;
        _reviewedTableView.mh_h = MScreenH - 185;
        _reviewedTableView.delegate = self;
        _reviewedTableView.dataSource = self;
        _reviewedTableView.rowHeight = 194 + 11;
         _reviewedTableView.backgroundColor = MColorBackgroud;
        _reviewedTableView.tableFooterView = [UIView new];
    }
    return _reviewedTableView;
}

- (NSMutableArray *)dataSource_0 {
    if (!_dataSource_0) {
        _dataSource_0 = [NSMutableArray array];
    }
    return _dataSource_0;
}

- (NSMutableArray *)dataSource_1 {
    if (!_dataSource_1) {
        _dataSource_1 = [NSMutableArray array];
    }
    return _dataSource_1;
}
@end
