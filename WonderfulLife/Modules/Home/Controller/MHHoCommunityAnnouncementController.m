//
//  MHHoCommunityAnnouncementController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoCommunityAnnouncementController.h"
#import "MHNavigationControllerManager.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHCommunityAnnouncementModel.h"
#import "MHCommunityAnnouncementCell.h"
#import "MHHomeRequest.h"
#import "MHHUDManager.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "MHRefreshGifHeader.h"
#import "MHAnnouncementDetailController.h"
#import "UIImage+Color.h"
#import "LCommonModel.h"
#import "Masonry.h"

#define MHCommunityAnnouncementCellID @"MHCommunityAnnouncementCellID"

@interface MHHoCommunityAnnouncementController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *mj_footer;

@property (nonatomic,strong)UIView *emptyView;

@end

@implementation MHHoCommunityAnnouncementController{
    CGFloat scale;
    NSInteger page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小区公告";
    self.view.backgroundColor = [UIColor whiteColor];
    scale = MScreenW/375;
    page = 1;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [nav navigationBarWhite];
    
    [self setupTableView];
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadData{
    [MHHUDManager show];
    [MHHomeRequest getCommunityAnnouncementWithPage:@1 Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[MHCommunityAnnouncementModel class] json:data[@"list"]];
            self.dataList = [NSMutableArray arrayWithArray:temp];
            
            [self checkToLoadEmptyView];
            
            [self.tableView reloadData];
            if ([data[@"has_next"] integerValue] == 1) {
                page = 2;
                self.tableView.mj_footer = self.mj_footer;
                [self.mj_footer resetNoMoreData];
            }
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    [MHHUDManager show];
    [MHHomeRequest getCommunityAnnouncementWithPage:@(page) Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[MHCommunityAnnouncementModel class] json:data[@"list"]];
            [self.dataList addObjectsFromArray:temp];
            
            if (temp.count) {
                [self.dataList addObjectsFromArray:temp];
                [self.mj_footer endRefreshing];
                page++;
            }else{
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self checkToLoadEmptyView];
            
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.nim_width, self.view.nim_height-65)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MHCommunityAnnouncementCell class] forCellReuseIdentifier:MHCommunityAnnouncementCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)checkToLoadEmptyView{
    if(_emptyView){
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
    if(self.dataList.count == 0){
        [self.view addSubview:self.emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHCommunityAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:MHCommunityAnnouncementCellID];
    MHCommunityAnnouncementModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHCommunityAnnouncementModel *model = self.dataList[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MHCommunityAnnouncementModel *model = self.dataList[indexPath.row];
    MHAnnouncementDetailController *vc = [[MHAnnouncementDetailController alloc] initWithUrl:model.article_url];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (MJRefreshAutoNormalFooter *)mj_footer{
    if (_mj_footer == nil) {
        _mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _mj_footer;
}

#pragma mark - 空状态下的视图
- (UIView *)emptyView{
    if(!_emptyView){
        _emptyView = [UIView new];
        _emptyView.backgroundColor = MColorToRGB(0XF9FAFC);
        UIView *bgView = [UIView new];
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"announcement_notice_empty"];
        UILabel *label = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MColorToRGB(0X99A9BF)];
        label.text = @"暂无内容";
        [bgView addSubview:imageView];
        [bgView addSubview:label];
        [_emptyView addSubview:bgView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top);
            make.left.greaterThanOrEqualTo(bgView.mas_left);
            make.right.lessThanOrEqualTo(bgView.mas_right);
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(8);
            make.left.greaterThanOrEqualTo(bgView.mas_left);
            make.right.lessThanOrEqualTo(bgView.mas_right);
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_emptyView);
        }];
        
    }
    return _emptyView;
}

@end





